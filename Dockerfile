FROM ubuntu:18.04
LABEL maintainer="dalmatialab"

# Install tzdata and set right timezone
ENV DEBIAN_FRONTEND="noninteractive"
RUN apt update && apt-get -y install tzdata
ENV TZ=Europe/Zagreb

RUN apt-get update && apt-get install -y samba
RUN mkdir /sambashare && chgrp sambashare /sambashare && mkdir /sambashare/public && chgrp sambashare /sambashare/public && chmod 2777 /sambashare/public

WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

COPY conf/smb.conf /etc/samba/smb.conf

ENV USERNAME=samba PASSWORD=samba WORKGROUP=WORKGROUP PUBLIC=no PRINTERS=no PRINT=no

EXPOSE 139 445

ENTRYPOINT ["./entrypoint.sh"]
CMD ["/usr/sbin/smbd", "-FS"]