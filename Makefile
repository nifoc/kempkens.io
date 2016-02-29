all: compile compress upload

compile: clean
	@echo "=== Generating static files"
	@bundle exec jekyll build
	@echo "Done."

compress: compile
	@echo "=== Compressing generated files"
	@find ./_site -type f | xargs zopfli --gzip --i30
	@find ./_site -type f ! -name "*.gz" | xargs -I {} bro --quality 11 --input {} --output {}.br
	@find ./_site -type f -name "*.br" | xargs chmod 644
	@echo "Done."

upload:
	@echo "=== Syncing files"
	@rsync -avz --no-o --no-g -e ssh --chmod=og=r -p --delete _site/ kempkens.io:/iocage/jails/506fd9f8-15c0-11e5-adf5-477a0b920463/root/var/www/main
	@echo "Done."
	@echo "=== Changing permissions"
	@ssh kempkens.io chmod 755 /iocage/jails/506fd9f8-15c0-11e5-adf5-477a0b920463/root/var/www/main
	@ssh kempkens.io find /iocage/jails/506fd9f8-15c0-11e5-adf5-477a0b920463/root/var/www/main -type d -exec chmod 755 {} +
	@echo "Done."

clean:
	@rm -rf ./_site
