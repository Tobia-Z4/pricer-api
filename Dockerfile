# Dockerコマンド/Githubアクション実行
FROM python:3.9.6

LABEL maintainer "hoge hoge <xxxxx@gmail.com>"
LABEL version="0.1"
LABEL description="stockpricer"

ENV TZ Asia/Tokyo

RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

# python module install 
RUN apt-get install -y vim less
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools

# Github - Build
COPY ./_build/server/requirements.txt /root/
COPY ./server/ /root/

# Install - Python
RUN pip install -r ./root/requirements.txt

EXPOSE 8000

# GCP/AWS -Run
WORKDIR /root
CMD ["uvicorn", "app:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]
