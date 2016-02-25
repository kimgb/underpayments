class Document < ActiveRecord::Base
  belongs_to :claim

  mount_uploader :file, DocumentUploader
  
  scope :hours, -> { where(time_evidence: true) }
  scope :wages, -> { where(wage_evidence: true) }

  # TODO validations?

  def owner
    claim && claim.owner
  end

  # document coverage - fill in gaps with fileless documents?
  # calculating gaps - get an array of days of employment and an array of days of documents
  # subtract the unique document days from the employment days, any zones left are gaps
  def days
    Array(coverage_start_date..coverage_end_date)
  end
  
  # may need refining
  def fy
    coverage_end_date.fy
  end
end
