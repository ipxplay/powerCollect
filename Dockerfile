## alpine
#FROM alpine:latest
#RUN apk add python3 && python3 -m ensurepip
#RUN pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
#ADD . /tools/
#CMD cd /tools/ && python3 main.py

# alpine
FROM python:rc-alpine3.12
RUN pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
ADD . /tools/
CMD cd /tools/ && python3 main.py



