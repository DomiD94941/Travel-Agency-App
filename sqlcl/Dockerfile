FROM oraclelinux:8-slim

RUN microdnf install -y \
    java-17-openjdk \
    unzip \
    wget \
    bash \
    && microdnf clean all

RUN wget -q https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip -O /tmp/sqlcl.zip \
    && unzip /tmp/sqlcl.zip -d /opt \
    && ln -s /opt/sqlcl/bin/sql /usr/local/bin/sql \
    && rm /tmp/sqlcl.zip

ENTRYPOINT ["/usr/bin/env", "bash"]
