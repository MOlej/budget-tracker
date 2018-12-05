class Expenditure < ApplicationRecord
  before_save :set_defaults

  default_scope -> { order(date: :desc) }

  def set_defaults
      self.amount ||= 0
      self.title = "Untitled" if self.title.empty?
      self.category = "Uncategorised" if self.category.empty?
      self.date ||= Time.zone.today
  end

  CATEGORIES = [
    ['Auto & Transport',
      ['Gas & Fuel', 'Parking', 'Service & Auto Parts', 'Auto Payment', 'Auto Insurance']],
    ['Bills',
      ['Electricity', 'Gas', 'Heating', 'Internet', 'Television', 'Phone', 'Rent', 'Water']],
    ['Entertainment',
      ['Games', 'Events', 'Movies', 'Travel']],
    ['Food & Dining',
      ['Alcohol', 'Coffee shops', 'Fast Food', 'Groceries', 'Restaurant']],
    ['Home',
      ['Accessories and Furnishing', 'Garden', 'Home Insurance', 'Renovation', 'Services']],
    ['Kids',
      ['Activies', 'Allowance', 'Baby Supplies', 'Babysitter & Daycare', 'School Supplies', 'Toys']],
    ['Personal',
      ['Books', 'Clothing', 'Education', 'Electronics & Software', 'Health & Fitness', 'Hobbies', 'Newspapers & Magazines']]
  ]
end
