namespace :claims do
  desc "Migrate Claim's legacy award:string column to award:references"
  task migrate_award_column: :environment do
    # class Claim < ActiveRecord::Base
    #   def migrate_award_column!
    #     award = Award.friendly.find(self.award_legacy)
    #     self.award_id = award.id
    #     
    #     if self.save! && award.present?
    #       puts "Award found; claim #{self.id} migrated successfully"
    #     else
    #       puts "Claim migration may have failed", "Check validations and award attribute values for claim id #{self.id}"
    #     end
    #   end
    # end
    
    horticulture = Award.friendly.find("horticulture")
    meat = Award.friendly.find("meat")
    poultry = Award.friendly.find("poultry")
    storage = Award.friendly.find("storage")
    nes = Award.friendly.find("nes")
    
    # claims = Claim.all
    # puts "Migrating #{claims.size} claims"
    ActiveRecord::Base.transaction do
      # claims.each(&:migrate_award_column!)
      hort = Claim.where(award_legacy: "horticulture").update_all(award_id: horticulture.id)
      meat = Claim.where(award_legacy: "meat").update_all(award_id: meat.id)
      plt  = Claim.where(award_legacy: "poultry").update_all(award_id: poultry.id)
      stor = Claim.where(award_legacy: "storage").update_all(award_id: storage.id)
      nes  = Claim.where(award_legacy: "nes").update_all(award_id: nes.id)
    end
    
    puts  "Migrated #{hort} horticulture claims", 
          "Migrated #{meat} meat claims", 
          "Migrated #{plt} poultry claims", 
          "Migrated #{stor} storage services claims", 
          "Migrated #{nes} National Employment Standards claims"
  end
end
