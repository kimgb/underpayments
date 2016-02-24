class AddHoursAndWagesToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :hours, :decimal
    add_column :documents, :wages, :decimal
  end
end
