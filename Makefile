.PHONY: slack confluence datadog jira
default: build


build:
	brew tap ober/brew
	brew remove --ignore-dependencies jira datadog confluence || true
	for pkg in datadog jira confluence slack; do \
	    brew install --build-bottle $$pkg \
	    brew bottle $$pkg \
	done
