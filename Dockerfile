# alpine
FROM alpine:latest
RUN apk add python3 && python3 -m ensurepip
RUN pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
ADD . /
CMD python3 main.py





