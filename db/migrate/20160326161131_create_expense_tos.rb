class CreateExpenseTos < ActiveRecord::Migration
  def change
    create_table :expense_tos do |t|
      t.column :user_id, :integer
      t.column :expense_id, :integer
      t.column :amount, :float, default: 0
      t.timestamps null: false
    end
  end
end
