class ReverseClaimToUserAssociation < ActiveRecord::Migration
  def up
    add_reference :claims, :user, index: true, foreign_key: true
    
    execute <<~SQL
      UPDATE  claims
      SET     user_id = users.id
      FROM    users
      WHERE   users.claim_id = claims.id
      ;
    SQL
    
    remove_reference :users, :claim
  end
  
  def down
    add_reference :users, :claim, index: true, foreign_key: true
    
    # Cannot ensure safe reversal from has_many to the inverse has_one
    # Data safety can't be guaranteed - and data loss is essentially arbitrary
    execute <<~SQL
      UPDATE  users
      SET     claim_id = claims.id
      FROM    claims
      WHERE   claims.user_id = users.id
      ;
    SQL
    
    remove_reference :claims, :user
  end
end
