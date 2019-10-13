.PHONY: slack confluence datadog jira sha
default: build

build: jira confluence slack datadog

datadog:
	@brew remove -f --ignore-dependencies datadog || true
	brew install  --verbose --build-bottle datadog
	brew bottle datadog
	$(eval old := $(shell grep sha256 datadog.rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard datadog*gz,/dev/null)) |awk '{ print $$1}'))
	sed -i'' -e "s#$(old)#$(new)#g" datadog.rb

jira:
	@brew remove -f --ignore-dependencies jira || true
	brew install --verbose --build-bottle jira
	brew bottle jira
	$(eval old := $(shell grep sha256 jira.rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard jira*gz, /dev/null)) |awk '{ print $$1}'))
	sed -i'' -e "s#$(old)#$(new)#g" jira.rb

slack:
	@brew remove -f --ignore-dependencies slack || true
	brew install --verbose --build-bottle ./slack.rb
	brew bottle slack
	$(eval old := $(shell grep sha256 slack.rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard slack*gz, /dev/null)) |awk '{ print $$1}'))
	sed -i'' -e "s#$(old)#$(new)#g" slack.rb

confluence:
	@brew remove -f --ignore-dependencies confluence || true
	brew install --verbose --build-bottle confluence
	brew bottle confluence
	$(eval old := $(shell grep sha256 confluence.rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard confluence*gz, /dev/null)) |awk '{ print $$1}'))
	sed -i'' -e "s#$(old)#$(new)#g" confluence.rb

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
	brew remove -f --ignore-dependencies gerbil-scheme-ober
	brew install --verbose --build-bottle ./gerbil-scheme-ober.rb
	brew bottle --verbose gerbil-scheme-ober
	$(eval old := $(shell grep sha256 gerbil-scheme-ober.rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard gerbil-scheme-ober*gz, /dev/null)) |awk '{ print $$1}'))
	sed -i'' -e "s#$(old)#$(new)#g" gerbil-scheme-ober.rb

gerbil-current:
	@brew remove -f --ignore-dependencies gerbil-scheme-current
	@brew install --verbose --HEAD --build-bottle ./gerbil-scheme-current.rb
	@brew bottle --verbose gerbil-scheme-current

gambit:
	brew remove -f --ignore-dependencies gambit-scheme-ober
	brew install --verbose --build-bottle ./gambit-scheme-ober.rb
	brew bottle --verbose gambit-scheme-ober
	$(eval old := $(shell grep sha256 gambit-scheme-ober.rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard gambit-scheme-ober*gz, /dev/null)) |awk '{ print $$1}'))
	sed -i'' -e "s#$(old)#$(new)#g" gambit-scheme-ober.rb

system: gambit gerbil
