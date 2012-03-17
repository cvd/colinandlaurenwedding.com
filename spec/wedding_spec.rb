require 'spec_helper'


describe Wedding do
  def app
    @app ||= Wedding
  end
  it "gets the index" do
    get "/"
    last_response.should be_ok
  end
end
