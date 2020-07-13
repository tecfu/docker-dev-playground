FROM ubuntu:18.04
MAINTAINER tecfu <>

# ENV REFRESHED_AT 2018-05-04

# Dont prompt for any installs
# The ARG directive sets variables that only live during the build
# ARG DEBIAN_FRONTEND=noninteractive
ARG HOME="/root"

LABEL maintainer="tecfu <>" \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.name="REPL Playground" \
      org.label-schema.url="https://twitter.com/tecfu0" \
      org.label-schema.vcs-url="https://github.com/tecfu/docker-dev-playground"

# Initial apt update
RUN apt-get update && apt-get install -y apt-utils

# Install common / shared packages
RUN apt-get install -y \
    curl \
    wget \
    git \
    zip \
    unzip \
    locales \
    software-properties-common


# Set up locales
RUN locale-gen en_US.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
RUN /usr/sbin/update-locale
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Terminal Customization
WORKDIR $HOME
RUN git clone https://github.com/tecfu/.terminal
RUN /bin/bash .terminal/INSTALL.sh

# zsh
# Uses "robbyrussell" theme (original Oh My Zsh theme), with no plugins
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
    -t robbyrussell


##############################
# Install Development Tools
##############################


# Install tmux
RUN apt-get -y install tmux

# Install vim
# Vim 8 custom build
#RUN apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
#    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
#    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
#    python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git dh-autoreconf
#
#WORKDIR $HOME
#RUN git clone https://github.com/vim/vim.git
#WORKDIR $HOME/vim
#RUN ./configure --with-features=huge \
#           --enable-multibyte \
#           --enable-rubyinterp=yes \
#           --enable-pythoninterp=yes \
#           --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
#           --enable-python3interp=yes \
#           --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
#           --enable-perlinterp=yes \
#           --enable-luainterp=yes \
# #         --enable-gui=gtk2 \
#           --enable-cscope \
#           --prefix=/usr/local
#RUN make VIMRUNTIMEDIR=/usr/local/share/vim/vim82
#RUN make install

RUN add-apt-repository -y ppa:jonathonf/vim
RUN apt update -y
RUN apt install make gcc vim -y

# Vim Customization
WORKDIR $HOME
RUN git clone https://github.com/tecfu/.vim.git
RUN /bin/bash .vim/INSTALL.sh
# Install Vim plugins
RUN vim +PlugInstall +qall 


# Install Universal CTAGS
WORKDIR $HOME
RUN apt install -y \
    gcc make \
    pkg-config autoconf automake \
    python3-docutils \
    libseccomp-dev \
    libjansson-dev \
    libyaml-dev \
    libxml2-dev
RUN git clone https://github.com/universal-ctags/ctags
WORKDIR $HOME/ctags
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install
WORKDIR $HOME

# Clean up apt cache and temp files to save disk space
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get clean && apt-get autoremove -y


###############################
## Language Repos
###############################

# Add Erlang repo
RUN wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | apt-key add -
RUN echo "deb https://packages.erlang-solutions.com/ubuntu bionic contrib" | tee /etc/apt/sources.list.d/rabbitmq.list

# Add DotNet repo
RUN apt-get install apt-transport-https -y
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get -y update
RUN apt-get install -y dotnet-sdk-2.2

# Add nodejs repo
# RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Add PHP repo
RUN add-apt-repository -y ppa:ondrej/php

# Add Mono repo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/ubuntu bionic main" | tee /etc/apt/sources.list.d/mono-official.list

# Add Java11 repo

# Add R repo
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'

RUN apt-get update


##############################
# Install Languages
##############################

# Erlang
RUN apt-get install -y esl-erlang elixir

# Phoenix Framework
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# DotNet
RUN apt-get install dotnet-sdk-2.2 -y

# Java 11


# Julia
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.2-linux-x86_64.tar.gz
RUN tar -xvf julia-0.6.2-linux-x86_64.tar.gz
RUN JULIA=$(ls | grep julia | awk '!/gz/')
RUN ln -s /root/$(ls | grep julia | awk '!/gz/')/bin/julia /usr/local/bin/julia

# Mono
RUN apt-get install mono-devel -y
RUN apt-get install nuget -y

# Nodejs
# Install nvm with node and npm
ADD ./install-nvm.sh $HOME/
RUN /bin/bash /root/install-nvm.sh
# RUN apt-get install -y yarn

# Python 
RUN apt-get install -y python2.7 python-pip
RUN pip install --upgrade pip

# R
RUN apt-get install -y r-base r-base-dev

# Tensor Flow
RUN pip install tensorflow

# Commands to run after container has started
#ENTRYPOINT "nvm install lts/*" && /bin/bash
