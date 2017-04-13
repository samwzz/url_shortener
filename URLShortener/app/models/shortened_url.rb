class ShortenedUrl < ActiveRecord::Base
  include SecureRandom

  validates :short_url, uniqueness: true
  validates :long_url, presence: true
  validate :no_spamming
  validate :nonpremium_max

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

  has_many :taggings,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: "Tagging"

    has_many :tag_topics,
      through: :taggings,
      source: :tag_topic

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
    visitors.select(:user_id).distinct.where(updated_at: (Time.now - 10.minutes)..Time.now).count
  end

  private
  def no_spamming
    if self.submitter.submitted_urls.count >= 5
      least_recent = self.submitter.submitted_urls[-5]
      if least_recent.created_at > Time.now - 5.second
        errors[:spam] << "No spamming! Only 5 URL's per minute."
      end
    end
  end

  def nonpremium_max
    unless self.submitter.premium
      if self.submitter.submitted_urls.count >= 5
        errors[:nonpremium] << "Not premium. Max 5 reached."
      end
    end
  end
end
