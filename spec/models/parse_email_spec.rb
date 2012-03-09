require 'spec_helper'
require 'tempfile'
require_relative "../../lib/models/parse_email"

describe ParseEmail do

  before do
    e = File.join(File.dirname(__FILE__), "..", "fixtures", "email.yaml")
    @params = YAML.load(File.read(e))

    img = File.join(File.dirname(__FILE__), "..", "fixtures", "fugu.png")
    @tmpfile = Tempfile.new("email")
    @tmpfile.write File.read(img)
    @params['attachment1']['tempfile'] = @templfile
  end

  it "should parse email messages" do
    email = ParseEmail.new(@params)
    email.attachments.first[:filename].should == "fugu.png"
  end

  it "should know the name of the sender" do
    email = ParseEmail.new(@params)
    email.from_name.should == "Colin Van Dyke"
  end
  it "should use the email handle if the from has no name" do
    @params["from"] = "vandyke.colin@gmail.com"
    email = ParseEmail.new(@params)
    email.from_name.should == "vandyke.colin"
  end

  it "knows the email address of the sender" do
    email = ParseEmail.new(@params)
    email.from_email.should == "vandyke.colin@gmail.com"
  end

  it "should pull out each attachment"
  it "should create a new Image record for each iamge attachment"
  it "should use the subject line of the email as a title"
  it "should use the email body as the description"
end
