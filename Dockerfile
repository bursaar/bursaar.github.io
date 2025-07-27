FROM jekyll/jekyll:4.2.2

WORKDIR /srv/jekyll

# Fix Git safety check
ENV GIT_CONFIG_SYSTEM=/etc/gitconfig
RUN git config --system --add safe.directory /srv/jekyll

# Pre-install gem dependencies for faster startup
COPY Gemfile Gemfile.lock ./
RUN bundle config set force_ruby_platform true \
 && bundle config set without 'test' \
 && echo 'precedence ::ffff:0:0/96 100' >> /etc/gai.conf \
 && bundle install
