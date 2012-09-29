all:
	jekyll
	recess --compress assets/css/style.less > assets/css/style.css

deploy:
	ssh root@jules.boussekeyt.org "cd /home/grdn.io && git pull origin master && git submodule update --init && make"

.PHONY: deploy
