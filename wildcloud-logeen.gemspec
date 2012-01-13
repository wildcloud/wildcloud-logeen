lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'wildcloud/logeen/version'

Gem::Specification.new do |s|
  s.name        = 'wildcloud-logeen'
  s.version     = Wildcloud::Logeen::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Marek Jelen']
  s.email       = ['marek@jelen.biz']
  s.homepage    = 'http://github.com/wildcloud'
  s.summary     = 'Logging proxy'
  s.description = 'Waits for logging messages and forwards them further'
  s.license     = 'Apache2'

  s.required_rubygems_version = '>= 1.3.6'

  s.add_dependency 'amqp', '0.8.4'
  s.add_dependency 'json', '1.6.4'
  s.add_dependency 'snappy', '0.0.3'
  s.add_dependency 'syslog_protocol', '0.9.1'
  s.add_dependency 'wildcloud-logger', '0.0.2'
  s.add_dependency 'wildcloud-configuration', '0.0.1'

  s.files        = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md CHANGELOG.md)
  s.executables = %w(wildcloud-logeen)
  s.require_path = 'lib'
end