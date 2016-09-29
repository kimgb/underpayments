# Letter of demand
# not persisted to database (does not inherit from ActiveRecord).
class Letter < ActiveRecord::Base
  belongs_to :claim
  belongs_to :address
  
  delegate :user, to: :claim, prefix: false, allow_nil: false
  
  validate :forbid_changing_sent_date, on: :update
  
  def write_body!
    update(body: 
      <<-MSG.gsub(/^\s+\|/, "")
        |We write on behalf of National Union of Workers (**the NUW**) member #{ user.proper_full_name }, who formerly worked for #{ claim.employer.name }#{ claim.employer != claim.workplace ? " as a " + claim.employment_type.downcase + " employee, at " + claim.workplace.name : "" }.
        |
        |#{ user.proper_full_name } has advised us that during their employment with #{ claim.employer.name }, they were paid a flat rate of #{ ActionController::Base.helpers.number_to_currency(claim.hourly_pay) } per hour.
        |
        |#{ user.proper_full_name }'s employment was covered by the _#{ claim.award_name }_ (**the Award**). This provides for a person engaged in Award duties to be paid a minimum of #{ ActionController::Base.helpers.number_to_currency(claim.award_minimum("permanent")) } plus a loading of 25% for casual employees. This means that #{ user.proper_full_name } should have been entitled to a minimum hourly rate of #{ ActionController::Base.helpers.number_to_currency(claim.award_minimum) }. This is a clear breach of s. 45 of the _Fair Work Act 2009_ (Cth).
        |
        |The NUW has reviewed evidence provided by #{ user.proper_full_name }, and estimates that during their employment at #{ claim.employer.name }, #{ user.proper_full_name } was underpaid #{ ActionController::Base.helpers.number_to_currency(claim.lost_wages) } on their base rate of pay.
        |
        |The NUW, on behalf of #{ user.proper_full_name }, demands that #{ claim.employer.name } pay the abovementioned base rate amount and any additional monies owed in overtime and penalties to #{ user.proper_full_name }. If this payment is not made within 7 days of receipt of this letter, the NUW will, without further notice, commence proceedings in the Federal Circuit Court in order to recover the amount owed.
      MSG
    )
  end
  
  private
  def forbid_changing_sent_date
    errors[:sent_on] = "can not be changed!" if self.sent_on_changed?
  end
end
