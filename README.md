mruby-aws-s3
============

### To build:

Prerequisites:

* mruby
* mrbgems (mruby-uv, mruby-http, mruby-digest, mruby-pack, mruby-simplehttp, mruby-httprequest)

activate GEMs in *build_config.rb*
    conf.gem :git => 'https://github.com/iij/mruby-aws.git', :branch => 'master'

then, build mruby
    env ENABLE_GEMS=true ruby ./minirake

### To run the tests:

    env ENABLE_GEMS=true ruby ./minirake test


For example,

    AWSAccessKeyId = '(AccessKey for AWS)'
    AWSSecretAccessKey = '(SecretKey for AWS)'
    AWSBucket = "mruby"
    
    aws = AWS::S3.new(AWSAccessKeyId, AWSSecretAccessKey)
    
    aws.set_bucket(AWSBucket)
    
    # PUT /Hellow.txt
    response = aws.upload("/Hello.txt", "Hello! mruby " + Time.now.to_s)
    if response.code.to_i == 200
      puts "Upload: success"
    else
      puts "Error code = " + response.code.to_s
    end
    
    # GET /Hello.txt
    response = aws.download("/Hello.txt")
    if response.code.to_i == 200
      puts "Download: success"
      puts response.body
    else
      puts "Error code = " + response.code.to_s
      puts "Response:"
      puts response.body
    end

# LICENSE
    * See Copyright Notice in mruby.h
