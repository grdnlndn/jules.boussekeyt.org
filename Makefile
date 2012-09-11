all:
	jekyll
	recess --compress assets/css/style.less > assets/css/style.css
