class AddStatementToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :statement, :text
  end
end
