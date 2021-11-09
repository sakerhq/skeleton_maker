require_relative 'lib/skeleton_maker/version'

Gem::Specification.new do |spec|
  spec.name          = "skeleton_maker"
  spec.version       = SkeletonMaker::VERSION
  spec.authors       = ["Steven Comyn"]
  spec.email         = ["steven.comyn@saker.io"]

  spec.summary       = "Customized scaffold generator for Saker"
  spec.description   = "Customized scaffold generator for Saker"
  spec.homepage      = "https://github.com/sakerhq/skeleton_maker"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata    = {
    "homepage_uri"      => "https://github.com/sakerhq/skeleton_maker",
    "documentation_uri" => "https://rubydoc.info/github/sakerhq/skeleton_maker",
    "changelog_uri"     => "https://github.com/sakerhq/skeleton_maker/blob/master/CHANGELOG.md",
    "source_code_uri"   => "https://github.com/sakerhq/skeleton_maker",
    "bug_tracker_uri"   => "https://github.com/sakerhq/skeleton_maker/issues",
    "wiki_uri"          => "https://github.com/sakerhq/skeleton_maker/wiki"
  }

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
