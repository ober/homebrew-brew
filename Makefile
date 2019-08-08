.PHONY: slack confluence datadog jira sha
default: build

build: slack jira confluence slack datadog

datadog: old := $(shell grep sha256 datadog.rb|awk '{ print $$2}')
datadog: new := $(shell shasum -a 256 $(firstword $(wildcard datadog*gz)) |awk '{ print $$1}')
datadog:
	@brew remove -f --ignore-dependencies datadog || true
	brew install --build-bottle datadog --verbose
	brew bottle datadog
	@sed -i -e "s#$(old)#$(new)#g" datadog.rb

jira: old := $(shell grep sha256 jira.rb|awk '{ print $$2}')
jira: new := $(shell shasum -a 256 $(firstword $(wildcard jira*gz)) |awk '{ print $$1}')
jira:
	@brew remove -f --ignore-dependencies jira || true
	brew install --build-bottle jira --verbose
	brew bottle jira
	@sed -i -e "s#$(old)#$(new)#g" jira.rb

slack: old := $(shell grep sha256 slack.rb|awk '{ print $$2}')
slack: new := $(shell shasum -a 256 $(firstword $(wildcard slack*gz)) |awk '{ print $$1}')
slack:
	@brew remove -f --ignore-dependencies slack || true
	brew install --build-bottle slack --verbose
	brew bottle slack
	@sed -i -e "s#$(old)#$(new)#g" slack.rb

confluence: old := $(shell grep sha256 confluence.rb|awk '{ print $$2}')
confluence: new := $(shell shasum -a 256 $(firstword $(wildcard confluence*gz)) |awk '{ print $$1}')
confluence:
	@brew remove -f --ignore-dependencies confluence || true
	brew install --build-bottle confluence --verbose
	brew bottle confluence
	@sed -i -e "s#$(old)#$(new)#g" confluence.rb

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

gerbil:
	@brew remove -f --ignore-dependencies gerbil-scheme-ssl
	@brew install --build-bottle ./gerbil-scheme-ssl.rb --verbose
	@brew bottle gerbil-scheme-ssl --verbose

gerbil-current:
	@brew remove -f --ignore-dependencies gerbil-scheme-current
	@brew install --HEAD --build-bottle ./gerbil-scheme-current.rb --verbose
	@brew bottle gerbil-scheme-current --verbose

gambit:
	@brew remove -f --ignore-dependencies gambit-scheme-ssl
	@brew install --build-bottle ./gambit-scheme-ssl.rb --verbose
	@brew bottle gambit-scheme-ssl --verbose

system: gambit gerbil
