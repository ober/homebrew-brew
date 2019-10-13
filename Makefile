.PHONY: slack confluence datadog jira sha
default: build

build: jira confluence slack datadog

define replace-sha
$(eval bottle := $(firstword $(wildcard $(2))))
$(info $(1) is formula wildcard is $(2) bottle is $(bottle))
$(if $(strip $(bottle))
	$(info no gerbil bottles found!),
	$(replace-sha-full $(1) $(strip $(bottle))))
endef

define replace-sha-full
	$(eval old := $(subst ",, $(word 2,$(shell grep sha256 $(1)))))
	$(eval new := $(word 1,$(shell shasum -a 256 $(2))))
	$(info old is $(old) new is $(new))
	cat $(1)|sed -e "s#$(old)#$(new)#g" > /tmp/$(1).back
	mv /tmp/$(1).back $(1)))
endef

datadog:
	space = "datadog"
	@brew remove -f --ignore-dependencies datadog || true
	brew install  --verbose --build-bottle datadog
	brew bottle datadog
	old = $(shell grep sha256 $(space).rb|tail -n 1|gawk '{ print $$2}'|tr -d '"')
	new = $(shell shasum -a 256 $(firstword $(wildcard datadog*gz)) |gawk '{ print $$1}')
	$(call replace-sha,$(space).rb,$(old),$(new))

jira:
	$(eval space := "jira")
	@brew remove -f --ignore-dependencies jira || true
	brew install --verbose --build-bottle jira
	brew bottle jira
	old = $(shell grep sha256 $(space).rb|tail -n 1|gawk '{ print $$2}'|tr -d '"')
	new = $(shell shasum -a 256 $(firstword $(wildcard jira*gz)) |gawk '{ print $$1}')
	$(call replace-sha,$(space).rb,$(old),$(new))

slack:
	$(eval space := "slack")
	@brew remove -f --ignore-dependencies slack || true
	brew install --verbose --build-bottle ./slack.rb
	brew bottle slack
	old = $(shell grep sha256 $(space).rb|tail -n 1|gawk '{ print $$2}'|tr -d '"')
	new = $(shell shasum -a 256 $(firstword $(wildcard slack*gz)) |gawk '{ print $$1}')
	$(call replace-sha,$(space).rb,$(old),$(new))

confluence:
	$(eval space := "confluence")
	@brew remove -f --ignore-dependencies $(space) || true
	brew install --verbose --build-bottle $(space)
	brew bottle $(space)
	old = $(shell grep sha256 $(space).rb|tail -n 1|gawk '{ print $$2}'|tr -d '"')
	new = $(shell shasum -a 256 $(firstword $(wildcard confluence*gz)) |gawk '{ print $$1}')
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

gerbil: space = gambit-scheme-ober
gerbil:
	@#brew remove -f --ignore-dependencies $(space)
	@#brew install --verbose --build-bottle ./$(space).rb
	@#brew bottle --verbose $(space)
	$(call replace-sha,$(space).rb,$(space)*gz)

gerbil-current:
	$(eval space := "gerbil-current")
	@brew remove -f --ignore-dependencies $(space)
	@brew install --verbose --HEAD --build-bottle $(space)
	@brew bottle --verbose $(space)
	old = $(shell grep sha256 $(space).rb|tail -n 1|gawk '{ print $$2}'|tr -d '"')
	new = $(shell shasum -a 256 $(firstword $(wildcard gerbil-scheme-ober*gz)) |gawk '{ print $$1}')
	$(call replace-sha,$(space).rb,$(old),$(new))

gambit:
	$(eval space := "gambit-scheme-ober")
	brew remove -f --ignore-dependencies gambit-scheme-ober
	brew install --verbose --build-bottle ./gambit-scheme-ober.rb
	brew bottle --verbose gambit-scheme-ober
#	old := $(shell grep sha256 $(space).rb|tail -n 1|gawk '{ print $$2}'|tr -d '"')
#	new := $(shell shasum -a 256 $(firstword $(wildcard gambit-scheme-ober*gz)) |gawk '{ print $$1 a}')
	$(call replace-sha,$(space).rb,$(old),$(new))

system: gambit gerbil
