require 'spec_helper'

describe Photo do

  before do
    Photo.store.client.select(5)
  end

  after do
    #clean up all the damn keys
    keys = Photo.store.client.keys
    Photo.store.client.del(*keys)
  end

  it "should persist records" do
    photo = Photo.create(title: "Awesome Photo")
    photo.should be_persisted
  end

  it "should retrieve records" do
    photo = Photo.create(title: "Awesome Photo")
    Photo.get(photo.id).title.should == "Awesome Photo"
  end

  it "should keep its list of keys current" do
    ids = []
    10.times { |i|
      p = Photo.create(title: "Awesome #{i}")
      ids << p.id
    }
    Photo.all_keys.should ==  ids
  end

  it "should remove keys from the index when they are destroyed" do
    ids = []
    photos = []
    10.times { |i|
      p = Photo.create(title: "Awesome #{i}")
      photos << p
      ids << p.id
    }

    photos[5].destroy
    ids.delete(photos[5].id)

    Photo.all_keys.should ==  ids

    photos[3].destroy
    ids.delete(photos[3].id)

    Photo.all_keys.should ==  ids
  end

  it "should index by user_email" do
    Photo.create(title: "Derp Photo", user_email: "derp@colin.com")
    Photo.create(title: "Sweet Photo", user_email: "colin@colin.com")
    keys = Photo.get_index(:user_email, "derp@colin.com")
    Photo.get(keys[0]).title.should == "Derp Photo"
  end
end
