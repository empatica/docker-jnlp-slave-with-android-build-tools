FROM empatica/jnlp-slave-with-java-build-tools:3.3-1
MAINTAINER Giannicola Olivadoti <go@empatica.com>

USER root

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install libc6:i386 libstdc++6:i386 libgcc1:i386 libncurses5:i386 libz1:i386 && \
    rm -rf /var/lib/apt/lists/*

ENV ANDROID_SDK_HOME /opt/android-sdk
ENV ANDROID_SDK_VERSION 26 # 25
ENV ANDROID_SDK_TOOLS_VERSION 3859397

ARG ANDROID_SDK_TOOLS_DOWNLOAD_SHA256=444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0

RUN curl -fsSL "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip" -o android-sdk-tools.zip && \
    echo "${ANDROID_SDK_TOOLS_DOWNLOAD_SHA256} android-sdk-tools.zip" | sha256sum --check - && \
    unzip android-sdk-tools.zip && \
    rm android-sdk-tools.zip && \
    mkdir -p "${ANDROID_SDK_HOME}" "${ANDROID_SDK_HOME}/licenses" && \
    mv tools "${ANDROID_SDK_HOME}/tools"

ENV PATH ${PATH}:${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/platform-tools # :${ANDROID_SDK_HOME}/tools/bin:$ANDROID_NDK

# USER jenkins

# ENV ANDROID_SDK_HOME "${HOME}"

RUN ls -larth /opt/android-sdk && \
    cd /opt/android-sdk && \
    tools/bin/sdkmanager --list && \
    tools/bin/sdkmanager --licenses && \
    ls -larth /opt/android-sdk
