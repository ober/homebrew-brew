.PHONY: gerbil-scheme-ober gambit-scheme-ober slack confluence datadog jira sha replace-sha replace-sha-full
default: build

build: jira confluence slack datadog pagerduty
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

hide-shared:
	@./hide-shared-libs -d /usr/local/opt/openssl@1.1 -m
	@./hide-shared-libs -d /usr/local/opt/libyaml -m
	@./hide-shared-libs -d /usr/local/opt/zlib -m
	@./hide-shared-libs -d /usr/local/opt/lmdb -m
	@./hide-shared-libs -d /usr/local/opt/leveldb -m

restore-shared:
	@./hide-shared-libs -d /usr/local/opt/openssl@1.1 -r
	@./hide-shared-libs -d /usr/local/opt/libyaml -r
	@./hide-shared-libs -d /usr/local/opt/zlib -r
	@./hide-shared-libs -d /usr/local/opt/lmdb -r
	@./hide-shared-libs -d /usr/local/opt/leveldb -r

app:
	@brew remove -f --ignore-dependencies $(space) || true
	brew install --verbose --build-bottle $(space)
	brew bottle $(space)
	$(MAKE) restore-shared

datadog: $(eval PATH := "$(PATH):/usr/local/bin")
datadog:
	$(MAKE) app space=datadog

pagerduty:
	$(MAKE) app space=pagerduty

jira:
	$(MAKE) app space=jira

slack:
	$(MAKE) app space=gerbil-slack

confluence:
	$(MAKE) app space=confluence

gerbil:
	$(MAKE) app space=gerbil-scheme-ober

gerbil-gcc:
	$(MAKE) app space=gerbil-scheme-gcc

gambit-gcc:
	$(MAKE) app space=gambit-scheme-gcc

gambit-head:
	@brew remove -f --ignore-dependencies gambit-scheme-current || true
	brew install --HEAD --verbose --build-bottle gambit-scheme-current
	brew bottle gambit-scheme-current
	$(MAKE) replace-sha gambit-scheme-current.rb gambit-scheme-current*gz

gerbil-head:
	@/usr/local/bin/brew remove -f --ignore-dependencies gerbil-scheme-current || true
	ln -s /usr/local/Cellar/gerbil-scheme-current/HEAD /usr/local/opt/gerbil-scheme-current || true
	/usr/local/bin/brew install --HEAD --verbose gerbil-scheme-current || true
#	brew bottle gerbil-scheme-current
#	$(MAKE) replace-sha gerbil-scheme-current.rb gerbil-scheme-current*gz

gambit:
	$(MAKE) app space=gambit-scheme-ober

remove-all:
	@brew remove -f --ignore-dependencies jira datadog confluence slack gerbil-scheme-ober gambit-scheme-ober

cycle: remove-all install-all
	@echo "All done!"

system: gambit gerbil

static:
	docker build -t centos-static .
	docker tag centos-static jaimef/centos:static
