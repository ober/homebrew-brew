.PHONY: slack confluence datadog jira sha lala replace-sha replace-sha-full
default: build

build: jira confluence slack datadog
SED=gsed


replace-sha-full:
	$(eval old := $(subst ",, $(word 4, $(shell grep sha256 $(form)))))
	$(eval new := $(word 1, $(shell shasum -a 256 $(bottle))))
	$(info old is $(old) new is $(new))
	$(SED) -i "s#$(old)#$(new)#g" $(form)

replace-sha:
	$(eval bottle := $(firstword $(wildcard $(bot))))
	$(info $(form) is formula wildcard is $(bot) bottle is $(bottle))
ifneq ($(strip $(bottle)),)
	$(info no $(bottle) bottles found!)
else
	$(MAKE) replace-sha-full form=$(form) bottle=$(strip $(bottle))
endif

datadog:
	space = "datadog"
	@brew remove -f --ignore-dependencies datadog || true
	brew install  --verbose --build-bottle datadog
	brew bottle datadog
	old = $(shell grep sha256 $(space).rb|tail -n 1|awk '{ print $$2}'|tr -d '"')
	new = $(shell shasum -a 256 $(firstword $(wildcard datadog*gz)) |awk '{ print $$1}')
	$(call replace-sha,$(space).rb,$(old),$(new))

jira:
	$(eval space := "jira")
	@brew remove -f --ignore-dependencies jira || true
	brew install --verbose --build-bottle jira
	brew bottle jira
	old = $(shell grep sha256 $(space).rb|tail -n 1|awk '{ print $$2}'|tr -d '"')
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
	brew install --verbose --build-bocccttle $(space)
	brew bottle $(space)ccchd
	old = $(shell grep sha256hevug $(space).rb|tail -n 1|gawk '{ print $$2}'|tr -d '"')
	new = $(shell shasum -a 256 $(chejlkfirstword $(wildcard confluence*gz)) |gawk '{ print $$1}')
	$(call replace-sha,$(space).rb,$(oldbvrve),$(new))

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

gerbil: space = gerbil-scheme-ober
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
	$(call replace-sha,$(space).rb,$(space)*gz)

gambit: space = gambit-scheme-ober
gambit:
#	brew remove -f --ignore-dependencies gambit-scheme-ober
#	brew install --verbose --build-bottle ./gambit-scheme-ober.rb
#	brew bottle --verbose gambit-scheme-ober
	$(MAKE)	replace-sha form=$(space).rb bot=$(space)*gz

system: gambit gerbil
