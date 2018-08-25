lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coconductor/version'

Gem::Specification.new do |spec|
  spec.name          = 'coconductor'
  spec.version       = Coconductor::VERSION
  spec.authors       = ['Ben Balter']
  spec.email         = ['ben.balter@github.com']

  spec.summary       = <<-SUMMARY
   work-in-progress code of conduct detector based off Licensee
  SUMMARY
  spec.homepage      = 'https://github.com/benbalter/coconductor'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'licensee', '~> 9.9', '>= 9.9.4'
  spec.add_dependency 'thor', '~> 0.20'
  spec.add_dependency 'toml', '~> 0.2'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.50'
  spec.add_development_dependency 'webmock', '~> 3.1'
end
