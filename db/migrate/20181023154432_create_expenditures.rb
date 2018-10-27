class CreateExpenditures < ActiveRecord::Migration[5.2]
  def change
    create_table :expenditures do |t|
      t.decimal :amount, :precision => 6, :scale => 2
      t.string :title
      t.string :category
      t.date :date

      t.timestamps
    end
  end
end
