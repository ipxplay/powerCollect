#FROM centos:latest
#RUN yum install -y python3 && pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
#ADD . /tools/
#CMD cd /tools/ && python3 main.py

# alpine
FROM alpine:latest
RUN apk add python3 && python3 -m ensurepip
RUN pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
ADD . /tools/
CMD cd /tools/ && python3 main.py

#python
#FROM python:rc-alpine3.12
#RUN pip3 install  modbus_tk && pip3 install paho-mqtt && pip3 install pyserial
#ADD config.json /tools/
#ADD devInfo.py /tools/
#ADD Dockerfile /tools/
#ADD iCounter.py /tools/
#ADD interface.py /tools/
#ADD main.py /tools/
##RUN rm -rf /tools/venv
#CMD cd /tools/ && python3 main.py

#FROM devhub-docker.cisco.com/iox-docker/ir800/base-rootfs:latest





