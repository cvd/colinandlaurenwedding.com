require 'logger'

class Attachment

  @queue = :photos

  attr_reader :filename, :content_type, :file, :metadata, :user_name,
    :user_email, :description, :title, :s3_url, :old_filename, :extname,
    :thumbnail, :s3_thumbnail_url

  def initialize(params)
    params = HashWithIndifferentAccess.new(params)
    @filename = params[:filename]
    @extname = File.extname(params[:filename])
    @content_type = params[:type]
    #Obviously Heroku Specific
    until File.exists? File.join(FILE_DIR, params[:filename])
      sleep 2
    end
    @file = File.open(File.join(FILE_DIR, params[:filename]), 'r')
    puts "About to upload file: #{@file.inspect}"
    puts "About to upload file: #{@filename.inspect}"
    @title = params[:title]
    @description = params[:description]
    @user_name = params[:user_name]
    @user_email = params[:user_email]
    @old_filename = params[:old_filename]
    @metadata = {:content_type => @content_type, :cache_control => "max-age=2592000"}
  end

  def self.perform(params)

    a = new(params)
    a.create_s3_file!
    a.create_s3_thumb!
    a.create_photo!
  end

  def self.defer_processing(params)
    puts "Defering processing: #{params.inspect}"
    file = params.delete('file')
    params.delete(:_file)
    self.save_file_local(params[:filename], file)
    Resque.enqueue(self, params)
  end

  def self.save_file_local(file_name, file)
    #Obviously Heroku Specific
    File.open(File.join(FILE_DIR, file_name), "w") do |f|
      f.puts(file.read)
    end
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
    @thumbnail = Tempfile.new("thumbnails-#{@filename}")
    @thumbnail.write(ilist.to_blob)
    @file.rewind
    @thumbnail.rewind
    @thumbnail
  end

  def create_s3_thumb!
    create_thumbnail!
    @s3_thumbnail = S3Uploader.store_file(@thumbnail, "thumbnails/#{@filename}", @metadata)
    if @s3_thumbnail
      @s3_thumbnail_url = @s3_thumbnail.url(:authenticated => false)
    else
      puts "Why didn't you upload thumbnail?"
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
