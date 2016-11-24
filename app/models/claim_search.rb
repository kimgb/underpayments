# Search dimensions: User#email, all Profile names, Award#name, Company#name,
# CLaimStage#category, ClaimStage#display_text (or system_name?), 
# Claim#point_person
class ClaimSearch
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_reader :claims
  attr_accessor :keywords, :point_person, :include_members, 
    :include_non_members, :supergroup
  
  # Possible params:
  # keywords, members, non_members, point_person, user
  # point person can come back with an id, or a scope of :all or :none
  def initialize(params)
    @keywords = params[:keywords]
    # If receiving checkbox params directly from the form, the value will be "0" or "1"
    @include_members = ["0", false].include?(params[:include_members]) ? false : true
    @include_non_members = ["0", false].include?(params[:include_non_members]) ? false : true
    
    # A ClaimSearch needs a user passed in (see point_people_for_select)
    @user = params[:user]
    @claims = Claim.includes(:documents, :user).all
    @point_person = params[:point_person] || @user.id
    
    filter_by_keywords
    filter_by_point_person
    filter_by_members
  end

  def point_people_for_select
    [['any', 'all'], ['no assigned point person', 'none']] + @user.point_people_for_select
  end

  def persisted?
    false
  end
  
  private
  def filter_by_point_person
    # We need to be able to search for a specific point_person_id, all Claims
    # regardless of point person status, or Claims with no point person assigned
    if @point_person.to_i.nonzero?
      @claims = @claims.where(point_person_id: @point_person)
    elsif @point_person == "none"
      @claims = @claims.where(point_person_id: nil)
    end
  end
  
  # Use the search string for the global PgSearch and map back to a collection
  # of Claims, if provided. Otherwise, our scope is all Claims.
  def filter_by_keywords
    # Eager loading possible with Multisearch as with -
    # @claims = PgSearch.multisearch(@keywords).where(searchable_type: "Claim").includes(:searchable).map(&:searchable)
    if @keywords.present?
      search_docs = PgSearch.multisearch(@keywords)
      # Get the ids - we can load our claims in a single query.
      ids = search_docs.where(searchable_type: "Claim").map(&:searchable_id)

      @claims = @claims.where(id: ids)
    end
  end
  
  def filter_by_members
    # If we're not searching members, exclude them
    @claims = @claims.reject(&:external_id) unless @include_members
    
    # If we're not searching NON-members, exclude them
    @claims = @claims.select(&:external_id) unless @include_non_members
  end
end
