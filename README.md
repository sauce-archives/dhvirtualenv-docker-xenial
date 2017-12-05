# Docker container containing ubuntu 16.04 with dh-virtualenv installed
[dh-virtualenv](https://github.com/spotify/dh-virtualenv) is used to generate debian package containing python virtualenv (and not just one python package).
## Usage
Build docker container using Dockerfile

```
git clone git@github.com:saucelabs/dhvirtualenv-docker-xenial.git
cd dhvirtualenv-docker-xenial
# build image using this repo Dockerfile
docker build -t dhvirtualenv .
# use dhvirtualenv image to build debian package
# the assumption is that your repo contains `debian` directory
cd /path/to/your/repo/containing/python/code/to/build/repo_name
parent_dir=$(cd .. && pwd)
# set LOCAL_USER to make sure that generated deb package is owned by the current user
export SRC_DIR=$(cd .. && pwd) && docker run -it -e LOCAL_USER_ID=`id -u $USER` -e LOCAL_USER_NAME=$USER  -v $SRC_DIR:$SRC_DIR  dhvirtualenv "cd $SRC_DIR/repo_name; dpkg-buildpackage -us -uc"
```
