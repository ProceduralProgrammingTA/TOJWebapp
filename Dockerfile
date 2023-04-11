FROM ruby:2.4

# ruby on rails
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            nodejs \
            build-essential \
            default-mysql-client \
            gcc make wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /workdir
WORKDIR /workdir

ADD Gemfile /workdir/Gemfile
ADD Gemfile.lock /workdir/Gemfile.lock

RUN bundle install


# docker in docker (@jpetazzo/dind)
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables

RUN curl -sSL https://get.docker.com/ | sh

RUN wget https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker && \
    cp ./wrapdocker /usr/local/bin/wrapdocker && \
    chmod +x /usr/local/bin/wrapdocker

VOLUME /var/lib/docker

# rake
ADD . /workdir
RUN bundle exec rake assets:precompile
