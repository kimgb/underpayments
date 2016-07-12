class AddPayQuestionToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :pay_question, :string
  end
end
