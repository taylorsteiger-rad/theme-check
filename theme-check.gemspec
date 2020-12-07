# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "theme_check/version"

Gem::Specification.new do |spec|
  spec.name          = "theme-check"
  spec.version       = ThemeCheck::VERSION
  spec.authors       = ["Marc-André Cournoyer"]
  spec.email         = ["marcandre.cournoyer@shopify.com"]

  spec.summary       = "A Shopify Theme Linter"
  spec.homepage      = "https://github.com/Shopify/theme-check"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    %x{git ls-files -z}.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency('liquid')
  spec.add_dependency('activesupport')
  spec.add_dependency('nokogiri')
end
