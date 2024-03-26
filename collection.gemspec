# frozen_string_literal: true

require_relative "lib/array_collection/version"

Gem::Specification.new do |spec|
  spec.name = "array_collection"
  spec.version = ArrayCollection::VERSION
  spec.authors = ["Wailan Tirajoh"]
  spec.email = ["wailantirajoh@gmail.com"]

  spec.summary = "gem for array collection"
  spec.description = "Write a longer description or delete this line."
  spec.homepage = "https://github.com/WailanTirajoh/ruby_collection"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  # spec.metadata["allowed_push_host"] = "Set to your gem server 'https://example.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "https://github.com/WailanTirajoh/ruby_collection"
  spec.metadata["changelog_uri"] = "https://github.com/WailanTirajoh/ruby_collection/CHANGELOG.md"

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
end
