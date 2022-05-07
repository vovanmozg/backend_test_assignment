class AddCarsPriceIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :cars, :price
  end
end
