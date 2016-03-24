class Document < ActiveRecord::Base
  belongs_to :claim

  mount_uploader :evidence, DocumentUploader
  
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
    Array(coverage_start_date..coverage_end_date)
  end
  
  # Document#fy
  # Returns the financial year in which the document has more days, or the
  # earlier year if equal.
  # Alternative behaviour: pro rated hours when split over two fy's.
  def fy
    if coverage_start_date.fy == coverage_end_date.fy
      coverage_start_date.fy
    else
      # (coverage_start_date..coverage_end_date).to_a.group_by(&:fy) ...
      days_before = (coverage_start_date - coverage_start_date.end_of_fy).to_i.abs
      days_after = (coverage_end_date - coverage_end_date.beginning_of_fy).to_i.abs
      
      days_before < days_after ? coverage_end_date.fy : coverage_start_date.fy
    end
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
