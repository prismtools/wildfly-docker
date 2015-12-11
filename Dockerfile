FROM java:openjdk-8

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION=9.0.2.Final \
    WILDFLY_SHA1=75738379f726c865d41e544e9b61f7b27d2853c7 \
    JBOSS_HOME=/opt/wildfly \
    ADMIN_USER=admin \
    ADMIN_PASSWORD=dcm4che

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && $JBOSS_HOME/bin/add-user.sh $ADMIN_USER $ADMIN_PASSWORD --silent

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

 # Expose the ports we're interested in
EXPOSE 8080 9990

 # Set the default command to run on boot
 # This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
