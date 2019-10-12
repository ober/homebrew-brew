.PHONY: slack confluence datadog jira sha
default: build

build: jira confluence slack datadog

datadog: old := $(shell grep sha256 datadog.rb|awk '{ print $$2}'|tr -d '"')
datadog: new := $(shell shasum -a 256 $(firstword $(wildcard datadog*gz)) |awk '{ print $$1}')
datadog:
	@brew remove -f --ignore-dependencies datadog || true
	brew install  --verbose --build-bottle datadog
	brew bottle datadog
	gsed -i "s#$(old)#$(new)#g" datadog.rb

jira: old := $(shell grep sha256 jira.rb|awk '{ print $$2}'|tr -d '"')
jira: new := $(shell shasum -a 256 $(firstword $(wildcard jira*gz)) |awk '{ print $$1}'|tr -d '"')
jira:
	@brew remove -f --ignore-dependencies jira || true
	brew install --verbose --build-bottle jira
	brew bottle jira
	gsed -i "s#$(old)#$(new)#g" jira.rb

slack: old := $(shell grep sha256 slack.rb|awk '{ print $$2}'|tr -d '"')
slack: new := $(shell shasum -a 256 $(firstword $(wildcard slack*gz)) |awk '{ print $$1}')
slack:
	@brew remove -f --ignore-dependencies slack || true
	brew install --verbose --build-bottle ./slack.rb
	brew bottle slack
	gsed -i "s#$(old)#$(new)#g" slack.rb

confluence: old := $(shell grep sha256 confluence.rb|awk '{ print $$2}'|tr -d '"')
confluence: new := $(shell shasum -a 256 $(firstword $(wildcard confluence*gz)) |awk '{ print $$1}')
confluence:
	@brew remove -f --ignore-dependencies confluence || true
	brew install --verbose --build-bottle confluence
	brew bottle confluence
	gsed -i "s#$(old)#$(new)#g" confluence.rb

build-head:
	brew install --verbose --build-bottle gambit-scheme-current
	brew bottle gambit-scheme-current
	brew install --verbose --build-bottle gerbil-scheme-current
	brew bottle gerbil-scheme-current

remove-all:
	@brew remove -f --ignore-dependencies jira datadog confluence slack gerbil-scheme-ober gambit-scheme-ober

install-all:
	@brew install slack jira confluence datadog

cycle: remove-all install-all
	@echo "All done!"

gerbil:
	@brew remove -f --ignore-dependencies gerbil-scheme-ober
	@brew install --verbose --build-bottle ./gerbil-scheme-ober.rb
	@brew bottle gerbil-scheme-ober --verbose

gerbil-current:
	@brew remove -f --ignore-dependencies gerbil-scheme-current
	@brew install --verbose --HEAD --build-bottle ./gerbil-scheme-current.rb
	@brew bottle gerbil-scheme-current --verbose

gambit:
	@brew remove -f --ignore-dependencies gambit-scheme-ober
	@brew install --verbose --build-bottle ./gambit-scheme-ober.rb
	@brew bottle gambit-scheme-ober--verbose

system: gambit gerbil
