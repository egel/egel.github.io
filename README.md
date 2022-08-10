# blog-jekyll
Blog in Jekyll without template generation

## install

```bash
rbenv -v
rbenv install --list
rbenv install -v 2.7.6
rbenv global 2.7.6
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
ruby -v

gem update --system
gem install bundler jekyll
bundle install
```

## development

```bash
bundle exec jekyll serve --livereload
```
