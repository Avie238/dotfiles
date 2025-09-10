FROM python:3.12

COPY requirements.txt .

RUN pip install -r requirements.txt
# RUN pip install flask pyyaml sqlalchemy pandas Flask-APScheduler Flask-Login python-dotenv Flask-Bcrypt Flask-Mail Flask-SQLAlchemy Flask-Migrate Flask-WTF joblib PyPDF2 torch scipy matplotlib seaborn psycopg2

COPY . .

CMD ["python", "-m", "flask", "--app", "run.py", "run", "--host=0.0.0.0", "--port=5020"]
