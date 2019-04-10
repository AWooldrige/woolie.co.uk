vendor: Gemfile
	bundle install --path vendor/bundle

output: vendor nanoc.yaml Rules $(shell find content lib layouts)
	bundle exec nanoc compile -C

.PHONY: view
view: output
	bundle exec nanoc view -o 0.0.0.0

.PHONY: test
test: local_tests

.PHONY: local_tests
local_tests: output
	bundle exec nanoc check internal_links stale mixed_content no_geotags no_todos


.PHONY: clean
clean:
	rm -rf output vendor

.PHONY: bundle-update
bundle-update:
	bundle update
