#!/bin/bash -x

echo "Some useful env info"
printenv
echo ${NEXUS_PWD} | sha256sum

echo "setup env"
export ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${NDK_VERSION}
export TOOLCHAIN=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64
export PATH=${TOOLCHAIN}/bin:${ANDROID_HOME}/cmake/${CMAKE_VERSION}/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:$PATH

echo "Installing the necessary packages"
apt-get -qq update && apt-get -qq install -y openjdk-8-jdk unzip wget curl git python python3
mkdir -p ~/.ssh/
mkdir -p /opt/

echo "Downloading and installing the Android SDK"
export DL_TARGET_SDK=/opt/android-sdk.zip
curl -sSf --user "vhtest:$NEXUS_PWD" -o $DL_TARGET_SDK https://nexus.mersive.xyz/repository/vhserver/sdk-tools-linux-4333796.zip
mkdir -p "$ANDROID_HOME"
unzip -q -d "$ANDROID_HOME" $DL_TARGET_SDK

echo "Configuring the SDK"
mkdir -p /root/.android
touch /root/.android/repositories.cfg
yes | sdkmanager --licenses > /dev/null
sdkmanager "tools" "platform-tools" "build-tools;${BUILD_TOOLS_VERSION}" "platforms;android-${TARGET_API}" > /dev/null
sdkmanager "cmake;${CMAKE_VERSION}" > /dev/null
sdkmanager "ndk;${NDK_VERSION}" > /dev/null

echo "Saving environment"
declare -px > ~/env.sh
