class Expenditure < ApplicationRecord
  scope :users_expenditures, ->(user) { where(user_id: user.id).joins(:category) }

  belongs_to :category
  belongs_to :user

  validates :amount, numericality: { bigger_or_equal_than: 0, lower_than: 100000 }, allow_nil: true
  validates :title, length: { maximum: 50 }, allow_blank: true

  before_validation :set_defaults

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

  private

  def set_defaults
    self.amount ||= 0
    self.title = "Untitled" if title.empty?
    self.category_id ||= "1"
    self.date ||= Time.zone.today
  end
end
