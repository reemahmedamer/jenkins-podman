FROM python:3.9-slim
WORKDIR /app
COPY app.py .
RUN pip install --no-cache-dir flask
EXPOSE 5000  # <-- This is the critical addition
CMD ["python", "app.py"]