##################################################################################
#
#  TensorFlow:
#    we want proper GPU tensorflow support + the ability to use Jupyter
#    in case we're running locally (likely will not work on Hyak)
#    we will later on update the library version on TF, but this gets us
#    all of the GPU-comm setup bullshit
#
##################################################################################
FROM tensorflow/tensorflow:latest-gpu-jupyter
# Force a rebuild by adding this line...

##################################################################################
#
#  wget and friends:
#    need to install wget so we can actually build this stuff
#
##################################################################################
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && \
    apt-get clean

##################################################################################
#
#   MPI:
#    We provide two different ways to install MPI, intended for Mox/Hyak with Singularity
#    or NeRSC/Shifter respectively
#    We need different versions, unfortunately, because the implementation and version _inside_ the
#    container needs to match the loaded one on the host
#    It's dumb, we know, but comment out the one you don't need
#
##################################################################################

## Open MPI Support
# pulled from /sw/singularity-images/testing/ngsolve-2.def
ARG MPI_VERSION=3.1.4
ARG MPI_MAJOR_VERSION=3.1
ARG MPI_URL="https://download.open-mpi.org/release/open-mpi/v${MPI_MAJOR_VERSION}/openmpi-${MPI_VERSION}.tar.bz2"
ARG MPI_DIR=/opt/ompi
RUN mkdir -p /tmp/ompi && \
    mkdir -p /opt && \
    # Download
    cd /tmp/ompi && wget -O openmpi-$MPI_VERSION.tar.bz2 $MPI_URL && tar -xjf openmpi-$MPI_VERSION.tar.bz2 && \
    # Compile and install
    cd /tmp/ompi/openmpi-$MPI_VERSION && ./configure --prefix=$MPI_DIR --disable-oshmem --enable-branch-probabilities && make -j12 install && \
    make clean

## MPICH Support
#ARG MPI_VERSION=3.2
#ARG MPI_MAJOR_VERSION=3.2
#ARG MPI_URL="https://www.mpich.org/static/downloads/${MPI_VERSION}/mpich-${MPI_VERSION}.tar.gz"
#ARG MPI_DIR=/opt/mpich
#RUN mkdir -p /tmp/mpi && \
#    mkdir -p /opt && \
#    # Download
#    cd /tmp/mpi && wget -O mpich-$MPI_VERSION.tar.gz $MPI_URL && tar -xjf mpich-$MPI_VERSION.tar.gz && \
#    # Compile and install
#    cd /tmp/mpi/mpich-$MPI_VERSION && ./configure --prefix=$MPI_DIR --disable-oshmem --enable-branch-probabilities && make -j12 install && \
#    make clean

ENV PATH=$MPI_DIR/bin:$PATH
ENV LD_LIBRARY_PATH=$MPI_DIR/lib:$LD_LIBRARY_PATH