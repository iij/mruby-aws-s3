MRuby::Gem::Specification.new('mruby-aws-s3') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Internet Initiative Japan Inc.'

  spec.add_dependency 'mruby-uv'
  spec.add_dependency 'mruby-uri-parser'
  spec.add_dependency 'mruby-digest'
  spec.add_dependency 'mruby-pack'
  spec.add_dependency 'mruby-simplehttp'
  spec.add_dependency 'mruby-string-ext'
  spec.add_dependency 'mruby-time-strftime'
  spec.add_dependency 'mruby-env'

  spec.add_test_dependency 'mruby-bin-mruby'
end
