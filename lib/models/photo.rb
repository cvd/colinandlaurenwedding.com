require 'adapter/redis'
require 'toystore'

class NamespacedUUIDKeyFactory < Toy::Identity::AbstractKeyFactory
  def key_type
    String
  end

  def next_key(object)
    [object.class.name, SimpleUUID::UUID.new.to_guid].join(':')
  end
end

class Photo
  include Toy::Store
  store :redis, Redis.new(:db => 3)
  key NamespacedUUIDKeyFactory.new

  attribute :title, String
  attribute :description, String
  attribute :image_url, String
  attribute :thumbnail_url, String
  attribute :user_email, String
  attribute :user_name, String
  timestamps

  index :user_email

  after_save do
    num_photos = store.client.zcard("photos")
    store.client.zadd("photos", num_photos + 1, self.id)
  end

  after_destroy do
    store.client.zrem("photos", self.id)
  end

  def self.page(options)
    per_page = options[:per_page] || 10
    page_num = options[:page] || 1
    start = (page_num - 1) * per_page
    stop = (page_num * per_page) - 1
    keys = store.client.zrange("photos", start, stop)
    self.get_set(keys)
  end

  def self.count
    store.client.zcard("photos")
  end

  def self.all
    self.get_set(self.all_keys)
  end

  def self.get_set(keys)
    keys.map {|k| self.get(k) }
  end

  def self.get_by_index(index)
    keys = store.client.zrange("photos", index, index)
    self.get_set(keys)
  end

  def self.first
    self.get_by_index(0)
  end

  def self.all_keys
    store.client.zrange("photos", 0, -1)
  end

  def self.create(params)
    photo = new(params)
    photo.save
    photo
  end

end
