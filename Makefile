.PHONY: gerbil-scheme-ober gambit-scheme-ober slack confluence datadog jira sha lala replace-sha replace-sha-full
default: build

build: jira confluence slack datadog
SED=gsed

$(eval PATH := "/usr/local/bin:$(PATH)")

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

app:
	@brew remove -f --ignore-dependencies $(space) || true
	brew install --verbose --build-bottle $(space)
	brew bottle $(space)

datadog:
	$(MAKE) app space=datadog

pagerduty:
	$(MAKE) app space=pagerduty

jira:
	$(MAKE) app space=jira

slack:
	$(MAKE) app space=slack

confluence:
	$(MAKE) app space=confluence

gerbil:
	$(MAKE) app space=gerbil-scheme-ober

gambit-head:
	@brew remove -f --ignore-dependencies gambit-scheme-current || true
	brew install --HEAD --verbose --build-bottle gambit-scheme-current
	brew bottle gambit-scheme-current
	$(MAKE) replace-sha gambit-scheme-current.rb gambit-scheme-current*gz

gerbil-head:

	@brew remove -f --ignore-dependencies gerbil-scheme-current || true
	brew install --HEAD --verbose gerbil-scheme-current
	ln -s /usr/local/Cellar/gerbil-scheme-current/HEAD /usr/local/opt/gerbil-scheme-current
#	brew bottle gerbil-scheme-current
#	$(MAKE) replace-sha gerbil-scheme-current.rb gerbil-scheme-current*gz

gambit:
	$(MAKE) app space=gambit-scheme-ober

remove-all:
	@brew remove -f --ignore-dependencies jira datadog confluence slack gerbil-scheme-ober gambit-scheme-ober

cycle: remove-all install-all
	@echo "All done!"

system: gambit gerbil
