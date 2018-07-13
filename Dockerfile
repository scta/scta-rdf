FROM alpine:3.5
#ENV variables
ENV DOCKER=true

ENV BUILD_PACKAGES curl-dev ruby-dev build-base curl nano wget bash git tmux
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler
ENV JAVA_PACKAGES openjdk8-jre

# Basic Utils
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    apk add $JAVA_PACKAGES

# Clean APK cache
RUN rm -rf /var/cache/apk/*


# install saxon
RUN mkdir -p /usr/share/java/saxon
RUN curl -L -o /usr/share/java/saxon/saxon.zip http://downloads.sourceforge.net/project/saxon/Saxon-HE/9.6/SaxonHE9-6-0-7J.zip && \
    unzip /usr/share/java/saxon/saxon.zip -d /usr/share/java/saxon && \
    rm -rf /usr/share/java/saxon/noticies /usr/share/java/saxon/doc \
      /usr/share/java/saxon/saxon9-test.jar /usr/share/java/saxon/saxon9-unpack.jar /usr/share/java/saxon/saxon.zip

RUN printf '#!/bin/bash\nexec java  -jar /usr/share/java/saxon/saxon9he.jar "$@"' > /bin/saxon
RUN chmod +x /bin/saxon

# install fuseki
RUN mkdir -p /home/fuseki/
RUN curl -L -o /home/fuseki/apache-jena-fuseki-2.3.1.zip http://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-2.3.1.zip && \
    unzip /home/fuseki/apache-jena-fuseki-2.3.1.zip -d /home/fuseki/ && \
    rm /home/fuseki/apache-jena-fuseki-2.3.1.zip

ADD . /home/scta-rdf


# mkdir scta-text directory
RUN mkdir -p /home/scta-rdf/data/scta-texts
RUN curl -L -o /home/scta-rdf/data/scta-texts/QmcmpvGBKoUgEQbygohLcLRgHiUoLFwsQD2YzSY92x3uwu http://gateway.ipfs.io/ipfs/QmcmpvGBKoUgEQbygohLcLRgHiUoLFwsQD2YzSY92x3uwu && \
    tar -xvzf /home/scta-rdf/data/scta-texts/QmcmpvGBKoUgEQbygohLcLRgHiUoLFwsQD2YzSY92x3uwu -C /home/scta-rdf/data/scta-texts/


WORKDIR /home/scta-rdf
RUN bundle install

#install thor
#RUN gem install thor --no-ri --no-rdoc
