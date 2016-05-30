class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.column :reason, :string
      t.column :user_id, :integer
      t.column :amount, :float
      t.column :month, :integer
      t.column :year, :integer
      t.timestamps null: false
    end
  end
end
