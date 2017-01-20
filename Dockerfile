FROM debian:jessie
MAINTAINER Oliver Lineham <olineham@users.noreply.github.com>

RUN \
    DEBIAN_FRONTEND=noninteractive apt-get update \
        -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
        #-qq \
        --yes \
        --no-install-recommends \
        --no-install-suggests \
      build-essential \
      libffi-dev \
      libssl-dev \
      python3-virtualenv \
      python2.7-dev \
      python3 \
      python3-dev \
      python-pip \

    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# def checkout():
#   run('git clone -q -b %s %s %s' % (branch, repo, version_path))
COPY . /opt/pulse
WORKDIR /opt/pulse

# def links():
#   run("ln -s %s/data/db.json %s/data/db.json" % (shared_path, version_path))
#   run("ln -s %s/data/output %s/data/output" % (shared_path, version_path))

RUN \
    python3 -m virtualenv --python=python3 venv \
    && pip install --upgrade pip \
    && . venv/bin/activate \
    && pip install -r requirements.txt

ENV environment production

EXPOSE 8000

# env.use_ssh_config = True
# env.hosts = ["site@pulse"]

# repo = "https://github.com/18F/pulse"

#   branch = "production"
#   port = 3000

# ENV SITE_HOME /home/site/pulse/production
# ENV SHARED_PATH /home/site/pulse/production
# ENV VERSIONS_PATH /home/site/pulse/production/versions
# ENV VERSION_PATH /home/site/pulse/production/versions/current
# # current_path = "%s/current" % home

# # virtualenv = "pulse-%s" % environment


# ENV wsgi "pulse:app"

# # Only done on cold deploy.
# def init():
#   run("mkdir -p %s/data/output" % shared_path)
#   run("rmvirtualenv %s" % virtualenv)
#   run("mkvirtualenv %s" % virtualenv)
#   run("cd %s && make data_init" % version_path)

# def dependencies():
#   run('cd %s && workon %s && pip install -r requirements.txt' % (version_path, virtualenv))

# def make_current():
#   run('rm -f %s && ln -s %s %s' % (current_path, version_path, current_path))

# def start():
#   run(
#     (
#       "cd %s && workon %s && PORT=%i gunicorn %s -D --log-file=%s --pid %s"
#     ) % (current_path, virtualenv, port, wsgi, log_file, pid_file), pty=False
#   )

CMD [". venv/bin/activate && PORT=8000 gunicorn pulse:app --log-file=data/gunicorn.log --pid /tmp/gunicorn.pid]
