class AddExpensetoExpense < ActiveRecord::Migration
  def change
    add_column :expenses, :expense_to, :integer
  end
end
