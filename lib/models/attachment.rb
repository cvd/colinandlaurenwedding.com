class Attachment

  attr_reader :filename, :content_type, :file, :metadata, :user_name,
    :user_email, :description, :title, :s3_url, :old_filename, :extname,
    :thumbnail, :s3_thumbnail_url

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
    right_image!
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
      :title         => title,
      :description   => description,
      :image_url     => s3_url,
      :user_email    => user_email,
      :user_name     => user_name,
      :thumbnail_url => s3_thumbnail_url
    })
  end

  def right_image!
    @file.rewind
    ilist = Magick::ImageList.new
    ilist.from_blob(@file.read)
    ilist.auto_orient!
    @file = Tempfile.new(@filename)
    @file.write(ilist.to_blob)
    @file
  end

  def create_thumbnail!
    @file.rewind
    ilist = Magick::ImageList.new
    ilist.from_blob(@file.read)
    ilist.crop_resized!(75, 75, Magick::NorthGravity)
    f = Tempfile.new("thumbnails-#{@filename}")
    f.write(ilist.to_blob)
    f
  end

  def create_s3_thumb!
    @thumbnail = create_thumbnail!
    puts "Thumbnail: #{@thumbnail.inspect}"
    @s3_thumbnail = S3Uploader.store_file(@thumbnail, "thumbnails/#{@filename}", @metadata)
    if @s3_thumbnail
      @s3_thumbnail_url = @s3_thumbnail.url(:authenticated => false)
    else
      puts "Why didn't you upload?"
    end
  end

  def exif_data
    if jpg?
      f = @file.dup
      f.rewind
      EXIFR::JPEG.new( StringIO.new(f.read) )
    end
  end

  def jpg?
    content_type == "image/jpeg"
  end

end
