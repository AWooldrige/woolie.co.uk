install_deps:
	bundle version || sudo gem install bundler
	bundle install --path vendor/bundle
	
test:

compile: install_deps
	bundle exec nanoc compile
