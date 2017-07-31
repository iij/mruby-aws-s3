require 'tempfile'

assert 'minio test' do
  ENV['AWS_ACCESS_KEY_ID'] = 'QIbGXMifKYPanxKW'
  ENV['AWS_SECRET_ACCESS_KEY'] = 'q7VJQ1V0n93J0TQDq7VJQ1V0n93J0TQD'
  ENV['AWS_DEFAULT_REGION'] = 'ap-northeast-1'
  ENV['MRB_AWS_S3_ENDPOINT'] = 'http://localhost:9000'
  `docker rm -f test_minio`
  `docker run -d -p 9000:9000 --name test_minio -e MINIO_ACCESS_KEY=#{ENV['AWS_ACCESS_KEY_ID']} -e MINIO_SECRET_KEY=#{ENV['AWS_SECRET_ACCESS_KEY']} -e MINIO_REGION=#{ENV['AWS_DEFAULT_REGION']} minio/minio server /export`

  sleep 1 # wait for minio to start

  `aws --endpoint-url #{ENV['MRB_AWS_S3_ENDPOINT']} s3 mb s3://test`
  # `aws --endpoint-url #{ENV['MRB_AWS_S3_ENDPOINT']} s3 ls test`
  # `aws --endpoint-url #{ENV['MRB_AWS_S3_ENDPOINT']} s3 ls`

  uploader = "s3 = AWS::S3.new(nil, nil); s3.set_bucket 'test'; print s3.upload '/test.txt', 'test'"
  assert_equal '', `#{cmd 'mruby'} -e "#{uploader}"`

  downloader = "s3 = AWS::S3.new(nil, nil); s3.set_bucket 'test'; print s3.download '/test.txt'"
  assert_equal 'test', `#{cmd 'mruby'} -e "#{downloader}"`

  `docker rm -f test_minio`
end
