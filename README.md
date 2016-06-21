mruby-aws-s3
============

### To build:

Prerequisites:

* mruby
* mrbgems (mruby-uv, mruby-http, mruby-digest, mruby-pack, mruby-simplehttp, mruby-httprequest)

activate GEMs in *build_config.rb*
    conf.gem :git => 'https://github.com/iij/mruby-aws-s3.git', :branch => 'master'

then, build mruby
    ruby ./minirake

### To run the tests:

    ruby ./minirake test


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

## License

Copyright (c) 2012 Internet Initiative Japan Inc.

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
DEALINGS IN THE SOFTWARE.

