FROM debian:bookworm-slim

ARG DOCKER_USER=gh-action-runner
ENV DOCKER_USER=$DOCKER_USER

ARG RUNNER_VERSION="2.320.0"

# prevent the install script prompting for user interaction
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y \
    && useradd -m $DOCKER_USER \
    && mkdir /home/$DOCKER_USER/action-runner

RUN apt-get install -y --no-install-recommends \
    curl build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

# install the action runner
RUN cd /home/$DOCKER_USER/action-runner \
 && curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v2.320.0/actions-runner-linux-x64-2.320.0.tar.gz \
  && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN chown -R $DOCKER_USER:$DOCKER_USER /home/$DOCKER_USER
RUN /home/$DOCKER_USER/action-runner/bin/installdepdendencies.sh

COPY start.sh start.sh

RUN chmod +x start.sh

USER $DOCKER_USER

ENTRYPOINT [ "./start.sh" ]
