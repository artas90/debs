automate creation of deb packages

cd [appname]

docker run -it --rm -v `pwd`:/app -w /app ubuntu:16.04 bash /app/build.sh
