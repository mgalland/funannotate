FROM reslp/funannotate:1.7.4

LABEL maintainer="Marc Galland <m.galland@uva.nl>"

USER linuxbrew

# funannotate installation
WORKDIR /home/linuxbrew

COPY gm_key_64.gz \
    signalp-5.0b.Linux.tar.gz \
    RepBaseRepeatMaskerEdition-20170127.tar.gz \
    /data/external//

RUN zcat gm_key_64.gz > /data/external/.gm_key && \
    tar -zxvf  signalp-5.0b.Linux.tar.gz && \ 
    sed -i 's,/usr/cbs/bio/src/signalp-5.0b,/data/external/signalp-5.0b,g' signalp-5.0b/bin/signalp && \
    sed -i 's,#!/usr/bin/perl,#!/usr/bin/env perl,g' signalp-5.0b/bin/signalp
    
RUN tar -zxvf RepBaseRepeatMaskerEdition-20170127.tar.gz -C /data/external/repeatmasker && \
    rm -rf RepBaseRepeatMaskerEdition-20170127.tar.gz && \
    cd /data/external/repeatmasker && perl ./configure < /data/external/repeatmasker.txt && \
    cd /data/external/repeatmodeler && perl ./configure < /data/external/repeatmodeler.txt && \
    funannotate setup -d /data/external/DB 

# Install Python 3.6 & Snakemake
RUN apt-get install python-pip python-dev build-essential apt-get install -y \
    && pip install 'snakemake==5.19.3' 

ENTRYPOINT ["snakemake", "-n"]
