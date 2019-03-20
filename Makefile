vendor: Gemfile
	bundle install --path vendor/bundle

output: vendor nanoc.yaml Rules $(shell find content lib layouts)
	bundle exec nanoc compile -C

.PHONY: view
view: output
	bundle exec nanoc view -o 0.0.0.0

.PHONY: clean
clean:
	rm -rf output vendor

.PHONY: bundle-update
bundle-update:
	bundle update
