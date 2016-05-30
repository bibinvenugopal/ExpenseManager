class HomePageController < ApplicationController
  
  def home_page
    @current_page_for = User.find(params[:page]) rescue User.find(1)
    current_user = @current_page_for
    @month = params[:month] || Date.today.month - 1
    @year = params[:year] || Date.today.year
    @expense_to = params[:expense_to].try(:[], :users)
    Expense.save_expense(current_user, @expense_to, params[:amount], params[:reason], @month, @year) unless params[:amount].blank? || @expense_to.nil?
    if @current_page_for.user_type == 4
      @all_spending = Expense.spendings_for(@month, @year)
    else
      @user_spendings = current_user.spendings_for(@month, @year)
    end
  end
  
  def remove
    Expense.find(params[:id]).destroy
    redirect_to controller: :home_page, action: :home_page, page: params[:page]
  end
  
end
