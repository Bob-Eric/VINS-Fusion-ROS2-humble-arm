export WORKERS_BUILD_DEPS=1

cd ..
# opencv + cvbridge
git clone -b humble https://github.com/ros-perception/vision_opencv.git
cd ..

sudo apt-get update
sudo apt-get install wget unzip
sudo apt-get install -y cmake libgoogle-glog-dev libatlas-base-dev libsuitesparse-dev libboost-python-dev libboost-dev libboost-filesystem-dev libboost-program-options-dev ros-humble-image-transport

git clone https://github.com/opencv/opencv.git -b 4.11.0 --depth 1
git clone https://github.com/opencv/opencv_contrib.git -b 4.11.0 --depth 1

cd opencv
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_INSTALL_PREFIX=/usr/local/ \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -DWITH_CUDA=ON \
    -DCUDA_ARCH_PTX="" \
    -DENABLE_FAST_MATH=ON \
    -DCUDA_FAST_MATH=ON \
    -DWITH_CUBLAS=ON \
    -DWITH_LIBV4L=ON \
    -DWITH_GSTREAMER=ON \
    -DWITH_GSTREAMER_0_10=OFF \
    -DWITH_QT=ON \
    -DWITH_OPENGL=ON \
    -DCUDA_NVCC_FLAGS="--expt-relaxed-constexpr" \
    -DWITH_TBB=ON \
    ..
make -j $WORKERS_BUILD_DEPS
sudo make install
sudo ldconfig

cd ../../

# eigen
wget -O eigen-3.4.0.zip https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.zip 
unzip eigen-3.4.0.zip 
cd eigen-3.4.0 && mkdir build && cd build
cmake ../ && sudo make install -j $WORKERS_BUILD_DEPS
cd ../../

# ceres solver
sudo apt-get install -y cmake libgoogle-glog-dev libatlas-base-dev libsuitesparse-dev
wget http://ceres-solver.org/ceres-solver-2.1.0.tar.gz
tar zxf ceres-solver-2.1.0.tar.gz
cd ceres-solver-2.1.0
mkdir build && cd build
cmake -DEXPORT_BUILD_DIR=ON \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        ../
make -j $WORKERS_BUILD_DEPS
make test -j $WORKERS_BUILD_DEPS
sudo make install -j $WORKERS_BUILD_DEPS
cd ../../

unset WORKERS_BUILD_DEPS
