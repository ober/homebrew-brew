.PHONY: slack confluence datadog jira
default: build

build:
	brew tap ober/brew
	@brew remove -f --ignore-dependencies jira datadog confluence slack || true
	for pkg in datadog jira confluence slack; do \
	    brew install --build-bottle $$pkg --verbose; \
	    brew bottle $$pkg; \
	done

remove-all:
	@brew remove -f --ignore-dependencies jira datadog confluence slack gerbil-scheme-ssl gambit-scheme-ssl

install-all:
	@brew install slack jira confluence datadog

cycle: remove-all install-all
	@echo "All done!"

sha: $(eval confluence_sha := `shasum -a 256 $(firstword $(wildcard confluence*mojave*gz))`)
sha: $(eval datadog_sha := `shasum -a 256 $(firstword $(wildcard datadog*mojave*gz))`)
sha: $(eval gambit_sha := `shasum -a 256 $(firstword $(wildcard gambit*mojave*gz))`)
sha: $(eval gerbil_sha := `shasum -a 256 $(firstword $(wildcard gerbil*mojave*gz))`)
sha: $(eval jira_sha := `shasum -a 256 $(firstword $(wildcard jira*mojave*gz))`)
sha: $(eval slack_sha := `shasum -a 256 $(firstword $(wildcard slack*mojave*gz))`)
sha:
	@gsed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(confluence_sha)\" => :mojave#g" confluence.rb
	@gsed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(datadog_sha)\" => :mojave#g" datadog.rb
	@gsed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(gambit_sha)\" => :mojave#g" gambit-scheme-ssl.rb
	@gsed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(gerbil_sha)\" => :mojave#g" gerbil-scheme-ssl.rb
	@gsed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(jira_sha)\" => :mojave#g" jira.rb
	@gsed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(slack_sha)\" => :mojave#g" slack.rb

gerbil:
	@brew remove -f --ignore-dependencies gerbil-scheme-ssl
	@brew install --build-bottle ./gerbil-scheme-ssl.rb --verbose
	@brew bottle ./gerbil-scheme-ssl.rb --verbose

gambit:
	@brew remove -f --ignore-dependencies gambit-scheme-ssl
	@brew install --build-bottle ./gambit-scheme-ssl.rb --verbose
	@brew bottle ./gambit-scheme-ssl.rb --verbose

system: gambit gerbil
