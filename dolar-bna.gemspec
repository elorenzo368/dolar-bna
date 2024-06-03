lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "dolar/bna/version"

Gem::Specification.new do |spec|
  spec.name          = "dolar-bna"
  spec.version       = Dolar::Bna::VERSION
  spec.authors       = ["LITECODE"]
  spec.email         = ["lorenzoezequiel30@gmail.com"]

  spec.summary       = %q{Cotizador de USD/ARS}
  spec.description   = %q{Gema para obtener cotización de dolar divisa y dolar billete, obtener variaciones respecto al día anterior y realizar conversiones. Valores obtenidos del sitio web del Banco Nación Argentina}
  spec.homepage      = "https://github.com/elorenzo368/dolar-bna"
  spec.url      = "https://github.com/elorenzo368/dolar-bna"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['lib/**/*.rb']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_development_dependency "factory_bot", "~> 5.0.2", ">= 5.0.2"
  spec.add_development_dependency "shoulda-matchers", "~> 4.0.1", ">= 4.0.1"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
