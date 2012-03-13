require 'spec_helper'

describe ParseEmail do

  before do
    ENV["AMAZON_ACCESS_KEY_ID"] = "1234"
    ENV["AMAZON_SECRET_ACCESS_KEY"] = "1234"
    ENV["S3_PHOTOS_BUCKET"] = "colinandlauren"
    e = File.join(File.dirname(__FILE__), "..", "fixtures", "email.yaml")
    @params = YAML.load(File.read(e))

    img = File.join(File.dirname(__FILE__), "..", "fixtures", "fugu.png")
    @tmpfile = Tempfile.new("email")
    @tmpfile.write File.read(img)
    @params['attachment1']['tempfile'] = @tmpfile
  end

  it "parses email messages for attachments" do
    email = ParseEmail.new(@params)
    email.attachments.first.should be_a(Attachment)
    email.attachments.first.file.should_not be_nil
    email.attachments.first.file.should == @tmpfile
  end

  it "knows the name of the sender" do
    email = ParseEmail.new(@params)
    email.from_name.should == "Colin Van Dyke"
    email.attachments.first.user_name.should == "Colin Van Dyke"
  end
  it "should use the email handle if the from has no name" do
    @params["from"] = "vandyke.colin@gmail.com"
    email = ParseEmail.new(@params)
    email.from_name.should == "vandyke.colin"
    email.attachments.first.user_name.should == "vandyke.colin"
  end

  it "knows the email address of the sender" do
    email = ParseEmail.new(@params)
    email.from_email.should == "vandyke.colin@gmail.com"
    email.attachments.first.user_email.should == "vandyke.colin@gmail.com"
  end

  it "should set a filename" do
    email = ParseEmail.new(@params)
    email.attachments.first.filename.should_not be_nil
  end

  it "tells the attachments to upload" do
    email = ParseEmail.new(@params)
    a = email.attachments.first
    a.stub(:create_s3_file! => true, :create_photo! => true, :create_s3_thumb! => true)
    a.should_receive(:create_s3_file!).and_return(true)
    email.create_files
  end

  it "should create a new photo record for each attachment" do
    email = ParseEmail.new(@params)
    a = email.attachments.first
    a.stub(:create_s3_file! => true, :create_photo! => true, :create_s3_thumb! => true)
    a.should_receive(:create_photo!).and_return(true)
    email.create_files
  end

  it "should use the subject line of the email as a title" do
    email = ParseEmail.new(@params)
    email.attachments.first.title.should == "test email"
  end

  it "should use the email body as the description" do
    email = ParseEmail.new(@params)
    email.attachments.first.description.should == "Here is Fugu!"
  end

  it "should reject files that aren't images" do
    @params['attachment1']['filename'] = "awesome.txt"
    email = ParseEmail.new(@params)
    email.attachments.should be_empty
  end
end
