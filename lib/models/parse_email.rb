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
  def parse_attachments
    @attachments ||= begin
      hash = JSON.parse(@params["attachment-info"])
      hash.map do |file_key, values|
        values = HashWithIndifferentAccess.new(values)
        file_values = HashWithIndifferentAccess.new(@params[file_key])
        puts "parsing attachments"
        next unless file_values.has_key?(:filename)
        next unless valid_file?(file_values[:filename])
        values[:file] = file_values["tempfile"]
        values[:user_name] = from_name
        values[:user_email] = from_email
        values[:title] = title
        values[:description] = description
        values[:old_filename] = values[:filename]
        #puts "Values: #{values.inspect}"
        values[:filename] = gen_filename(values[:filename])
        puts "parsed attachments"
        sleep 5
        Attachment.defer_processing(values)
      end.compact
    end
  end

  def create_files
    #attachments.each do |attachment|
      #puts "Attachment: #{attachment.inspect}"
      #attachment.create_s3_file!
      #attachment.create_s3_thumb!
      #attachment.create_photo!
    #end
  end

  def valid_file?(filename)
    ext = File.extname(filename).downcase
    return false unless ext.in?([".png", ".jpg", ".tiff", ".jpeg"])
    return false if restricted_filenames.any? {|f| filename =~ f }
    return true
  end

  protected

  def restricted_filenames
    [/image001.png/i, /logo/i, /everfii/]
  end


  def gen_filename(filename)
    "#{uuid}#{File.extname(filename).downcase}".gsub("-", "_")
  end

  def uuid
    UUIDTools::UUID.timestamp_create
  end

end

