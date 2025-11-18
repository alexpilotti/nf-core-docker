FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
   python3 python3-pip python3-venv \
   git curl ca-certificates gnupg \
   default-jre \
   libatomic1 && \
   rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
chmod a+r /etc/apt/keyrings/docker.asc
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) stable" \
  > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y --no-install-recommends \
    docker-ce-cli && \
    rm -rf /var/cache/apt/archives /var/lib/apt/lists/*
RUN curl -s https://get.nextflow.io | bash
RUN chmod +x nextflow && mv nextflow /bin/
RUN mkdir /nextflow
ENV NXF_HOME=/nextflow
ENV NXF_VER=25.10.0
ENV NXF_OPTS="-Xms1g -Xmx4g"
RUN nextflow self-update
RUN python3 -m venv /venv
ENV VIRTUAL_ENV=/venv
ENV PATH=/venv/bin:$PATH
RUN pip install nf-core
