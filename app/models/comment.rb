class Comment < ActiveRecord::Base
  belongs_to :game
  belongs_to :comment
  belongs_to :user
  validates :author, :body, presence: true
  acts_as_tree order: 'created_at DESC', dependent: :destroy

  scope :last_5_comments, -> { includes(:game).limit(5).order(created_at: :desc) }
end