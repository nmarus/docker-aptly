FROM nginx
MAINTAINER Nick Marus <nmarus@gmail.com>

EXPOSE 80
VOLUME /aptly

#setup apt
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

#setup aptly repo
RUN echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list
RUN apt-key adv --keyserver keys.gnupg.net --recv-keys E083A3782A194991

#install packages
RUN apt-get -y update && apt-get -y install apt-utils
RUN apt-get -y install aptly git curl bzip2 gnupg gpgv && \
    apt-get clean

#setup user aptly
RUN useradd -M -d /aptly -s /bin/bash aptly --uid 1000

#setup nginx
COPY nginx.conf /etc/nginx/nginx.conf

#setup startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
