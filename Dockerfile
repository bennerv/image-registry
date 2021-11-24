FROM registry.access.redhat.com/ubi8/ubi
RUN yum install -y rsync && yum clean all && rm -rf /var/cache/yum
COPY ./dockerregistry /usr/bin/
COPY images/dockerregistry/config.yml /
ADD images/dockerregistry/writable-extracted.tar.gz /etc/pki/ca-trust/extracted
USER 1001
EXPOSE 5000
VOLUME /registry
ENV REGISTRY_CONFIGURATION_PATH=/config.yml
ENTRYPOINT ["sh", "-c", "update-ca-trust extract && exec \"$@\"", "arg0"]
CMD ["/usr/bin/dockerregistry"]
LABEL io.k8s.display-name="OpenShift Image Registry" \
      io.k8s.description="This is a component of OpenShift and exposes a container image registry that is integrated with the cluster for authentication and management." \
      io.openshift.tags="openshift,docker,registry"
