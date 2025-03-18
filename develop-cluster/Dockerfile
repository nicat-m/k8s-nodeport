FROM ubuntu:mantic
RUN mkdir /scripts
COPY get-nodeports.sh /scripts/
WORKDIR /scripts
RUN chmod u+x get-nodeports.sh
RUN apt update && apt install cron curl gnupg2 nginx -y
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg |  gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt update && apt install kubectl
RUN mkdir /root/.kube
COPY kube-config /root/.kube/config
RUN kubectl config use-context kubernetes-admin@kubernetes
RUN crontab -l | { cat; echo "* * * * * /scripts/get-nodeports.sh > /scripts/nodeport.log"; } | crontab -
RUN touch /scripts/nodeport.log
RUN echo "#!/bin/bash\n\nservice nginx restart && service cron restart && tail -f /scripts/nodeport.log" >> /scripts/start.sh
RUN chmod u+x start.sh
RUN sh /scripts/get-nodeports.sh
EXPOSE 80
ENTRYPOINT ["/scripts/start.sh"]