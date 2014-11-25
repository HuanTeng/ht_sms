# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ht_sms/version'

Gem::Specification.new do |spec|
  spec.name          = "ht_sms"
  spec.version       = HtSms::VERSION
  spec.authors       = ["delong"]
  spec.email         = ["w.del@qq.com"]
  spec.summary       = %q{send SMS.}
  spec.description   = %q{use different SMS server send message to user.}
  spec.homepage      = "https://github.com/HuanTeng/ht_sms"
  spec.license       = "GPLv2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
