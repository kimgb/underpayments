class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string      :file
      t.boolean     :wage_evidence
      t.boolean     :time_evidence
      t.date        :coverage_start_date
      t.date        :coverage_end_date
      t.references  :claim, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
