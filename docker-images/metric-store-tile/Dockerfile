FROM golang:latest

RUN go version

RUN apt-get update; apt-get install --yes \
    bundler \
    jq \
    rsync \
    unzip \
    psmisc \
    python \
    vim

RUN wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz \
  && tar -xzvf chruby-0.3.9.tar.gz \
  && cd chruby-0.3.9/ \
  && sudo make install

RUN wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz \
  && tar -xzvf ruby-install-0.7.0.tar.gz \
  && cd ruby-install-0.7.0/ \
  && sudo make install

RUN curl -Lo /usr/local/bin/om https://github.com/pivotal-cf/om/releases/download/7.9.0/om-linux-amd64-7.8.2 \
    && chmod +x /usr/local/bin/om

# cf-log-cache team in google cloud:
RUN wget -q https://storage.googleapis.com/smith-cli/smith-v2.1.0_linux_amd64.tar.gz \
  && tar -xzf smith-v2.1.0_linux_amd64.tar.gz \
  && chmod +x smith \
  && mv smith /usr/local/bin

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

# RUN go get -d github.com/cloudfoundry/bosh-cli && go build -o $GOPATH/bin/bosh github.com/cloudfoundry/bosh-cli
# RUN curl -L "https://cli.run.pivotal.io/stable?release=debian64&source=github" > cf.deb && dpkg -i ./cf.deb

RUN go install github.com/onsi/ginkgo/ginkgo@latest
RUN git config --global user.email "cf-log-cache@pivotal.io" && git config --global user.name "Metric Store CI"

RUN cd /tmp \
  && wget https://github.com/cloudfoundry/bosh-bootloader/releases/download/v6.6.7/bbl-v6.6.7_linux_x86-64 -O /usr/local/bin/bbl \
  && chmod +x /usr/local/bin/bbl

RUN cd /tmp \
    && wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip -O terraform.zip \
    && unzip terraform.zip -d /usr/local/bin

RUN cd /tmp \
  && wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-200.0.0-linux-x86_64.tar.gz -O google-cloud-sdk.tar.gz \
  && tar xzvf google-cloud-sdk.tar.gz -C /usr/local/share \
  && /usr/local/share/google-cloud-sdk/install.sh \
  && ln -s /usr/local/share/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud

RUN cd /tmp \
  && wget https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/1.7.5/credhub-linux-1.7.5.tgz \
  && tar xzvf credhub*.tgz ./credhub \
  && cp ./credhub /usr/local/bin/
