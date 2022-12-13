FROM docker.io/gitpod/workspace-full

ARG CMDLINE_ARCHIVE="commandlinetools-linux-7302050_latest.zip"

ENV	ANDROID_HOME="/usr/local/android-sdk"
ENV	PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/cmdline-tools/latest:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

USER root

RUN	apt-get update -y && \
    apt-get install -y \
        openjdk-8-jdk-headless

RUN mkdir -p $ANDROID_HOME && \
    chown -R gitpod:gitpod $ANDROID_HOME && \
    chmod -R 2775 $ANDROID_HOME

USER gitpod

# download cmdline-tools
RUN	curl -O "https://dl.google.com/android/repository/$CMDLINE_ARCHIVE" && \
	unzip $CMDLINE_ARCHIVE -d $ANDROID_HOME/cmdline-tools && \
	mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm -rf $CMDLINE_ARCHIVE

# setup android sdk ndk
RUN sdkmanager --update && \
    yes | sdkmanager --install "ndk;25.1.8937393" && \
    yes | sdkmanager --licenses

# install gomobile
RUN go install golang.org/x/mobile/cmd/gomobile@latest && \
    gomobile init