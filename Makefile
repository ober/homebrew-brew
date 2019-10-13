.PHONY: slack confluence datadog jira sha
default: build

build: jira confluence slack datadog

define replace-sha
	$(info "$(1) is 1, $(2) is 2 $(3) is 3")
	cat $(1)|sed -e "s#$(2)#$(3)#g" > /tmp/$(1).back
	mv /tmp/$(1).back $(1)
endef

datadog:
	$(eval space := "datadog")
	@brew remove -f --ignore-dependencies datadog || true
	brew install  --verbose --build-bottle datadog
	brew bottle datadog
	$(eval old := $(shell grep sha256 datadog.rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard datadog*gz)) |awk '{ print $$1}'))
	$(call replace-sha,$(space).rb,$(old),$(new))

jira:
	$(eval space := "jira")
	@brew remove -f --ignore-dependencies jira || true
	brew install --verbose --build-bottle jira
	brew bottle jira
	$(eval old := $(shell grep sha256 jira.rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard jira*gz)) |awk '{ print $$1}'))
	$(call replace-sha,$(space).rb,$(old),$(new))

slack:
	$(eval space := "slack")
	@brew remove -f --ignore-dependencies slack || true
	brew install --verbose --build-bottle ./slack.rb
	brew bottle slack
	$(eval old := $(shell grep sha256 slack.rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard slack*gz)) |awk '{ print $$1}'))
	$(call replace-sha,$(space).rb,$(old),$(new))


confluence:
	$(eval space := "confluence")
	@brew remove -f --ignore-dependencies $(space) || true
	brew install --verbose --build-bottle $(space)
	brew bottle $(space)
	$(eval old := $(shell grep sha256 $(space).rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard confluence*gz)) |awk '{ print $$1}'))
	$(call replace-sha,$(space).rb,$(old),$(new))


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
	$(eval space := "gerbil-scheme-ober")
	brew remove -f --ignore-dependencies $(space)
	brew install --verbose --build-bottle ./$(space).rb
	brew bottle --verbose $(space)
	$(eval old := $(shell grep sha256 $(space)|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard gerbil-scheme-ober*gz)) |awk '{ print $$1}'))
	$(call replace-sha,$(space).rb,$(old),$(new))

gerbil-current:
	$(eval space := "gerbil-current")
	@brew remove -f --ignore-dependencies $(space)
	@brew install --verbose --HEAD --build-bottle $(space)
	@brew bottle --verbose $(space)
	$(eval old := $(shell grep sha256 $(space)|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard gerbil-scheme-ober*gz)) |awk '{ print $$1}'))
	$(call replace-sha,$(space).rb,$(old),$(new))

gambit:
	$(eval space := "gambit-scheme-ober")
	brew remove -f --ignore-dependencies gambit-scheme-ober
	brew install --verbose --build-bottle ./gambit-scheme-ober.rb
	brew bottle --verbose gambit-scheme-ober
	$(eval old := $(shell grep sha256 $(space).rb|tail -n 1|awk '{ print $$2}'|tr -d '"'))
	$(eval new := $(shell shasum -a 256 $(firstword $(wildcard gambit-scheme-ober*gz)) |awk '{ print $$1}'))
	$(call replace-sha,$(space).rb,$(old),$(new))

system: gambit gerbil
