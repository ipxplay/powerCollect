FROM centos:latest
RUN yum install -y python3 && pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
ADD . /tools/
CMD cd /tools/ && python3 main.py




