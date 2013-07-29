all:
	jekyll build
	make css

css:
	lessc assets/css/style.less > assets/css/style.css

watch:
	jekyll build --watch &
	make css &
	watchr -e "watch('assets/css/.*\.less') { system 'make' }"

deploy:
	ssh root@jules.boussekeyt.org " \
		cd /home/grdn.io; \
		git pull origin master; \
		git submodule update --init; \
		cd game-of-life && make css && cd ..; \
		make \
	"

.PHONY: deploy watch
