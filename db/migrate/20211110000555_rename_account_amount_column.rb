class RenameAccountAmountColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :accounts, :amount, :balance
  end
end
