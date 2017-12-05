#!/bin/bash

# Add user using LOCAL_USER_ID and LOCAL_USER_NAME that is passed in at runtime
# export SRC_DIR=$(cd .. && pwd) && docker run -it -e LOCAL_USER_ID=`id -u $USER` -e LOCAL_USER_NAME=$USER  -v $SRC_DIR:$SRC_DIR  sauce-cloud-deb-build-trusty:0.1 "cd $(pwd); dpkg-buildpackage -us -uc"

USER_ID=${LOCAL_USER_ID}
USER_NAME=${LOCAL_USER_NAME}
if [[ -z $LOCAL_USER_ID ]] || [[ -z $LOCAL_USER_NAME ]]; then
    echo "LOCAL_USER_ID or LOCAL_USER_NAME is not set!!! Running as root user"
    exec /bin/bash -c "$@"
else
    useradd --shell /bin/bash -u $USER_ID -o -c"deb package owner" $USER_NAME
    export HOME=/home/$USER_NAME
    exec sudo -H -u $USER_NAME /bin/bash -c "$@"
fi