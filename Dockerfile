FROM registry.access.redhat.com/ubi8/httpd-24

MAINTAINER Juan Lozano <jlozano@redhat.com>

LABEL summary="Platform for building and running Angular applications" \
      io.k8s.description="OpenShift S2I builder image for Angular apps using Angular CLI and Apache httpd 2.4." \
      io.k8s.display-name="Angular S2I httpd" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,angular" \
      com.redhat.dev-mode="DEV_MODE:false" \
      com.redhat.deployments-dir="/opt/app-root/src"

ENV NODEJS_VERSION=14 \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    NPM_CONFIG_LOGLEVEL=info \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    NODE_ENV=production \
    DEV_MODE=false

EXPOSE 8080

USER root

# Install NodeJs
RUN yum -y module enable nodejs:$NODEJS_VERSION && \
    MODULE_DEPS="make gcc gcc-c++ libatomic_ops git openssl-devel" && \
    INSTALL_PKGS="$MODULE_DEPS nodejs npm nodejs-nodemon nss_wrapper" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    ln -s /usr/libexec/platform-python /usr/bin/python3 && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*'

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH
COPY ./contrib/ /opt/app-root

# Disable HTTPS
RUN sed -i -f /opt/app-root/etc/ssl.sed /etc/httpd/conf.d/ssl.conf && \
    sed -i -f /opt/app-root/etc/httpdconf.sed /etc/httpd/conf/httpd.conf && \
    chown -R 1001:1001 /opt/app-root

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
