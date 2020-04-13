# -*- encoding: utf-8 -*-
require File.expand_path("../lib/torihiki/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "torihiki"
  s.version = Torihiki::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Vladimir Smyshlyaev']
  s.email = ['v@vforvova.ru']
  s.homepage = ""
  s.summary = ""
  s.description = ""
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "torihiki"

  s.add_development_dependency "bundler", ">= 1.5.0"
  s.add_development_dependency "rubocop", "~> 0.49.0"
  s.add_development_dependency "rspec", "~> 3.2"
  s.add_development_dependency "pry", "~> 0.13.1"

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
