# frozen_string_literal: true

require_relative "lib/collection/version"

Gem::Specification.new do |spec|
  spec.name = "collection"
  spec.version = Collection::VERSION
  spec.authors = ["Wailan Tirajoh"]
  spec.email = ["wailantirajoh@gmail.com"]

  spec.summary = "gem for collection"
  spec.description = "Write a longer description or delete this line."
  spec.homepage = "https://github.com/wailantirajoh"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/wailantirajoh"
  spec.metadata["changelog_uri"] = "https://github.com/wailantirajoh"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end