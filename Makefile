.PHONY: spec feature

all:
	@bundle exec rake localtest

feature:
	@bundle exec rake feature

spec:
	@bundle exec rake spec

rubocop:
	@bundle exec rake rubocop

punchlist:
	@bundle exec rake punchlist
