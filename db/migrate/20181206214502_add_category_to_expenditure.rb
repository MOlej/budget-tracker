class AddCategoryToExpenditure < ActiveRecord::Migration[5.2]
  def change
    remove_column :expenditures, :category
    add_reference :expenditures, :category, foreing_key: true
  end
end
