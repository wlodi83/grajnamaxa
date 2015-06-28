class Game < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  belongs_to :category
  has_many :comments, dependent: :nullify
  acts_as_taggable
  has_attached_file :screen, styles: {normal: '800x600#', medium: '300x300#', thumb: '100x100#'}, default_url: ':style/missing.png'
  scope :published, -> { includes(:category, :rating_average).where(published: true).order(created_at: :desc) }
  scope :new_games, -> { includes(:rating_average).where(published: true).order(updated_at: :desc).limit(5) }
  scope :last_3_games, ->(category) { where(published: true, category_id: category.id).limit(3).order(created_at: :desc).pluck(:title) }
  scope :best_games, -> { joins(:rating_average).where(published: true).order("rating_caches.avg DESC") }
  scope :best_games_all, -> { joins(:category, :rating_average).where(published: true).order("rating_caches.avg DESC") }
  scope :popular_games, -> { joins(:rating_average).where(published: true).order("rating_caches.qty DESC").limit(5) }
  validates :title, :description, :instruction, :screen, presence: true
  validates_attachment_content_type :screen, content_type: /\Aimage\/.*\Z/
  dimension = "rating"
  ratyrate_rateable(*dimension)
  has_one "#{dimension}_average".to_sym, -> { where dimension: dimension.to_s },
                                              :as => :cacheable, :class_name => "RatingCache",
                                              :dependent => :destroy

  def amount_of_comments
    comments.count
  end

  def self.search(search)
    if search
      where("published = ? AND (lower(title) LIKE ? OR lower(description) LIKE ? OR lower(instruction) LIKE ?)", true, "%#{search.downcase}%", "%#{search.downcase}%", "%#{search.downcase}%")
    else
      where(published: true)
    end
  end
end