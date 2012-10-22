class AddDatafileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :datafile, :string
  end
end
