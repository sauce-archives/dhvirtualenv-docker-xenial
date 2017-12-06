FROM ubuntu:xenial

# Usage: docker run -it -e LOCAL_USER_ID=`id -u $USER` -e LOCAL_USER_NAME=$USER  -v $SRC:$SRC  sauce-cloud-deb-build-xenial:0.1  "cd $SRC/cloud; dpkg-buildpackage -uc -us"
# apt dependencies (including python and dh-virtualenv)
RUN apt-get update && apt-get install -y --no-install-recommends \
        sudo \
        tcl \
        tk \
        curl \
        git \
        fakeroot \
        ca-certificates \
        openssh-client \
        build-essential \
        software-properties-common \
        python-software-properties \
        libvirt-dev \
        libxslt-dev \
        libxml2-dev \
        libffi-dev  \
        libssl-dev  \
        python-dev \
        pkg-config \
        debhelper \
        python && \
        rm -rf /var/lib/apt/lists/*

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 9.0.1
RUN curl -O https://bootstrap.pypa.io/get-pip.py;\
    python get-pip.py "pip==$PYTHON_PIP_VERSION"

RUN pip install --no-cache-dir \
    virtualenv \
    jinja2

RUN add-apt-repository ppa:sebdoido/spotify-dh-virtualenv-stable-1.0 && \
    apt-get -q update && \
    apt-get -q install -y dh-virtualenv

# entrypoint.sh script will make sure that current user is created within container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

