class ChangeExpenditureAmountPrecision < ActiveRecord::Migration[5.2]
  def up
    change_column :expenditures, :amount, :decimal, precision: 8, scale: 2
  end
end
