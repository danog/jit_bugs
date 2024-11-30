FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

ENV CC=clang-19
ENV CXX=clang++-19

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/llvm-19/lib/clang/19/lib/linux/"

RUN true \
	&& apt update \
	&& apt install -y --no-install-recommends \
		tzdata software-properties-common locales curl apt-utils gpg-agent cron logrotate \
		gnupg2 ca-certificates lsb-release \
		make pkg-config binutils wget \
	&& wget https://apt.llvm.org/llvm.sh \
	&& chmod +x llvm.sh \
	&& ./llvm.sh 19 all \
    && apt update \
	\
	\
	&& apt install -y --no-install-recommends \
		nginx \
		openssh-client \
		git curl xz-utils unzip \
		libjpeg62 libjpeg62-dev zlib1g-dev \
		libssl-dev libcurl4-openssl-dev \
        pkg-config autoconf bison re2c \
        libxml2-dev libsqlite3-dev \
		systemtap-sdt-dev libssl-dev \
		libpcre2-dev libargon2-dev libedit-dev libsodium-dev llvm-19 libonig-dev \
		gdb libcapstone-dev

RUN git clone https://github.com/php/php-src -b master --depth 1 && cd php-src \
    && ./buildconf \
	&& ./configure --prefix=/usr \
		--includedir=/usr/include --mandir=/usr/share/man --infodir=/usr/share/info --sysconfdir=/etc \
		--localstatedir=/var --libdir=/usr/lib/x86_64-linux-gnu \
		--libexecdir=/usr/lib/x86_64-linux-gnu \
		--prefix=/usr --enable-cli --disable-cgi --disable-phpdbg \
		--with-config-file-path=/etc/php/ --with-config-file-scan-dir=/etc/php/conf.d \
		--libdir=/usr/lib/php --libexecdir=/usr/lib/php --datadir=/usr/share/php/8.2 \
		--sysconfdir=/etc --localstatedir=/var --mandir=/usr/share/man \
		--enable-debug --enable-address-sanitizer --disable-rpath --disable-static \
		--enable-filter --with-openssl --enable-mbstring \
		--with-password-argon2=/usr --with-external-pcre --with-mhash=/usr --with-libxml \
		--enable-session --with-sodium --with-zlib=/usr --with-zlib-dir=/usr \
		--enable-pcntl --with-libedit=shared,/usr \
		--with-capstone --with-pear \
    \
    && export CFLAGS='-g -fsanitize=address -shared-libasan -fno-sanitize-recover -DZEND_TRACK_ARENA_ALLOC' \
    && export CPPFLAGS='-g -fsanitize=address -shared-libasan -fno-sanitize-recover -DZEND_TRACK_ARENA_ALLOC' \
    && export CXXFLAGS='-g -fsanitize=address -shared-libasan -fno-sanitize-recover -DZEND_TRACK_ARENA_ALLOC' \
    && export LDFLAGS='-g -fsanitize=address -shared-libasan -Wl,-rpath=/usr/lib/llvm-19/lib/clang/19/lib/linux/' \
    \
	&& make -j100 \
	&& make install

ADD php.ini /etc/php/php.ini

RUN php -r "readfile('https://getcomposer.org/installer');" | php \
	&& mv composer.phar /usr/bin/composer

RUN git config --global --add safe.directory /app

ENV USE_ZEND_ALLOC=0
ENV PSALM_ALLOW_XDEBUG=1
ENV ASAN_OPTIONS="detect_leaks=0:exitcode=139:abort_on_error=true"

WORKDIR /app
