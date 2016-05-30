class AdduserTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_type, :integer
  end
end
