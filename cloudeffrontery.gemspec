Gem::Specification.new do |spec|
  spec.name        = 'cloudeffrontery'
  spec.version     = '0.1'
  spec.homepage    = 'https://github.com/fiddyspence/cloudeffrontery'
  spec.license     = 'MIT'
  spec.author      = 'Chris Spence'
  spec.email       = 'chris@spence.org.uk'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'bin/*',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.executables << 'cloudeffrontery'
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'cloudeffrontery check'
  spec.description = <<-EOF
    Writes nginx or apache real ip config for amazon cloudfront or azure cloudflare
  EOF

#  spec.add_dependency             'puppet-lint', '>= 1.0', '< 3.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'webmock', '~> 3', '> 3'
end
