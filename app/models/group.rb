class Group < ActiveRecord::Base
  extend FriendlyId
  
  mount_uploader :logo, CampaignLogoUploader
  
  friendly_id :name, use: :slugged
  
  store_accessor :skin, 
    :body_bg_color, :body_text_color, :headings_color, :link_color,
    :nav_bg_color, :nav_text_color, :btn_bg_color, :btn_text_color
  
  belongs_to :supergroup
  has_many :users
  has_many :group_awards, inverse_of: :group, dependent: :destroy
  has_many :awards, through: :group_awards
  
  accepts_nested_attributes_for :group_awards, allow_destroy: true
  
  delegate :name, to: :supergroup, prefix: "owner", allow_nil: true
  
  validates_presence_of :name, :supergroup
  
  # To repeat awards - reverse the keys and values. A description is MORE unique
  # and suited for use as a key than an award for our purposes.
  # Then we can have "I don't see my industry here" => "no_award", "Face to face
  # fundraising" => "no_award"
  
  def pay_question_label(period)
    if self.pay_question?
      "#{pay_question} #{period}?"
    else
      I18n.t('claims.form.pay_per_period', period: I18n.t('datetime.prompts.' + period).downcase)
    end
  end
  
  def awards_for_select
    group_awards.map(&:display_text).zip(group_awards.map(&:award_id))
  end

  def pay_periods_for_select
    pay_periods.map(&:capitalize).zip(Array.new(pay_periods.size, "ly")).map(&:join).zip(pay_periods)
  end

  def time_periods_for_select
    time_periods.map(&:capitalize).zip(time_periods)
  end

  def blank_or_singleton?(*attrs)
    attrs.select! { |attr| self.send(attr).blank? || self.send(attr).size == 1 }

    attrs.empty? ? false : attrs
  end

  def singleton_attr(attribute, default)
    self.send(attribute).first || default
  end

  [:awards, :pay_periods, :time_periods].each do |attr|
    define_method("#{attr}_blank_or_singleton?") { blank_or_singleton?(attr) }
  end
  
  def singleton_award
    awards.any? ? awards.first : Award.friendly.find("no_award")
  end

  def singleton_pay_period
    singleton_attr(:pay_periods, "hour")
  end

  def singleton_time_period
    singleton_attr(:time_periods, "week")
  end
end
