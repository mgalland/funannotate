FROM nextgenusfs/funannotate

LABEL maintainer="Jon Palmer <nextgenusfs@gmail.com>"

USER linuxbrew

# # Snakemake installation. Taken from https://hub.docker.com/r/snakemake/snakemake/dockerfile
# ENV PATH /opt/conda/bin:${PATH}
# ENV LANG C.UTF-8
# ENV SHELL /bin/bash
# RUN /bin/bash -c "apt-get install wget bzip2 ca-certificates gnupg2 squashfs-tools git && \
#     wget -O- https://neuro.debian.net/lists/xenial.us-ca.full > /etc/apt/sources.list.d/neurodebian.sources.list && \
#     wget -O- https://neuro.debian.net/_static/neuro.debian.net.asc | apt-key add - && \
#     install_packages singularity-container && \
#     wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
#     bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
#     rm Miniconda3-latest-Linux-x86_64.sh && \
#     conda create -c conda-forge -n snakemake bioconda::snakemake bioconda::snakemake-minimal --only-deps && \
#     conda clean --all -y && \
#     source activate snakemake && \
#     which python && \
#     pip install ."

# RUN echo "source activate snakemake" > ~/.bashrc

# ENV PATH /opt/conda/envs/snakemake/bin:${PATH}

# funannotate installation
WORKDIR /home/linuxbrew

COPY gm_key_64.gz \
    signalp-5.0b.Linux.tar.gz \
    RepBaseRepeatMaskerEdition-20170127.tar.gz \
    /home/linuxbrew/

RUN zcat gm_key_64.gz > /home/linuxbrew/.gm_key && \
    tar -zxvf  signalp-5.0b.Linux.tar.gz && \ 
    sed -i 's,/usr/cbs/bio/src/signalp-5.0b,/home/linuxbrew/signalp-5.0b,g' signalp-5.0b/bin/signalp && \
    sed -i 's,#!/usr/bin/perl,#!/usr/bin/env perl,g' signalp-5.0b/bin/signalp
    
RUN tar -zxvf RepBaseRepeatMaskerEdition-20170127.tar.gz -C /home/linuxbrew/repeatmasker && \
    rm -rf RepBaseRepeatMaskerEdition-20170127.tar.gz && \
    cd /home/linuxbrew/repeatmasker && perl ./configure < /home/linuxbrew/repeatmasker.txt && \
    cd /home/linuxbrew/repeatmodeler && perl ./configure < /home/linuxbrew/repeatmodeler.txt && \
    funannotate setup -d /home/linuxbrew/DB && \
    mkdir /home/linuxbrew/data

WORKDIR /home/linuxbrew/data

ENTRYPOINT /bin/bash
