FROM python:3.13-alpine3.21

RUN addgroup -S nonroot \
    && adduser -S nonroot -G nonroot

WORKDIR /service/app

COPY requirements.txt /service/app
COPY application /service/app/application

RUN apk --no-cache --update add build-base curl npm && \
      pip install --upgrade pip && \
      pip install -r requirements.txt

EXPOSE 8081

ENV PYTHONUNBUFFERED=1

HEALTHCHECK --timeout=30s --interval=1m30s --retries=5 \
  CMD ["curl", "-s", "--fail", "http://localhost:8081/health", "||", "exit 1"]

USER nonroot

CMD ["python3", "-u", "application/app.py"]
