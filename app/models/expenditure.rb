class Expenditure < ApplicationRecord
  belongs_to :category

  before_validation :set_defaults

  # default_scope -> { order(date: :desc) }

  def set_defaults
    self.amount ||= 0
    self.title = "Untitled" if self.title.empty?
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
end
