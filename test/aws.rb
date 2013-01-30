assert('AWS') do
  Object.const_defined?(:AWS) && AWS.const_defined?(:S3)
end
