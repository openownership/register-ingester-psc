# frozen_string_literal: true

require_relative "lib/register_ingester_psc/version"

Gem::Specification.new do |spec|
  spec.name = "register_ingester_psc"
  spec.version = RegisterIngesterPsc::VERSION
  spec.authors = ["Josh Williams"]
  spec.email = ["josh@spacesnottabs.com"]

  spec.summary = "Library for ingesting PSC Records from UK Companies House Snapshots and Stream API."
  spec.description = spec.summary
  spec.homepage = "https://github.com/openownership/register-ingester-psc"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["source_code_uri"] = "https://github.com/openownership/register-ingester-psc"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'countries', '~> 4.0.1'
  spec.add_dependency 'geokit'
  spec.add_dependency 'iso8601'
  spec.add_dependency 'rexml'
  spec.add_dependency 'xxhash'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
