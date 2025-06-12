.PHONY: start
start:
	bundle exec jekyll serve --livereload --trace

.PHONY: build
build:
	JEKYLL_ENV=production NODE_ENV=production bundle exec jekyll build

.PHONY: install_mac
install_mac:
	brew install awk
	brew install rbenv
	@printf "\nINFO: Display list of all possible versions"
	rbenv install --list
	@# this version also works with arm64. ruby v3 is not compatible with jelyll v4
	rbenv install -v 3.4.4
	rbenv global 3.4.4
	echo 'eval "$(rbenv init -)"' >> ~/.zshrc
	source ~/.zshrc

	@ech "Updating ruby"
	gem update --system
	gem install bundler
	bundle install

.PHONY: clean
clean:
	rm -rfv ./_site ./.jekyll-cache

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
