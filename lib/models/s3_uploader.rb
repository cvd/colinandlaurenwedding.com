require 'aws/s3'
class S3Uploader

  AWS_KEYS = {
    :access_key_id => ENV['AMAZON_ACCESS_KEY_ID'],
    :secret_access_key => ENV['AMAZON_SECRET_ACCESS_KEY']
  }

  attr_accessor :bucket, :file_basename, :file_name, :file

  # Returns true if bucket_name is suplied
  # and is either created or found
  # params:
  #   bucket_name = String
  # returns:
  #   instance
  def initialize(bucket_name = nil)
     AWS::S3::Base.establish_connection!(AWS_KEYS)
     setup_bucket(bucket_name) if bucket_name
  end

  def find_bucket(name)
    begin
      bucket = AWS::S3::Bucket.find(name)
    rescue AWS::S3::NoSuchBucket => e
      return nil
    end
  end

  def store_file(file, file_name, metadata)
    if @bucket
      @file_name = file_name
      @file_basename = File.basename(@file_name)
      metadata = metadata
      if file
        @file = AWS::S3::S3Object.store(@file_basename, file, @bucket.name, metadata)
        update_bucket!
        true
      else
        false
      end
    end
  end

  def self.store_file(bucket, file, file_name, meta)
    uploader = new(bucket)
    uploader.store_file(file)
  end

  def update_bucket!
    @bucket = find_bucket(@bucket.name)
  end

  private

    def setup_bucket(name)
      @bucket = find_bucket name
    end

end
