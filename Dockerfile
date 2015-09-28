FROM poklet/centos-baseimage

MAINTAINER Kevin Trowbridge "kevin@alpinenow.com"

COPY docker_build/templates/limits.conf /etc/security/limits.conf
COPY docker_build/templates/90-nproc.conf /etc/security/limits.d/90-nproc.conf
COPY docker_build/templates/sysctl.conf /etc/sysctl.conf

RUN yum -y update

# Install Oracle Java
RUN curl -v -j -k -L -H "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm > jdk-7u79-linux-x64.rpm
RUN rpm -ivh ./jdk-7u79-linux-x64.rpm
RUN alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_79/jre/bin/java 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/jdk1.7.0_79/bin/javac 200000
RUN alternatives --install /usr/bin/jar jar /usr/java/jdk1.7.0_79/bin/jar 200000
ENV JAVA_HOME /usr/java/latest
RUN rm jdk-7u79-linux-x64.rpm

# packages necessary for compiling jruby
RUN yum install -y tar gcc-c++

ENV JRUBY_VERSION 1.7.22
RUN mkdir /opt/jruby \
  && curl -fSL https://s3.amazonaws.com/jruby.org/downloads/${JRUBY_VERSION}/jruby-bin-${JRUBY_VERSION}.tar.gz -o /tmp/jruby.tar.gz \
  && tar -zx --strip-components=1 -f /tmp/jruby.tar.gz -C /opt/jruby \
  && rm /tmp/jruby.tar.gz \
  && update-alternatives --install /usr/local/bin/ruby ruby /opt/jruby/bin/jruby 1
ENV PATH /opt/jruby/bin:$PATH
RUN chmod 777 -R /opt/jruby/lib/ruby/gems/shared /opt/jruby/bin

# You need to install git to be able to use gems from git repositories.
RUN yum install -y git

# Docker is kind of weird about users: natively it wants to run everything as root.  There is a debate as to whether this
# is good or not.  Chorus can't work that way mostly because of its current use of Postgresql: postgresql initdb cannot
# be run as root.  So, I go to a good deal of trouble to run Chorus with a 'chorus' user.

RUN groupadd chorus && useradd -g chorus chorus
# RUN mkdir -p /home/chorus
WORKDIR /home/chorus

RUN echo 'gem: --no-rdoc --no-ri' >> /home/chorus/.gemrc

RUN echo "CHORUS_HOME=/home/chorus; export CHORUS_HOME" >> /home/chorus/.bashrc
RUN echo "PATH=/opt/jruby/bin:$CHORUS_HOME/bin:$CHORUS_HOME/postgres/bin:\$PATH; export PATH" >> /home/chorus/.bashrc
RUN echo "JRUBY_OPTS='-X+O --client -J-Xmx2048m -J-Xms512m -J-Xmn128m -J-XX:MaxPermSize=128m -Xcext.enabled=true -J-Djava.library.path=$CHORUS_HOME/vendor/hadoop/lib/'; export JRUBY_OPTS" >> /home/chorus/.bashrc

RUN chown -R chorus:chorus /home/chorus

RUN runuser -l chorus -c 'gem install bundler'

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
COPY components components
RUN chown -R chorus:chorus /home/chorus
RUN runuser -l chorus -c 'bundle install --retry 5'

COPY . ./
RUN chown -R chorus:chorus /home/chorus
RUN tar xzC /home/chorus -f /home/chorus/packaging/postgres/postgres-redhat6.2-9.2.4.tar.gz

RUN runuser -l chorus -c 'rake development:init --trace'

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD runuser -l chorus -c 'packaging/chorus_control.sh start'