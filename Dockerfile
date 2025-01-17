FROM adoptopenjdk/openjdk11-openj9:jdk-11.0.5_10_openj9-0.17.0-alpine-slim
ARG BMRG_TAG
ENV BMRG_HOME=/opt
ENV BMRG_SVC=service-box-$BMRG_TAG

WORKDIR $BMRG_HOME
ADD target/$BMRG_SVC.jar service.jar
RUN sh -c 'touch /service.jar'

# Create user, chown, and chmod. 
# OpenShift requires that a numeric user is used in the USER declaration instead of the user name
RUN chmod -R u+x $BMRG_HOME \
    && chgrp -R 0 $BMRG_HOME \
    && chmod -R g=u $BMRG_HOME
    USER 2000

EXPOSE 8080
ENTRYPOINT [ "sh", "-c", "java -Dhttp.proxyHost=$PROXY_HOST -Dhttp.proxyPort=$PROXY_PORT -Dhttps.proxyHost=$PROXY_HOST -Dhttps.proxyPort=$PROXY_PORT -Dhttp.nonProxyHosts=$NO_PROXY -Djava.security.egd=file:/dev/./urandom -jar ./service.jar $0 $@" ]
