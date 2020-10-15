# alpine
#FROM alpine:latest
## - FROM alpine:latest
## 1.非debug模式无法启动
## 2.debug模式下进入terminal 无法读取485数据但是能正常publish mqtt topic
## 3.无法自启动（Docker yes，IOx no）
#RUN apk add python3 && python3 -m ensurepip
#RUN pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
#ADD . /tools/
#CMD cd /tools/ && python3 main.py

#FROM  python:rc-alpine3.12
### - FROM python:rc-alpine3.12
### 1.非debug模式 nat无法获取ip
### 2.debug 模式有ip，termial 中无python3
#FROM python:3.8.5-alpine3.12
## - FROM python:3.8.5-alpine3.12
## 1.非debug模式 nat无法获取ip
## 2.debug 模式有ip，termial 中无python3
##FROM python:3.7.5-buster
#RUN pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
#ADD . /tools/
#CMD cd /tools/ && python3 main.py


# centos
#FROM centos
#RUN yum install  -y python3
##RUN yum install  python3 && python3 -m ensurepip
#RUN pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
#ADD . /tools/
#CMD cd /tools/ && python3 main.py



# Cisco
# error:libgcc_s.so.1 must be installed for pthread_cancel to work
#        -- UN opkg  install libgcc

# 1
FROM devhub-docker.cisco.com/iox-docker/ir800/base-rootfs:latest
RUN opkg update && opkg install python3 && opkg install python3-pip
RUN opkg  install libgcc
RUN pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
ADD . /tools/
#RUN chmod 777 /tools/main.py
CMD  python3 /tools/main.py
#COPY *.* /usr/bin/
#RUN chmod +x /usr/bin/main.py
#CMD python3 /usr/bin/main.py


## 2.
#FROM devhub-docker.cisco.com/iox-docker/ir800/base-rootfs:latest
#RUN opkg update
#RUN opkg install python3
#RUN opkg install python3-pip
#RUN opkg  install libgcc
#RUN pip3 install  modbus_tk
#RUN pip3 install paho-mqtt
#RUN pip3 install pyserial
#ADD *.* /tools/
##RUN chmod 777 /tools/main.py
#CMD python3 /tools/main.py
##COPY *.* /usr/bin/
##RUN chmod +x /usr/bin/main.py
##CMD python3 /usr/bin/main.py