FROM python:3.13.1-slim-bullseye

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 8000

ENTRYPOINT [ "gunicorn" ]

CMD [ "-b", "0.0.0.0:8000", "rest-api:app" ]

