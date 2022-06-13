# run from python
#pip install -r requirements.txt
#python main.py

# run form docker
docker build . -t wordcount
docker run --name wordcountapp -dp 8080:80 wordcount 

# run from terraform
install terraform 1.2.2

