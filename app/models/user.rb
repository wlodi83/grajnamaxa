require 'open-uri'
class User < ActiveRecord::Base
  has_merit

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable,
         :omniauthable, :omniauth_providers => [ :facebook, :twitter, :google_oauth2, :nk ],
         :authentication_keys => [ :login ]
         
  ratyrate_rater

  scope :find_username, -> (user_id) { where(id: user_id).first.username }
  scope :recent_users, -> { where.not(confirmed_at: nil).order(confirmed_at: :desc).limit(7) }

  attr_accessor :login

  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>'}, default_url: ':style/missing.png'
  has_many :comments, dependent: :nullify

  validates :username,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 200 },
    presence: true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def amount_of_comments
    comments.count
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.name
      user.password = Devise.friendly_token[0,20]
      case auth.provider
        when "nk"
          user.email = auth.info.email
          user.is_female = auth.extra.raw_info.gender == 'male' ? false : true
          user.date_of_birth = nil
          user.avatar = auth.info.image
        when "facebook"
          user.email = auth.info.email
          user.is_female = auth.extra.raw_info.gender == 'male' ? false : true
          user.date_of_birth = auth.extra.raw_info.birthday.nil? ? nil : Date.strptime(auth.extra.raw_info.birthday, '%m/%d/%Y')
          user.avatar = open(auth.info.image.gsub('http://','https://'))
        when "twitter"
          user.email = auth.info.name + '@twitter.com'
          user.is_female = nil
          user.date_of_birth = nil
          user.avatar = open(auth.info.image.gsub('http://','https://'))
        when "google_oauth2"
          user.email = auth.info.email
          user.is_female = auth.extra.raw_info.gender == 'male' ? false : true
          user.date_of_birth = auth.extra.raw_info.birthday.nil? ? nil : Date.strptime(auth.extra.raw_info.birthday, '%Y-%m-%d')
          user.avatar = open(auth.info.image.gsub('http://','https://'))
      end
      user.skip_confirmation!
      user.save!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.username = data["name"] if user.username.blank?
      elsif data = session["devise.google_data"] && session["devise.google_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.username = data["name"] if user.username.blank?
      elsif data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.username = data["name"] if user.username.blank?
      elsif data = session["devise.nk_data"] && session["devise.nk_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.username = data["name"] if user.username.blank?
      end
    end
  end
end
