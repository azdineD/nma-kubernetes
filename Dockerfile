FROM python:3.10

WORKDIR /app

COPY . /app

RUN pip install --upgrade pip
RUN pip install flask flask_sqlalchemy pymysql

EXPOSE 5000

CMD ["python", "app.py"]
