all:
	jekyll build
	make css

css:
	lessc assets/css/style.less > assets/css/style.css

dev:
	jekyll build --watch &
	make css &
	watchr -e "watch('assets/css/.*\.less') { system 'make' }"

deploy:
	ssh root@jules.boussekeyt.org "cd /home/grdn.io && git pull origin master && git submodule update --init && make"

.PHONY: deploy watch
