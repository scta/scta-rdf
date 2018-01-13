FROM alpine:3.5

# Basic Utils
RUN apk update && apk upgrade

RUN apk add curl nano wget bash git

# Ruby
RUN apk add ruby ruby-bundler

# Java
RUN apk add openjdk8-jre

# Clean APK cache
RUN rm -rf /var/cache/apk/*


# install saxon
RUN mkdir -p /usr/share/java/saxon
RUN curl -L -o /usr/share/java/saxon/saxon.zip http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.6/SaxonHE9-6-0-7J.zip && \
    unzip /usr/share/java/saxon/saxon.zip -d /usr/share/java/saxon && \
    rm -rf /usr/share/java/saxon/noticies /usr/share/java/saxon/doc \
      /usr/share/java/saxon/saxon9-test.jar /usr/share/java/saxon/saxon9-unpack.jar /usr/share/java/saxon/saxon.zip

# install fuseki
RUN mkdir -p /home/fuseki/
RUN curl -L -o /home/fuseki/apache-jena-fuseki-2.3.1.zip http://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-2.3.1.zip \
    unzip /home/fuseki/apache-jena-fuseki-2.3.1.zip -d /home/fuseki/apache-jena-fuseki-2.3.1 \
    rm /home/fuseki/apache-jena-fuseki-2.3.1.zip

# mkdir fuseki build directory
RUN mkdir -p /home/scta-builds

# mkdir scta-text directory
RUN mkdir -p /home/scta-texts

#install thor
RUN gem install thor --no-ri --no-rdoc

RUN cd /home && git clone -b develop --recursive https://github.com/scta/scta-rdf.git
