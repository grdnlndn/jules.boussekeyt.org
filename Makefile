all:
	jekyll
	recess --compress assets/css/style.less > assets/css/style.css

deploy:
	ssh root@boussekeyt.org "cd /home/jules.boussekeyt.org && git pull origin master && git submodule update --init && make"

.PHONY: deploy
