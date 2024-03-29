class AddDefaultValueToAmount < ActiveRecord::Migration[6.0]
  def change
    change_column_default :accounts, :amount, 0.00
  end
end
