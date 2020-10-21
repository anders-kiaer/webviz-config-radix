FROM python:3.8-slim

EXPOSE 5000

RUN useradd --create-home appuser

WORKDIR /home/appuser
USER appuser

ENV PATH="${PATH}:/home/appuser/.local/bin" \
    PYTHONFAULTHANDLER=1

RUN pip install --no-cache-dir \
        gunicorn \
        webviz-config==0.2.0 \
        webviz-subsurface==0.* \
        libecl opm  # Temporary workaround (see ...)

COPY --chown=appuser . dash_app

CMD gunicorn \
        --access-logfile "-" \
        --bind 0.0.0.0:5000 \
        --keep-alive 120 \
        --max-requests 40 \
        --preload \
        --workers 10 \
        --worker-class gthread \
        --worker-tmp-dir /dev/shm \
        --threads 4 \
        --timeout 100000 \
        "dash_app.webviz_app:server"