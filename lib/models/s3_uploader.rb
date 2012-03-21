class S3Uploader

  def self.store_file(file, file_name, metadata={})
    puts file.inspect
    AWS::S3::Base.establish_connection!(
      :access_key_id => ENV.fetch('AMAZON_ACCESS_KEY_ID'),
      :secret_access_key => ENV.fetch('AMAZON_SECRET_ACCESS_KEY')
    )

    puts file_name
    bucket_name = ENV.fetch('S3_PHOTOS_BUCKET')
    metadata.merge!(:access => :public_read)

    puts "file_name: #{file_name}"
    puts "file: #{file}"
    puts "bucket_name: #{bucket_name}"
    puts "meta: #{metadata}"

    result = AWS::S3::S3Object.store(
      file_name,
      file,
      bucket_name,
      metadata
    )
    puts "RESULT: #{result}"

    @file = AWS::S3::S3Object.find(file_name, bucket_name)
  end

end
