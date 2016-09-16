class CreateClaimStages < ActiveRecord::Migration
  def change
    create_table :claim_stages do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    
    reversible do |dir|
      dir.up do
        ClaimStage.create_translation_table! :display_name => :string, :notification_text => :text
      end
      
      dir.down do
        ClaimStage.drop_translation_table!
      end
    end
  end
end
