class Group < ActiveRecord::Base
  extend FriendlyId
  
  mount_uploader :logo, CampaignLogoUploader
  
  friendly_id :name, use: :slugged
  
  store_accessor :skin, 
    :body_bg_color, :body_text_color, :headings_color, :link_color,
    :nav_bg_color, :nav_text_color, :btn_bg_color, :btn_text_color
  
  belongs_to :supergroup
  has_many :users
  
  delegate :name, to: :supergroup, prefix: "owner", allow_nil: true
  
  validates_presence_of :name, :supergroup
  
  def pay_question_label(period)
    if self.pay_question?
      "#{pay_question} #{period}?"
    else
      I18n.t('claims.form.pay_per_period', period: I18n.t('datetime.prompts.' + period).downcase)
    end
  end
  
  def awards_for_select
    awards.to_a.map(&:reverse).map { |str, k| [str, Award.friendly.find(k).id] }
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
    #define_method("singleton_#{attr}") { singleton_attr(attr) }
  end

  def singleton_award
    awards? ? Award.friendly.find(awards.keys.first) : Award.friendly.find("no_award")
    # singleton_attr(:awards, Award.friendly.find("no_award"))
  end

  def singleton_pay_period
    singleton_attr(:pay_periods, "hour")
  end

  def singleton_time_period
    singleton_attr(:time_periods, "week")
  end
end
