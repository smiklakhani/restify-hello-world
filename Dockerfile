# Docker file for restify helloworld service 

FROM 10.137.84.145:8082/centos:centos7

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install nodejs npm; yum clean all

RUN npm install pm2 -g

WORKDIR /app
ADD . .

RUN npm install

EXPOSE 8080
CMD ["pm2-docker", "index.js"]
