vendor: Gemfile
	bundle version || sudo gem install bundler
	bundle install --path vendor/bundle

output: vendor nanoc.yaml Rules $(shell find content lib layouts)
	bundle exec nanoc compile -C

.PHONY: view
view: output
	cd output; ruby -run -e httpd . -p 8080

.PHONY: clean
clean:
	rm -rf output vendor
