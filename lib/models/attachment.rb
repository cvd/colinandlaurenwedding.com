class Attachment

  attr_reader :filename, :content_type, :file, :metadata, :user_name,
    :user_email, :description, :title, :s3_url, :old_filename, :extname

  def initialize(params)
    @filename = params[:filename]
    @extname = File.extname(params[:filename])
    @content_type = params[:type]
    @file = params[:file]
    @title = params[:title]
    @description = params[:description]
    @user_name = params[:user_name]
    @user_email = params[:user_email]
    @old_filename = params[:old_filename]
    @metadata = {:content_type => @content_type, :cache_control => "max-age=2592000"}
  end

  def create_s3_file!
    @s3_file = S3Uploader.store_file(@file, @filename, @metadata)
    if @s3_file
      @s3_url = @s3_file.url(:authenticated => false)
    else
      puts "Why didn't you upload?"
    end
  end

  def create_photo!
    return false unless s3_url
    photo = Photo.create({
      :title        => title,
      :description  => description,
      :image_url    => s3_url,
      :user_email   => user_email,
      :user_name    => user_name
    })
  end

end
