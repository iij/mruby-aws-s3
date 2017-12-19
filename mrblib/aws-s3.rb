module AWS
  class S3
    EMPTY_STRING_SHA256 = Digest::SHA256::hexdigest('')

    def initialize(access_key, secret_key, security_token = nil, region = nil)
      @access_key = access_key || ENV['AWS_ACCESS_KEY_ID']
      @secret_key = secret_key || ENV['AWS_SECRET_ACCESS_KEY']
      @security_token = security_token
      @region = region || ENV["AWS_DEFAULT_REGION"] || 'us-east-1'
      @s3_endpoint = ENV["MRB_AWS_S3_ENDPOINT"] || "https://s3.#{@region}.amazonaws.com"
    end

    def set_bucket(bucket_name)
      @s3_endpoint = @s3_endpoint.sub('//', "//#{bucket_name}.")
      @s3_endpoint = HTTP::Parser.new.parse_url(@s3_endpoint)
      @http = SimpleHttp.new(@s3_endpoint.schema, @s3_endpoint.host, @s3_endpoint.port)
    end

    def download(path)
      headers = {
        'Body' => ''
      }
      calculate_signature('GET', path, headers)
    end

    def upload(path, text)
      headers = {
        'Body' => text
      }
      calculate_signature('PUT', path, headers)
    end

    # private
    def calculate_signature(method, path, headers)
      method = method.upcase
      time = Time.now.utc
      path = "/#{path}" unless path.start_with? '/'

      headers['Host'] = @s3_endpoint.host
      headers['x-amz-content-sha256'] = Digest::SHA256.hexdigest(headers['Body'])
      headers['x-amz-security-token'] = @security_token if @security_token
      headers['Date'] = headers['x-amz-date'] = time.strftime("%Y%m%dT%H%M%SZ")
      if method == 'PUT'
        headers['Content-Length'] = headers['Body'].bytesize
        headers['Content-Encoding'] = 'aws-chunked'
      end
      headers['Accept'] = SimpleHttp::DEFAULT_ACCEPT
      headers['Connection'] = 'keep-alive'

      canon_req = "#{method}\n"
      canon_req += "#{HTTP::URL::encode(path).gsub('%2F', '/')}\n"
      canon_req += "\n" # queries
      header_keys = []
      headers.keys.sort.each do |k|
        next if k == 'Body'
        header_keys.push(k.downcase)
        canon_req += "#{header_keys.last}:#{headers[k].to_s.strip}\n"
      end
      canon_req += "\n#{header_keys.join(";")}"
      canon_req += "\n#{headers['x-amz-content-sha256']}"

      scope = [time.strftime('%Y%m%d'), @region, 's3', 'aws4_request']

      str_to_sign = "AWS4-HMAC-SHA256\n#{headers['x-amz-date']}\n#{scope.join '/'}"
      str_to_sign += "\n#{Digest::SHA256.hexdigest(canon_req)}"

      signing_key = scope.inject("AWS4#{@secret_key}") do |k, v|
        Digest::HMAC.digest(v, k, Digest::SHA256)
      end

      sign = Digest::HMAC.hexdigest(str_to_sign, signing_key, Digest::SHA256)

      headers['Authorization'] = "AWS4-HMAC-SHA256 Credential=#{@access_key}/#{scope.join '/'}"
      headers['Authorization'] += ",SignedHeaders=#{header_keys.join ';'}"
      headers['Authorization'] += ",Signature=#{sign}"

      @http.request method, path, headers
    end
  end
end
