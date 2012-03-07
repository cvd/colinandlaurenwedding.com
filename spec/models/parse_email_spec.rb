require 'spec_helper'
require_relative "../../lib/models/parse_email"

describe ParseEmail do
  it "should parse email messages"
  it "should pull out each attachment"
  it "should create a new Image record for each iamge attachment"
  it "should use the subject line of the email as a title"
  it "should use the email body as the description"
end
