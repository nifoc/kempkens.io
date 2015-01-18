all: compile compress upload

compile: clean
	@echo "=== Generating static files"
	@bundle exec jekyll build
	@echo "Done."

compress:
	@echo "=== Compressing generated files"
	@find ./_site -type f | xargs zopfli --gzip --i25
	@echo "Done."

upload:
	@echo "=== Syncing files"
	@rsync -avz --no-o --no-g -e ssh --chmod=og=r -p --delete _site/ webserver.kempkens.io:/var/www/main
	@echo "Done."
	@echo "=== Changing permissions"
	@ssh webserver.kempkens.io chown -R www:www /var/www/main
	@echo "Done."

clean:
	@rm -rf ./_site
