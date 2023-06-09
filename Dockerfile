FROM python:3.9

ENV PYTHONUNBUFFERED 1

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get -y update &&  \
    apt-get install -y \
    apt-transport-https ca-certificates dirmngr \
    locales tzdata sudo bash-completion iproute2 \
    tar unzip curl rsync vim nano tree sshpass cron gnupg2 \
    build-essential libcap2-bin cmake \
    graphviz openssh-client \
    libssl-dev libffi-dev zlib1g-dev lsb-release \
    unixodbc unixodbc-dev \
    python3-pip python3-dev \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install gsap

RUN python -m pip install pip --upgrade --default-timeout=100 future
RUN pip install --upgrade setuptools wheel

WORKDIR /home/dw/blog

COPY ./requirements.txt ./
RUN pip install --no-cache -r requirements.txt

COPY . ./

RUN python3 ./manage.py migrate

EXPOSE 8001
CMD ["python3", "/home/dw/blog/manage.py", "runserver", "0.0.0.0:8001"] 