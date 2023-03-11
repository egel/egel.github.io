# blog-jekyll

Blog in Jekyll that works without template generation with user's default GitHub page.

## install

```bash
rbenv -v
rbenv install --list
rbenv install -v 2.7.7 # this version also works with arm64
rbenv global 2.7.7
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
ruby -v

gem update --system
gem install bundler jekyll
bundle install
```

## development

```bash
npm start
```
