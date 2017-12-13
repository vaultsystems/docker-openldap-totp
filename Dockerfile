From alpine
MAINTAINER Christoph Dwertmann <christoph.dwertmann@vaultsystems.com.au>
RUN apk --update add openssl libtool cyrus-sasl
ADD https://codeload.github.com/openldap/openldap/zip/master /tmp
RUN apk --update add --virtual build-dependencies build-base groff openssl-dev cyrus-sasl-dev \
    && cd /tmp && unzip master && cd openldap-master \
    && ./configure --prefix=/usr --sysconfdir /etc --localstatedir /var --enable-modules \
    && make depend && make -j10 && make install \
    && cd contrib/slapd-modules/passwd/totp \
    && sed -i 's/prefix=\/usr\/local/prefix=\/usr/' Makefile \
    && sed -i 's/#define TIME_STEP	30/#define TIME_STEP	60/' slapd-totp.c \
    && make && make install \
    && mkdir /var/openldap-data \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/openldap-master
CMD ["/usr/libexec/slapd","-d1"]
