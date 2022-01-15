FROM ghcr.io/linuxserver/baseimage-guacgui

LABEL maintainer="xirg"

ENV APPNAME="MP3tag" UMASK_SET="022"

RUN \
 echo "**** install runtime packages ****" && \
    dpkg --add-architecture i386 && \
    apt-get update && apt-get install -qy \
    dbus \
	jq \
    apt-transport-https \
    gnupg \
    curl \
    wget \
    cabextract \
    unzip \
    winbind \
    xvfb \
    apt-utils \
    gnupg2 \ 
    python-xdg \
    software-properties-common && \
    wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/ && \
    wget -O- -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key | apt-key add - 
RUN curl -LO https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/i386/libfaudio0_19.07-0~bionic_i386.deb \
    && apt install -qy ./libfaudio0_19.07-0~bionic_i386.deb \
    && rm libfaudio* && \
    apt-get update && apt-get install -qy \
    wine-staging-i386 \
    winehq-staging
# https://wiki.winehq.org/Mono
#RUN curl https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks && \
#    chmod +x /usr/local/bin/winetricks

RUN echo `wine --version` && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /


