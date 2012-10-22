class AddGrossRevenueToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gross_revenue, :decimal
  end
end
