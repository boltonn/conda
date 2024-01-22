FROM amazonlinux:2

ENV PYTHONDONTWRITEBYTECODE 1

ARG MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

RUN curl -kLso /tmp/miniconda.sh $MINICONDA_URL && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm -f /tmp/miniconda.sh && \
    /opt/conda/bin/conda install -y --freeze-installed tini && \
    /opt/conda/bin/conda clean -afy && \
    yum install -y findutils && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.pyc' -delete && \
    yum clean all && \
    chown -R root:root /opt/conda && \
    mkdir -p /opt/conda/pkgs/cache && \
    touch /opt/conda/pkgs/cache/urls.txt

ENV PATH /opt/conda/bin:$PATH
# RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.profile
# RUN conda init bash

# # SHELL [ "/bin/bash", "--login", "-c" ]

# COPY entrypoint.sh /opt/docker/bin/entrypoint.sh
# RUN chmod 0755 /opt/docker/bin/entrypoint.sh
# ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]
# CMD ["bash", "--login", "-i"]