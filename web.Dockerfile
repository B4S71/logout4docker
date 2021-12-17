FROM ubuntu:21.04 as webserver-builder
RUN mkdir /opt/build_logout4shell
WORKDIR /opt/build_logout4shell
RUN apt-get update && apt-get install -y git default-jdk maven && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN git clone https://github.com/cybereason/Logout4Shell.git && cd ./Logout4Shell && mvn package && ls ./target/classes


FROM ubuntu:21.04 as webserver
RUN apt-get update && apt-get install -y python3 && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN mkdir -p /opt/webserver/
COPY --from=webserver-builder /opt/build_logout4shell/Logout4Shell/target/classes/* /opt/webserver/
WORKDIR /opt/webserver
ENTRYPOINT ["python3", "-m", "http.server", "8888"] 
