FROM empatica/jnlp-slave-with-java-build-tools:3.3-1
MAINTAINER Giannicola Olivadoti <go@empatica.com>

USER root

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install openssh-client libc6:i386 libstdc++6:i386 libgcc1:i386 libncurses5:i386 libz1:i386 && \
    rm -rf /var/lib/apt/lists/*

ENV ANDROID_SDK_HOME /opt/android-sdk
ENV ANDROID_SDK_TOOLS_VERSION 3859397
ENV ANDROID_SDK_VERSION 25
ENV ANDROID_SDK_BUILD_TOOLS_VERSION 25.0.3

ARG ANDROID_SDK_TOOLS_DOWNLOAD_SHA256=444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0

RUN curl -fsSL "https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip" -o android-sdk-tools.zip && \
    echo "${ANDROID_SDK_TOOLS_DOWNLOAD_SHA256} android-sdk-tools.zip" | sha256sum --check - && \
    unzip -q android-sdk-tools.zip && \
    rm android-sdk-tools.zip && \
    mkdir -p "${ANDROID_SDK_HOME}/licenses" && \
    mv tools "${ANDROID_SDK_HOME}/tools" && \
    ls -larth "${ANDROID_SDK_HOME}/tools" && \
    echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > "${ANDROID_SDK_HOME}/licenses/android-sdk-license" && \
    echo 84831b9409646a918e30573bab4c9c91346d8abd > "${ANDROID_SDK_HOME}/licenses/android-sdk-preview-license"&& \
    groupadd --system --gid 1001 android && \
    useradd --system --gid android --uid 1001 --shell /bin/bash -m android && \
    usermod -a -G android jenkins && \
    chown --recursive android:android "${ANDROID_SDK_HOME}" && \
    ls -larth "${ANDROID_SDK_HOME}"

ENV PATH ${PATH}:${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/platform-tools # :${ANDROID_SDK_HOME}/tools/bin:$ANDROID_NDK

# ENV ANDROID_SDK_HOME "${HOME}"

RUN ls -larth /opt/android-sdk && \
    cd /opt/android-sdk && \
    tools/bin/sdkmanager --list && \
    tools/bin/sdkmanager --licenses && \
    echo "Install tools" && \
    tools/bin/sdkmanager "tools" && \
    echo "Install platform-tools" && \
    tools/bin/sdkmanager "platform-tools" && \
    echo "Install android-${ANDROID_SDK_VERSION}" && \
    tools/bin/sdkmanager "platforms;android-${ANDROID_SDK_VERSION}" && \
    echo "Install build-tools-${ANDROID_SDK_BUILD_TOOLS_VERSION}" && \
    tools/bin/sdkmanager "build-tools;${ANDROID_SDK_BUILD_TOOLS_VERSION}" && \
    echo "Install extras-android-m2repository" && \
    tools/bin/sdkmanager "extras;android;m2repository" && \
    echo "Install extras-google-m2repository" && \
    tools/bin/sdkmanager "extras;google;m2repository" && \
    echo "Install extra-google-google_play_services" && \
    tools/bin/sdkmanager "extras;google;google_play_services" && \
    chown --recursive android:android "${ANDROID_SDK_HOME}"

USER jenkins

RUN cd /opt/android-sdk && \
    ls -larth "${ANDROID_SDK_HOME}" && \
    ls -larth "${ANDROID_SDK_HOME}/tools" && \
    ls -larth "${ANDROID_SDK_HOME}/tools/bin" && \
    tools/bin/sdkmanager --list
