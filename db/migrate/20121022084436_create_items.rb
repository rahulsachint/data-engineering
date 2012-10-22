class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :purchaser_name
      t.string :item_description
      t.decimal :item_price
      t.decimal :purchase_count
      t.string :merchant_address
      t.string :merchant_name

      t.timestamps
    end
  end
end
