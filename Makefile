.PHONY: start
start:
	bundle exec jekyll serve --livereload --trace

.PHONY: install_mac
install_mac:
	brew install awk
	brew install rbenv
	@printf "\nINFO: Display list of all possible versions"
	rbenv install --list
	@# this version also works with arm64. ruby v3 is not compatible with jelyll v4
	rbenv install -v 2.7.7
	rbenv global 2.7.7
	echo 'eval "$(rbenv init -)"' >> ~/.zshrc
	source ~/.zshrc

	@ech "Updating ruby"
	gem update --system
	gem install bundler -v 2.4.22
	bundle install

.PHONY: list_tags
list_tags:
	@# find all tags in blog files
	find . -name "*.md" -not -path "_drafts" \
		| xargs grep -rnw . -e "tags:" \
		| awk '{$$1=""; print $$0}' \
		| tr -d '[]' \
		| tr ' ' '\n' \
		| tr -d ',' \
		| sort \
		| uniq
