FROM r-base:3.4.4

RUN apt-get update 
RUN apt-get install -y libcurl4-openssl-dev libxml2-dev libssl-dev

#Packrat configuration
COPY ./packrat/packrat.lock packrat/

RUN install2.r packrat

RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

RUN R CMD javareconf


RUN echo '.libPaths("./packrat/lib/x86_64-pc-linux-gnu/3.4.4")' >> /etc/R/Rprofile.site 
RUN Rscript -e 'packrat::restore()'	


#Installing awscli
RUN apt-get update \	
  && apt-get install -y apt-utils \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip
RUN pip install awscli

