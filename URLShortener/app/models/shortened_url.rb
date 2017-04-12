class ShortenedUrl < ActiveRecord::Base
  include SecureRandom

  validates :short_url, uniqueness: true
  validates :long_url, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: "User"

  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: "Visit"

  has_many :visitors,
    #Proc.new { distinct },
    through: :visits,
    source: :user

  def self.random_code
    code = SecureRandom.urlsafe_base64
    while self.exists?(short_url: code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  def self.shorten_url(user, long_url)
    ShortenedUrl.create!(user_id: user.id,
                         long_url: long_url,
                         short_url: self.random_code
                        )
  end

  def num_clicks
    visitors.count
  end

  def num_uniques
    visitors.select(:user_id).distinct.count
  end

  def num_recent_uniques
    visitors.select(:user_id).distinct.where("updated_at < Time.now - 10.minutes").count
  end
end
