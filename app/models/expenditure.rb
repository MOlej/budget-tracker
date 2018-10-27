class Expenditure < ApplicationRecord
  validates :amount, presence: true
  validates :title, presence: true, length: { maximum: 50 }

  default_scope -> { order(date: :desc) }
end
