class ParseEmail

  def initialize(params)
    @params = params
  end

  def filename
    attachments["attachment1"]["filename"]
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
      #create versions && store files
    end
  end

end

