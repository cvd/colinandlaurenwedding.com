require 'spec_helper'

describe Attachment do

  let(:attachment_params) {
    {
     :filename    => "fugu.png",
     :type        => "image/png",
     :name        => "attachment1",
     :file        => file,
     :description => "Awesome Photo",
     :title       => "Title",
     :user_name   => "Colin Van Dyke",
     :user_email  => "vandyke.colin@gmail.com"
    }
  }

  let(:file) {
    img = File.join(File.dirname(__FILE__), "..", "fixtures", "fugu.png")
    @tmpfile = Tempfile.new("email")
    @tmpfile.write File.read(img)
    @tmpfile
  }


  it "takes a hash and stores the values as instance vars" do
    a = Attachment.new(attachment_params)
    a.filename.should == "fugu.png"
    a.content_type.should == "image/png"
    a.file.should == file
    a.user_name.should == "Colin Van Dyke"
    a.user_email.should == "vandyke.colin@gmail.com"
    a.title.should == "Title"
    a.description.should == "Awesome Photo"
  end

  it "creates s3 files" do
    attachment = Attachment.new(attachment_params)
    attachment.stub(:right_image! => true)
    S3Uploader.should_receive(:store_file).with(attachment.file, attachment.filename, attachment.metadata) { stub(:file, :url => "http://s3.amazon.com/colinandlauren/fugu.png")}
    attachment.create_s3_file!
  end

  it "creates Photos" do
    attachment = Attachment.new(attachment_params)
    attachment.stub(:s3_url => "http://url.com/photo", :s3_thumbnail_url => "1234")
    Photo.should_receive(:create).with({
      :title        => "Title",
      :description  => "Awesome Photo",
      :image_url    => "http://url.com/photo",
      :user_email   => "vandyke.colin@gmail.com",
      :user_name    => "Colin Van Dyke",
      :thumbnail_url=> "1234"
    })
    attachment.create_photo!
  end
  
end
