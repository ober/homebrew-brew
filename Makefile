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

sha: $(eval datadog_sha := `shasum -a 256 $(firstword $(wildcard datadog*mojave*gz))`)
sha: $(eval jira_sha := `shasum -a 256 $(firstword $(wildcard jira*mojave*gz))`)
sha: $(eval confluence_sha := `shasum -a 256 $(firstword $(wildcard confluence*mojave*gz))`)
sha: $(eval slack_sha := `shasum -a 256 $(firstword $(wildcard slack*mojave*gz))`)
sha:
	@sed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(datadog_sha)\" => :mojave#g" datadog.rb
	@sed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(jira_sha)\" => :mojave#g" jira.rb
	@sed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(confluence_sha)\" => :mojave#g" confluence.rb
	@sed -i -e "s#sha256 \"[0-9][a-f].*\"*:mojave#sha256 \"$(slack_sha)\" => :mojave#g" slack.rb
