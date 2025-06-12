# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "waypoint"
  spec.version       = "1.0.0"
  spec.authors       = ["Maciej Sypien"]
  spec.email         = ["maciejsypien@gmail.com"]

  spec.summary       =  "A simple, modern and responsive jekyll theme template"
  spec.description   = %q{A simple, modern and responsive jekyll theme template based on type-on-strap, alembic. Great for blogs, easy to customize and responsive.}
  spec.homepage      = "https://github.com/egel/egel.github.io"
  spec.license       = "Apache license 2.0"

  # spec.rdoc_options            = ["--charset=UTF-8"]
  # spec.extra_rdoc_files        = %w(README.md LICENSE)

  spec.metadata["plugin_type"] = "theme"

  spec.files                   = `git ls-files -z`.split("\x0").select do |f|
    f.match(%r{^(assets/(js|css|fonts|data)/|_(includes|layouts|sass)/|_data/language.yml|(LICENSE|README.md))}i)
  end

  spec.post_install_message =  <<~MSG
    Thanks for using Waypoint!
  MSG

  spec.required_ruby_version   = '>= 3.0.0'

  spec.add_runtime_dependency "jekyll", ">= 4.1", "< 5"
  spec.add_runtime_dependency "jekyll-feed", "~> 0.15.1"
  spec.add_runtime_dependency "jekyll-paginate", "~> 1.1"
  spec.add_runtime_dependency "jekyll-seo-tag", "~>2.8.0"
  spec.add_runtime_dependency "jekyll-postcss", "~> 0.5.0"
  spec.add_runtime_dependency "jemoji", "~> 0.12"
end
