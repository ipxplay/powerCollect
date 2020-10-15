#!/usr/bin/python
# -*- coding: UTF-8 -*-

import serial
import modbus_tk.defines as cst
from modbus_tk import modbus_rtu
import logging
from threading import Timer
import devInfo
import interface
import struct
import time
import json


class PowerMeter(object):
    def __init__(self):
        self.phaseA_voltage = 0
        self.phaseA_current = 0
        self.Power_active = 0
        self.Power_reactive = 0
        self.Power_total = 0
        self.Power_factor = 0


class BaseDevice(object):

    def __init__(self,
                 port,
                 baudrate,
                 name,
                 reconnect_period,
                 update_period):
        self.name = name
        try:
            self.client = modbus_rtu.RtuMaster(serial.Serial(port=port,
                                                             baudrate=baudrate,
                                                             bytesize=8,
                                                             parity='N',
                                                             stopbits=2,
                                                             xonxoff=0))
            self.client.set_timeout(5.0)
            self.client.set_verbose(True)
        except Exception as e:
            logging.error(str(e))
        self.reconnect_period = reconnect_period
        self.update_period = update_period
        self.slave_id = devInfo.get_desk_number()
        self.publish_topic = 'IR829/' + str(self.slave_id) + '/TX'
        self.interface = interface.iMQTT('IR829/' + str(self.slave_id) + '/TX', self.name)
        self.powerMeter = PowerMeter()
        self.result = 0

    def update(self):
        buf = []
        # 创建 空list 32个字节
        # 如果仅读取电压电流只需要8字节，sizeof(float) = 4
        for i in range(32):
            buf.append(0)
        try:
            rsp_ = self.client.execute(1, cst.READ_HOLDING_REGISTERS, 8192, 4)
            logging.info(rsp_)
            # 将读取的tuple 转换为 list 每元素2bytes
            temp_list = list(tuple(rsp_))
            # 拆解2 bytes的list为1 byte的list
            for i in range(2):
                buf[i * 4 + 3] = temp_list[i * 2 + 1].to_bytes(2, 'little')[0]
                buf[i * 4 + 2] = temp_list[i * 2 + 1].to_bytes(2, 'little')[1]
                buf[i * 4 + 1] = temp_list[i * 2].to_bytes(2, 'little')[0]
                buf[i * 4 + 0] = temp_list[i * 2].to_bytes(2, 'little')[1]
            # 将byte list转换为bytes
            temp_bytes = bytes(buf)
            # bytes 转换为 flaot
            self.powerMeter.phaseA_voltage = struct.unpack_from('>f', temp_bytes, 0)[0]
            self.powerMeter.phaseA_current = struct.unpack_from('>f', temp_bytes, 4)[0]

            if self.powerMeter.phaseA_voltage - 220 <= 10 or  self.powerMeter.phaseA_voltage - 220 >= -10:
                self.result = 1
            else:
                self.result = 0

            dev_msg = {
                "version": "1",
                "edgeTime": int(time.time()),
                "meters": {
                    "voltage": self.powerMeter.phaseA_voltage,
                    "current": self.powerMeter.phaseA_current,
                    "power": {
                        "total": self.powerMeter.Power_total,
                        "active": self.powerMeter.Power_active,
                        "reactive": self.powerMeter.Power_reactive,
                    },
                    "factor": self.powerMeter.Power_factor
                },
                "result": self.result,
                "step": 0,
                "index": 6
            }
            logging.debug("Data: " + str(dev_msg))
            # send to mqtt server
            self.interface.send_msg(json.dumps(dev_msg))
        except:
            dev_msg = {
                "version": "1",
                "edgeTime": int(time.time()),
                "msg": "Read registers error!"
            }
            logging.error("Data: " + str(dev_msg))
            # send to mqtt server
            self.interface.send_msg(json.dumps(dev_msg))
        t = Timer(self.update_period, self.update)
        t.start()
