FROM ubuntu:16.04
MAINTAINER tecfu <>

ENV REFRESHED_AT 2018-01-29

# Dont prompt for any installs
# The ARG directive sets variables that only live during the build
ARG DEBIAN_FRONTEND=noninteractive
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
    git \
    zip \
    unzip \
    locales \
    software-properties-common \
    python-software-properties 

# Set up locales
RUN locale-gen en_US.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
RUN /usr/sbin/update-locale


##############################
# Install Development Tools
##############################


# Vim 8 custom build
RUN apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev git dh-autoreconf
WORKDIR $HOME
RUN git clone https://github.com/vim/vim.git
WORKDIR $HOME/vim
RUN ./configure --with-features=huge \
           --enable-multibyte \
           --enable-rubyinterp=yes \
           --enable-pythoninterp=yes \
           --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
           --enable-python3interp=yes \
           --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
           --enable-perlinterp=yes \
           --enable-luainterp=yes \
 #         --enable-gui=gtk2 \
           --enable-cscope \
           --prefix=/usr/local
RUN make VIMRUNTIMEDIR=/usr/local/share/vim/vim80
RUN make install
# Install Vim plugins
#RUN vim +PlugInstall +qall 
#RUN apt-get install -y vim 

# Install tmux
RUN apt-get -y install tmux

# Install Universal CTAGS
WORKDIR $HOME
RUN git clone https://github.com/universal-ctags/ctags
WORKDIR $HOME/ctags
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install


# Terminal, Vim Customization
WORKDIR $HOME
RUN git clone https://github.com/tecfu/dotfiles 

# Create symlinks to bash config
RUN mv $HOME/.bashrc $HOME/.bashrc.saved
RUN ln -s $HOME/dotfiles/terminal/.bashrc $HOME/.bashrc
RUN ln -s $HOME/dotfiles/terminal/.inputrc $HOME/.inputrc

# Vim
# Create symlinks to vim config
RUN ln -s $HOME/dotfiles/.vim $HOME/.vim
RUN ln -s $HOME/dotfiles/.vim/.vimrc $HOME/.vimrc

# Clean up apt cache and temp files to save disk space
# RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get clean && apt-get autoremove -y



##############################
# Language Repos
##############################

# Add Erlang repo
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb

# Add DotNet repo
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-get install apt-transport-https -y

# Add Nodejs repo
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -

# Add PHP repo
RUN add-apt-repository -y ppa:ondrej/php

# Add Mono repo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | tee /etc/apt/sources.list.d/mono-official.list

# Add Java9 repo
RUN add-apt-repository ppa:webupd8team/java

# Add R repo
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
RUN gpg -a --export E084DAB9 | apt-key add -


RUN apt-get update


##############################
# Install Languages
##############################

# Erlang
RUN apt-get install esl-erlang
RUN apt-get install elixir

# Phoenix Framework
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# DotNet
RUN apt-get install dotnet-sdk-2.1.4 -y

# Java 9 
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
  debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | \
  debconf-set-selections
RUN apt-get -y install oracle-java9-installer oracle-java9-set-default

# Julia
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/0.6/julia-0.6.2-linux-x86_64.tar.gz
RUN tar -xvf julia-0.6.2-linux-x86_64.tar.gz
RUN JULIA=$(ls | grep julia | awk '!/gz/')
RUN ln -s /root/$(ls | grep julia | awk '!/gz/')/bin/julia /usr/local/bin/julia

# Mono
RUN apt-get install mono-devel -y
RUN apt-get install nuget -y

# Nodejs
RUN apt-get install -y nodejs 

# R
RUN apt-get install -y r-base r-base-dev

# Run the following scripts when container is started
#COPY ./boot.sh $HOME/boot.sh
#RUN chmod +x $HOME/boot.sh
#ENTRYPOINT $HOME"/boot.sh"
