class RenameDocumentUploaderColumn < ActiveRecord::Migration
  def change
    rename_column :documents, :file, :evidence
  end
end
