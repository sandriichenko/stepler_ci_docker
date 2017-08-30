# Quickstart:
# docker build -t stepler-tests .
# docker run --net=host --rm \
#    -e OS_AUTH_URL=http://10.109.1.8:5000/v3 \
#    -e OS_FAULTS_CLOUD_DRIVER_ADDRESS=10.109.2.2 \
#    -v $(pwd)/reports:/opt/app/test_reports \
#    -v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock \
#    -v /cloud/key/path:/opt/app/cloud.key \
#    stepler stepler/nova
#
# To run on cloud with ssl change `docker run` to `docker --dns=<cloud dns ip> run`

FROM ubuntu:16.04

RUN apt-get update -qq && \
    apt-get install -q -y \
    firefox=45.0.2+build1-0ubuntu1 \
    python-pip \
    libvirt-dev \
    xvfb \
    xdotool \
    git \
    libav-tools && \
apt-get clean  && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /var/lib
USER root

RUN git clone https://review.gerrithub.io/Mirantis/stepler

WORKDIR /var/lib/stepler
RUN pip install -e .[libvirt]

COPY run_tests.sh /usr/bin/run-tests
ENV SOURCE_FILE keystonercv3
ENV OPENRC_ACTIVATE_CMD "source /root/keystonercv3"
ENV VIRTUAL_DISPLAY 1
ENV OS_DASHBOARD_URL "http://192.168.10.90:8078"

#ENV ANSIBLE_SSH_ARGS='-C -o ControlMaster=no'

ENTRYPOINT ["run-tests"]
