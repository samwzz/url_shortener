class TagTopic < ActiveRecord::Base
  validates :topic, presence: true

  has_many :taggings,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: "Tagging"

  has_many :shortened_urls,
    through: :taggings,
    source: :shortened_url


  def popular_links
    click_cnt = {}
    shortened_urls.each do |url|
      click_cnt[url] = url.num_clicks
    end
    sorted_clicks = click_cnt.sort_by { |_, v| v }
    n = sorted_clicks.length < 5 ? sorted_clicks.length : 5
    sorted_clicks.drop(sorted_clicks.length - n).reverse
  end
end
