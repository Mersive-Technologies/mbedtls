#!/bin/bash -x

echo "Restoring environment"
source ~/env.sh

echo "Performing build"
mkdir -p build
cd build
echo "PATH ${PATH}"
cmake -GNinja -DANDROID_NDK=${ANDROID_NDK_HOME} -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=${ANDROID_ABI} \
  -DANDROID_NATIVE_API_LEVEL=${ANDROID_PLATFORM} \
  -DENABLE_TESTING=Off \
  ..
cd -
cmake --build ./build -- -j`nproc`
