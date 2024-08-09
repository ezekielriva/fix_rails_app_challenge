class AddFedexIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :fedex_id, :string
  end
end
