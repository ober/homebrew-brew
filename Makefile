.PHONY: slack confluence datadog jira
default: build

build:
	brew tap ober/brew
	@brew remove -f --ignore-dependencies jira datadog confluence slack || true
	for pkg in datadog jira confluence slack; do \
	    brew install --build-bottle $$pkg --verbose; \
	    brew bottle $$pkg; \
	done

datadog:
	@brew remove -f --ignore-dependencies datadog
	brew install --build-bottle datadog --verbose
	brew bottle datadog

build-head:
	brew install --build-bottle gambit-scheme-current --verbose
	brew bottle gambit-scheme-current
	brew install --build-bottle gerbil-scheme-current --verbose
	brew bottle gerbil-scheme-current

remove-all:
	@brew remove -f --ignore-dependencies jira datadog confluence slack gerbil-scheme-ssl gambit-scheme-ssl

install-all:
	@brew install slack jira confluence datadog

cycle: remove-all install-all
	@echo "All done!"

sha:
	gsed -i -e "s#sha256 \"[0-9][a-f].*\" => :mojave#sha256 \"`shasum -a 256 $(firstword $(wildcard datadog*mojave*gz))`\" => :mojave#g" datadog.rb

gerbil:
	@brew remove -f --ignore-dependencies gerbil-scheme-ssl
	@brew install --build-bottle ./gerbil-scheme-ssl.rb --verbose
	@brew bottle gerbil-scheme-ssl --verbose

gambit:
	@brew remove -f --ignore-dependencies gambit-scheme-ssl
	@brew install --build-bottle ./gambit-scheme-ssl.rb --verbose
	@brew bottle gambit-scheme-ssl --verbose

system: gambit gerbil
