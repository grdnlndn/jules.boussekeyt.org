all:
	jekyll
	recess --compress css/style.less > css/style.css
