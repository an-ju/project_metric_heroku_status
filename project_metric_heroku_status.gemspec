
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "project_metric_heroku_status/version"

Gem::Specification.new do |spec|
  spec.name          = "project_metric_heroku_status"
  spec.version       = ProjectMetricHerokuStatus::VERSION
  spec.authors       = ["an-ju"]
  spec.email         = ["an_ju@berkeley.edu"]

  spec.summary       = %q{This metric checks the status of Heroku deployment.}
  spec.description   = %q{An XP team should have an instance that is always accessible.}
  spec.homepage      = "https://github.com/an-ju/project_metric_heroku_status."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ""

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/an-ju/project_metric_heroku_status."
    spec.metadata["changelog_uri"] = "https://github.com/an-ju/project_metric_heroku_status"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency 'faraday'
  spec.add_development_dependency 'webmock'
end
