class Expenditure < ApplicationRecord
  belongs_to :category
  belongs_to :user

  before_validation :set_defaults

  scope :users_expenditures, ->(user) { where(user_id: user.id).joins(:category) }

  def set_defaults
    self.amount ||= 0
    self.title = "Untitled" if title.empty?
    self.category_id ||= "1"
    self.date ||= Time.zone.today
  end

  def self.search(search)
    if search
      where('amount LIKE :search OR title LIKE :search OR name LIKE :search OR date LIKE :search', search: "%#{search}%")
    else
      all
    end
  end

  def self.order_by(column, direction)
    order(
      Arel.sql("#{column} #{direction}"),
      date: :desc,
      created_at: :desc
    )
  end
end
