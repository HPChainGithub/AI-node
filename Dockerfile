# -----------------------------------------------------------------------------
#                    Choose your base Nvidia CUDA image
# -----------------------------------------------------------------------------
# Note:
#   - Don't forget that the CUDA and cuDNN versions must match  with the
#     Deep Learning Frameworks (Tensorflow, Pytorch, Rapids, Jax, ...)
#   - Jax makes use of /usr/local/cuda/bin ptxas which is not available in
#     the "runtime" version of the Nvidia Cuda image
#

FROM nvidia/cuda:12.3-cudnn8.1-devel-ubuntu20.04
#FROM nvidia/cuda:12.3-cudnn8.1-runtime-ubuntu20.04

# -----------------------------------------------------------------------------
#                  Customize Configuration if needed
# -----------------------------------------------------------------------------
# Note:
#   - Python virtual environment is installed in WORKDIR and must be
#     accessible without sudo
#   - apt packages to install are defined in  the file 'requirements_system.txt'
#   - Map the proper user rights for sharing host's volumes with
#     USER_UID and USER_GID (this avoids permission access denied on the
#     host for the files created in docker containers
#

ARG USER_NAME="docker-hpchain.ai"
ARG USER_UID="1000"
ARG USER_GID="1000"
ARG WORK_DIR="/home/$USER_NAME/projects"
ARG CUDA_PKG_VERSION="$(echo $CUDA_PKG_VERSION)"

ARG DEBIAN_FRONTEND='noninteractive'
ENV SHELL='/bin/bash'
ENV PS1='[$(pwd)]#'
ENV TERM=ansi
ENV export TZ='Europe/Paris'
ENV LANGUAGE=en_US
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# User configuration (specifying the UID and GID values)
RUN groupadd -g $USER_GID $USER_NAME && \
    useradd -u $USER_UID -g $USER_GID -s /bin/bash $USER_NAME && \
    usermod -g sudo $USER_NAME

# Expose Jupyter Lab 
EXPOSE 6006

# -----------------------------------------------------------------------------
#                Import the System configuration and assets files
# -----------------------------------------------------------------------------
ADD assets/.bashrc /home/$USER_NAME/
ADD assets/.bash_profile /home/$USER_NAME/
ADD assets/.profile /home/$USER_NAME/
ADD assets/.screenrc /home/$USER_NAME/
ADD requirements_system.txt /home/$USER_NAME


# -----------------------------------------------------------------------------
#                            Setup the System
# -----------------------------------------------------------------------------
RUN apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get -y install curl &&\
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" > /etc/apt/sources.list.d/coral-edgetpu.list && \
    apt-get update -y -q && \
    cat /home/$USER_NAME/requirements.system | sed -e 's/#.*//g' | sed -e '/^$/d' | xargs apt-get -y install --fix-missing --fix-broken && \
    apt-get -q clean && \
    apt-get -q autoremove

# -----------------------------------------------------------------------------
#                          Post Install Cleaning
# -----------------------------------------------------------------------------
RUN rm -rf /var/log/* && \
    rm -rf /tmp/.[!.]* /tmp/*


WORKDIR $WORK_DIR







