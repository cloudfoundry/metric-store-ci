FROM harbor-repo.vmware.com/dockerhub-proxy-cache/library/golang:latest as base

RUN go version

RUN apt-get update; apt-get install --yes \
  apt-transport-https \
  bundler \
  ca-certificates \
  curl \
  gnupg-agent \
  jq \
  psmisc \
  rsync \
  software-properties-common \
  unzip \
  vim


# Create a directory for the new repository's keyring, if it doesn't exist
RUN mkdir -m 0755 -p /etc/apt/keyrings/

RUN curl -fsSL https://download.docker.com/linux/debian/gpg |  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN add-apt-repository \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    |  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update; apt-get install --yes \
  docker-ce \
  docker-ce-cli \
  containerd.io

RUN wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz \
  && tar -xzvf chruby-0.3.9.tar.gz \
  && cd chruby-0.3.9/ \
  && sudo make install

RUN wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz \
  && tar -xzvf ruby-install-0.7.0.tar.gz \
  && cd ruby-install-0.7.0/ \
  && sudo make install

RUN rm ruby-install-0.7.0.tar.gz \
  && rm -rf ruby-install-0.7.0 \
  && rm chruby-0.3.9.tar.gz \
  && rm -rf chruby-0.3.9

RUN ruby-install --no-reinstall ruby-2.6.2

# get v3 protoc from github, it was in beta at the time of writing
RUN cd /tmp \
  && wget https://github.com/google/protobuf/releases/download/v3.0.0-beta-2/protoc-3.0.0-beta-2-linux-x86_64.zip \
  && unzip *.zip \
  && cp ./protoc /usr/local/bin/

ENV GO111MODULE=auto

RUN go get -d github.com/cloudfoundry/bosh-cli && go build -o $GOPATH/bin/bosh github.com/cloudfoundry/bosh-cli
RUN curl -L "https://cli.run.pivotal.io/stable?release=debian64&source=github" > cf.deb && dpkg -i ./cf.deb

RUN go get github.com/onsi/ginkgo/ginkgo
RUN git config --global user.email "cf-log-cache+github@pivotal.io" && git config --global user.name "Metric Store CI"

RUN cd /tmp \
  && wget https://github.com/cloudfoundry/bosh-bootloader/releases/download/v6.6.7/bbl-v6.6.7_linux_x86-64 -O /usr/local/bin/bbl \
  && chmod +x /usr/local/bin/bbl

RUN cd /tmp \
    && wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip -O terraform.zip \
    && unzip terraform.zip -d /usr/local/bin

RUN cd /tmp \
  && wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-370.0.0-linux-x86_64.tar.gz -O google-cloud-sdk.tar.gz \
  && tar xzvf google-cloud-sdk.tar.gz -C /usr/local/share \
  && /usr/local/share/google-cloud-sdk/install.sh \
  && ln -s /usr/local/share/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud

RUN cd /tmp \
  && wget https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.6.2/credhub-linux-2.6.2.tgz \
  && tar xzvf credhub*.tgz ./credhub \
  && cp ./credhub /usr/local/bin/
