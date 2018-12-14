class AddUserToExpenditure < ActiveRecord::Migration[5.2]
  def change
    add_reference :expenditures, :user, index: true
  end
end
