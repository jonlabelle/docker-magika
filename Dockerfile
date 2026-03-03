FROM python:slim

LABEL org.opencontainers.image.authors="Jon LaBelle <https://jonlabelle.com>" \
  org.opencontainers.title="magika" \
  org.opencontainers.image.description="Docker image for Magika, a novel AI-powered file type detection tool that relies on the recent advance of deep learning to provide accurate detection." \
  org.opencontainers.image.source="https://github.com/jonlabelle/docker-magika" \
  org.opencontainers.image.licenses="MIT"

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1

# hadolint ignore=DL3008,DL3013
RUN apt-get update \
  && apt-get install --no-install-recommends --yes \
    libstdc++6 \
  && python -m pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir magika \
  && groupadd --system magika \
  && useradd --system --gid magika --create-home --home-dir /home/magika --shell /usr/sbin/nologin magika \
  && mkdir -p /workspace \
  && chown -R magika:magika /workspace /home/magika \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /workspace
USER magika
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
