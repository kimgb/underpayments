class Document < ActiveRecord::Base
  mount_uploader :evidence, DocumentUploader

  belongs_to :claim
  
  scope :hours, -> { where(time_evidence: true) }
  scope :wages, -> { where(wage_evidence: true) }
  
  validate :presence_of_evidence_or_statement
  validate :coverage_start_before_coverage_end

  def owners
    claim ? claim.owners : []
  end

  # document coverage - fill in gaps with fileless documents?
  # calculating gaps - get an array of days of employment and an array of days of documents
  # subtract the unique document days from the employment days, any zones left are gaps
  def days
    Set.new(coverage_start_date..coverage_end_date)
  end
  
  def coverage_midpoint
    diff_bisect = (coverage_end_date - coverage_start_date).to_i / 2
    
    coverage_start_date + diff_bisect
  end
  
  # Document#fy
  # Returns the financial year in which the document has more days, or the
  # earlier year if equal.
  # Alternative behaviour: pro rated hours when split over two fy's.
  def fy
    return coverage_start_date.fy if coverage_start_date.fy == coverage_end_date.fy

    # if we got past the above line, find the dominant financial year
    dominant_fy
  end
  
  def dominant_fy
    days_by_year = (coverage_start_date..coverage_end_date).to_a.group_by(&:fy)
    
    # this should return the earlier year in the event of a tie
    days_by_year.values.max_by(&:size).first.fy
  end
  
  def locked?
    claim && claim.locked?
  end
  
  private
  def presence_of_evidence_or_statement
    unless evidence.present? || statement.present?
      errors.add(:document, "must contain a statement or an uploaded file")
    end
  end
  
  def coverage_start_before_coverage_end
    if coverage_start_date > coverage_end_date
      errors.add(:coverage_start_date, "must be before coverage end date")
    end
  end
end
