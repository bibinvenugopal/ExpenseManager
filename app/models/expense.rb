class Expense < ActiveRecord::Base
  belongs_to :user
  has_many :expense_tos, dependent: :destroy
  
  def self.save_expense(expense_by, expense_to, amount, reason, month, year)
    if expense_to.include?(expense_by.id.to_s)
      amount = amount.to_f - amount.to_f/expense_to.size
      expense_to.delete(expense_by.id.to_s)
    end
    each_amount = amount.to_f/expense_to.size
    if expense_by.user_type == 1
      new_exp = Expense.new(reason: reason, month: month, year: year)
    else
      new_exp  = Expense.find_or_create_by(reason: reason, month: month, year: year)
    end
    new_exp.update_attributes(user: expense_by, reason: reason, amount: amount)
    User.user_users.each do |user|
      new_expense_to = ExpenseTo.find_or_create_by(expense: new_exp, user: user)
      if user == expense_by
        new_expense_to.amount = amount.to_f * -1
      elsif expense_to.include?(user.id.to_s)
        new_expense_to.amount = each_amount.to_f
      end
      new_expense_to.save!
    end
  end
  
  def self.spendings_for(month, year)
    Expense.where(month: month, year: year)
  end
  
  private
  def self.find_expense_by_user_amount(total_amount, expense_to_list, expense_by)
    each_amount = total_amount.to_f/expense_to_list.size
    if expense_to_list.include?(expense_by.id.to_s)
      expense_by_user_amount = (total_amount.to_f - each_amount) * -1
    else
      expense_by_user_amount = total_amount.to_f * -1
    end
    expense_by_user_amount
  end
end
