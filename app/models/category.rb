class Category < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_many :games, dependent: :nullify
  validates :name, :short_name, presence: true
end
