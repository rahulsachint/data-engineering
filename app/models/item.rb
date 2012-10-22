class Item < ActiveRecord::Base
  attr_accessible :item_description, :item_price, :merchant_address, :merchant_name, :purchase_count, :purchaser_name
end
