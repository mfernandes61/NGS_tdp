#
# Create a container environment with tools to prepare NGS datasets for training courses
# Uses sratoolkit, fastqc and seqtk.
# SRA real data-sets afe often too large for training courses so the intent for this
# environment is to pul SRA fastq files using sratoolkit , subsample with seqtk and eyeball the sub-set 
# for quality issues with FastQC. Enable a volume on your local storage and map it to /datahome
# NB with Kitematic you will have to restart the container
#
# Mark Fernandes December 2016
# www.ifr.ac.uk

FROM foodresearch/bppc
MAINTAINER Mark Fernandes mark.fernandes@ifr.ac.uk

USER root
RUN apt-get -qq update && apt-get upgrade -y && apt-get install -y  unzip default-jre\
	 fastqc wget seqtk
RUN if [ ! -d "/scripts" ]; then mkdir /scripts ; fi
ADD scripts\* /scripts
RUN chmod +x /scripts/*.sh  && mkdir /datahome
#download SRA-toolkit 2.8+ to support requires https connection
# sratoolkit.current-ubuntu64.tar.gz
RUN wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz -P /tools \
	&& tar zxvf /tools/sratoolkit.current-ubuntu64.tar.gz -C /tools && rm /tools/*.tar.gz \
	&& ln -s /tools/sratoolkit.current-ubuntu64/bin/* /usr/local/bin/
#
EXPOSE 22 4200
VOLUME /datahome

ENTRYPOINT ["/scripts/launchsiab.sh"]
CMD ["/bin/bash"]
