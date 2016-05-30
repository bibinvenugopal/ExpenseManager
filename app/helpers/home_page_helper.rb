module HomePageHelper
  def years
    years = []
    [-1, 0, 1].each do |i|
      year = Date.today.year + i
      years << [year, year]
    end
    years
  end
  
  def months
    months = []
    (1..12).each do |m| 
      months << [Date::MONTHNAMES[m], m]
    end
    months
  end
  
  def all_users
    # User.where('user_type != ?', 4)
    User.all
  end
  
  def all_user_users
    User.where(user_type: 1)
  end
  
  def expense_user
    User.where(user_type: 3).first
  end
  
  def adjustment_user
    User.where(user_type: 2).first
  end
  
  def summary_user
    User.where(user_type: 4).first
  end
  
  def user_name(id)
    User.find(id).name
  end
  
  def my_total_spending(me, month, year)
    me.expenses(month: month, year: year).pluck(:amount).inject(:+).try(:round, 2)
  end
  
  def spend_for_others(me, month, year)
    users = all_user_users_other_than_me(me)
    res = ''
    expense_by_me = Expense.joins('join expense_tos on expenses.id = expense_tos.expense_id').where(month: month, year: year, user_id: me.id)
    users.each do |us|
      res = res << '<br/>'
      amount = expense_by_me.where("expense_tos.user_id = ? ", us.id).pluck('expense_tos.amount').inject(:+).try(:round, 2)
      res << "#{us.name}: #{amount}"
    end
    res
  end
  
  def all_user_users_other_than_me(me)
    all_user_users.where('id != ?', me.id)
  end
  
  def get_common_expense_for(month, year)
    expense_user.expenses.where(month: month, year: year).group(:reason, :expense_to).select('reason, expense_to, sum(amount) as amount')
  end
  
  def get_adjustment_for(month, year)
    adjustment_user.expenses.where(month: month, year: year)
  end
  
  def get_personal_expense_for(month, year)
    expense = {}
    all_user_users.each do |user|
      expense[user] = user.expenses.where(month: month, year: year)
    end
    expense
  end
  
  def spending_for(user, spending)
    spending.where(expense_to: user.id).amount
  end
  
  def exp_for_each_user(expense)
    []
  end
  
  def get_common_expense_reasons_for(month, year)
    Expense.where(month: month, year: year, user: expense_user).select('DISTINCT(reason)')
  end
  
  def find_amount_for_reason(r, month, year)
    amount = []
    all_user_users.each do |usr|
      amount << Expense.where(month: month, year: year, user: expense_user, reason: r, expense_to: usr.id).select('SUM(amount) as amount').first
    end
    amount
  end
  
  def find_total_for_common_expese(month, year)
    amount = []
    all_user_users.each do |usr|
      amount << Expense.where(month: month, year: year, user: expense_user, expense_to: usr.id).select('SUM(amount) as amount').first
    end
    amount
  end 
  
  def get_adjustment_reasons_for(month, year)
    Expense.where(month: month, year: year, user: adjustment_user).select('DISTINCT(reason)')
  end
  
  def find_amount_for_adjustment_reason(r, month, year)
    amount = []
    all_user_users.each do |usr|
      amount << Expense.where(month: month, year: year, user: adjustment_user, reason: r, expense_to: usr.id).select('SUM(amount) as amount').first 
    end
    amount
  end
  
  def find_total_for_adjustment(month, year)
    amount = []
    all_user_users.each do |usr|
      amount << Expense.where(month: month, year: year, user: adjustment_user, expense_to: usr.id).select('SUM(amount) as amount').first
    end
    amount
  end 
  
  def get_common_expenses(month, year)
    expense_user.expenses.where(month: month, year: year)
  end
  
  def get_adjustment_reasons_for(month, year)
    adjustment_user.expenses.where(month: month, year: year)
  end
  
  def spend_by_others(me, month, year)
    users = all_users.where.not(user_type: 4)
    res = ''
    total = 0
    expense_by_others = Expense.joins('join expense_tos on expenses.id = expense_tos.expense_id').where(month: month, year: year).where('expenses.user_id not in (?)', [me.id, summary_user.id])
    users.each do |us|
      res << '<br/>'
      amount = expense_by_others.where("expenses.user_id = ? and expense_tos.user_id = ?", us.id, me.id).pluck('expense_tos.amount').inject(:+).try(:round, 2)
      res << "#{us.name}: #{amount}"
      total += amount.to_f
    end
    res << '<br/>'
    res << "<b>Total: #{total.round(2)}</b>"
    res
  end
  
end
