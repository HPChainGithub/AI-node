# -----------------------------------------------------------------------------
#                    Choose your base Nvidia CUDA image
# -----------------------------------------------------------------------------
# Note:
#   - Don't forget that the CUDA and cuDNN versions must match  with the
#     Deep Learning Frameworks (Tensorflow, Pytorch, Rapids, Jax, ...)
#   - Jax makes use of /usr/local/cuda/bin ptxas which is not available in
#     the "runtime" version of the Nvidia Cuda image
#

FROM nvidia/cuda:12.0.1-cudnn8-runtime-ubuntu20.04

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
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

# User configuration (specifying the UID and GID values)
RUN groupadd -g $USER_GID $USER_NAME && \
    useradd -u $USER_UID -g $USER_GID -s /bin/bash $USER_NAME && \
    usermod -g sudo $USER_NAME

# Expose Jupyter Lab 
EXPOSE 6006

# -----------------------------------------------------------------------------
#                Import the System configuration and assets files
# -----------------------------------------------------------------------------
ADD files/.bashrc /home/$USER_NAME/
ADD files/.bash_profile /home/$USER_NAME/
ADD files/.profile /home/$USER_NAME/
ADD files/.screenrc /home/$USER_NAME/
ADD files/requirements_system.txt /home/$USER_NAME


# -----------------------------------------------------------------------------
#                            Setup the System
# -----------------------------------------------------------------------------
RUN apt-get update -y -q && \
    apt-get upgrade -y -q && \
    apt-get -y install curl && \
    apt-get -y install gcc && \
    apt-get -y install gnupg && \
    apt-get -y install software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update -y -q && \
    apt-get -y install python3-pyglet && \
    apt-get install -y nvidia-container-toolkit
    apt-get update -y -q && \
    cat /home/$USER_NAME/requirements_system.txt | sed -e 's/#.*//g' | sed -e '/^$/d' | xargs apt-get -y install --fix-missing --fix-broken && \
    apt-get -q clean && \
    apt-get -q autoremove

# -----------------------------------------------------------------------------
#                      Import the Python setup files
# -----------------------------------------------------------------------------

ADD files/jupyter_notebook_config.py /home/$USER_NAME/.jupyter/jupyter_notebook_config.py
ADD files/requirements.txt /home/$USER_NAME
ADD files/python_setup.sh /home/$USER_NAME
ADD files/patch_conda.sh /home/$USER_NAME
ADD files/constraints.txt /home/$USER_NAME


# -----------------------------------------------------------------------------
#                              Python Setup
# -----------------------------------------------------------------------------
RUN mkdir -p $WORK_DIR && \
    chown -R $USER_UID:$USER_GID $WORK_DIR && \
    chown -R $USER_UID:$USER_GID /home/$USER_NAME/ && \
    chown -R $USER_UID:$USER_GID /home/$USER_NAME/.* && \
    chmod u+x /home/$USER_NAME/*.sh 

# -----------------------------------------------------------------------------
#                          Post Install Cleaning
# -----------------------------------------------------------------------------
RUN rm -rf /var/log/* && \
    rm -rf /tmp/.[!.]* /tmp/*


WORKDIR $WORK_DIR
CMD ["/bin/bash", "-c", "source ~/.profile; source ~/.bashrc; /bin/bash" ]







