#!/usr/bin/python
# -*- coding: UTF-8 -*-

import logging
import devInfo
import iCounter


logging.basicConfig(level=logging.DEBUG)

device = []

if __name__ == '__main__':

    _dev_array = devInfo.get_dev()
    for _dev in _dev_array:
        device.append(iCounter.BaseDevice(
            _dev['port'],
            _dev['baudrate'],
            _dev['DeviceName'],
            devInfo.get_time()['reconnect'],
            devInfo.get_time()['telemetry']))
        logging.info("dev : %s installed !" % str(_dev['DeviceName']))
        device[-1].update()
        # device[-1].reconnect()
