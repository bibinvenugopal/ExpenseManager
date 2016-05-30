class User < ActiveRecord::Base
  has_many :expenses, dependent: :destroy
  has_many :expense_tos, dependent: :destroy
  
  def spendings_for(month, year)
    expenses.where(month: month, year: year)
  end
  
  def self.user_users
    User.where(user_type: 1)
  end
end
