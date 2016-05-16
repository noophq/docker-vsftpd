FROM alpine

MAINTAINER clebeaupin <clebeaupin@noop.fr>

COPY vsftpd-entrypoint.sh /entrypoint.sh
COPY vsftpd-pam.default /etc/pam.d/vsftpd
COPY vsftpd.conf.default /templates/etc/vsftpd/vsftpd.conf
COPY vsftpd-user-admin.default /templates/etc/vsftpd/users/admin

RUN set -xe \
    && apk add -U build-base curl linux-pam-dev tar apache2-utils vsftpd \
    && mkdir /tmp/pam_pwdfile \
    && cd /tmp/pam_pwdfile \
    && curl -sSL https://github.com/tiwe-de/libpam-pwdfile/archive/v1.0.tar.gz | tar xz --strip 1 \
    && make install \
    && rm -rf /tmp/pam_pwdfile \
    && apk del build-base curl linux-pam-dev tar \
    && rm -rf /var/cache/apk/* \
    && rm /etc/vsftpd/vsftpd.conf \
    && mkdir -p /etc/vsftpd/users /var/run/vsftpd \
    && chown ftp:ftp /var/lib/ftp -R \
    && chmod +x /entrypoint.sh 

VOLUME /var/lib/ftp
WORKDIR /var/lib/ftp

EXPOSE 21

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "vsftpd", "/etc/vsftpd/vsftpd.conf" ]
