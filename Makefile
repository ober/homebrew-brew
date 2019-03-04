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
