FROM ubuntu:24.04

LABEL org.opencontainers.image.title="{{ organisation }}/{{ repository }}"
LABEL org.opencontainers.image.description="Container image for {{ organisation }}/{{ repository }}"
LABEL org.opencontainers.image.vendor="{{ organisation }}"
LABEL org.opencontainers.image.url="https://github.com/{{ organisation }}/{{ repository }}"
LABEL org.opencontainers.image.source="https://github.com/{{ organisation }}/{{ repository }}"
LABEL org.opencontainers.image.documentation="https://{{ organisation }}.github.io/{{ repository }}/"

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      su-exec \
      tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r appuser && \
    useradd -r -g appuser -d /app -s /usr/sbin/nologin appuser

WORKDIR /app
COPY docker/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh && chown -R appuser:appuser /app
USER appuser
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["sh", "-c", "echo 'Template container built successfully. Define CMD or override at runtime.' && tail -f /dev/null"]
