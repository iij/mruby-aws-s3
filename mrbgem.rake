MRuby::Gem::Specification.new('mruby-aws-s3') do |spec|
  spec.license = 'MIT'
  spec.authors = 'Internet Initiative Japan Inc.'

  spec.add_dependency 'mruby-uv'
  spec.add_dependency 'mruby-http'
  spec.add_dependency 'mruby-digest'
  spec.add_dependency 'mruby-pack'
  spec.add_dependency 'mruby-simplehttp'
  spec.add_dependency 'mruby-httprequest'
end
