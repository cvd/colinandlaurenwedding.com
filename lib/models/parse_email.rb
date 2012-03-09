class ParseEmail

  def initialize(params)
    @params = HashWithIndifferentAccess.new(params)
  end

  def description
    @params[:text].chomp
  end

  def title
    @params[:subject]
  end

  def from_email
    if /(.+)<(.+)>/ =~ @params[:from]
      return $2.strip
    else
      @params[:from]
    end
  end

  def from_name
    if /(.+)<(.+)>/ =~ @params[:from]
      return $1.strip
    else
      return @params[:from].split("@").first
    end
  end

  #{:filename=>"fugu.png", :type=>"image/png", :name=>"attachment1", :tempfile=>"file", :head=>"Content-Disposition: form-data; name=\"attachment1\"; filename=\"fugu.png\"\nContent-Type: image/png\n", "tempfile"=>nil}
  def attachments
    hash = JSON.parse(@params["attachment-info"])
    hash.map do |file_key, values|
      values[:file] = @params[file_key]
      HashWithIndifferentAccess.new(values)
    end
  end

  def attachment_keys
    attachments.keys
  end

  def create_files
    attachments.each do |attachment|
      metadata = {
        :content_type => attachment[:type],
        :cache_control => "max-age=2592000"
      }
      S3Uploader.store_file("colinandlauren", attachment.tempfile, file_name, metadata)
      photo = Photo.create({
        :title => title,
        :description => description,
        :image_url => s3_image.url,
        :user_email => from_email,
        :user_name => from_name
      })

    end
  end

  protected

  def file_name
    "#{uuid}.#{File.extname(attachment[:filename])}"
  end

  def uuid
    UUIDTools::UUID.timestamp_create
  end

end

