From alpine:3.5
MAINTAINER Arvind Rawat <arvindr226@gmail.com>

ENV ANDROID_HOME /opt/android-sdk-linux
RUN apk add --update --no-cache bash libstdc++ libc6-compat libgc++ libgcc ncurses5-widec-libs ncurses-libs ncurses5-libs zlib wget zip unzip && rm -f /var/cache/apk/*


##Java JDK 8 ##

ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u121
ENV JAVA_ALPINE_VERSION 8.121.13-r0

RUN set -x \
	&& apk add --no-cache \
		openjdk8="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]

## End JAVA JDK 8##


RUN mkdir /opt
RUN cd /opt \
    && wget -q https://dl.google.com/android/repository/tools_r25.2.5-linux.zip -O android-sdk-tools.zip \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME} \
    && rm -f android-sdk-tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools


#  android list sdk --no-ui --all --extended
RUN echo y | android update sdk --no-ui --all --filter \
  platform-tools,extra-android-support

# google apis
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter \
  addon-google_apis-google-23,addon-google_apis-google-22,addon-google_apis-google-21

# SDKs
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter \
  android-N,android-23,android-22,android-21,android-20,android-19,android-17,android-15,android-10
# build tools
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter \
  build-tools-24.0.0-preview,build-tools-23.0.2,build-tools-23.0.1,build-tools-22.0.1,build-tools-21.1.2,build-tools-20.0.0,build-tools-19.1.0,build-tools-17.0.0

# Android System Images, for emulators
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter \
  sys-img-armeabi-v7a-android-23,sys-img-armeabi-v7a-android-22,sys-img-armeabi-v7a-android-21,sys-img-armeabi-v7a-android-19,sys-img-armeabi-v7a-android-17,sys-img-armeabi-v7a-android-16,sys-img-armeabi-v7a-android-15

# Extras
RUN echo y | android update sdk --no-ui --all --filter \
  extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services


