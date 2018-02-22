
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yabhrg/version"

Gem::Specification.new do |spec|
  spec.name          = "yabhrg"
  spec.version       = Yabhrg::VERSION
  spec.authors       = ["Jose Galisteo"]
  spec.email         = ["ceritium@gmail.com"]

  spec.summary       = "Yet another bamboohr gem"
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("faraday", [">= 0.7", "< 0.10"])
  spec.add_runtime_dependency("faraday_middleware", [">= 0.8", "< 0.10"])
  spec.add_runtime_dependency("nokogiri")

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "codecov", "~> 0.1"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "guard-rubocop", "~> 1.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.51"
  spec.add_development_dependency "rubocop-rspec", "~> 1.20"
end
