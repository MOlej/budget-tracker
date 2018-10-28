class Expenditure < ApplicationRecord
# validates :amount, presence: true
# validates :title, presence: true, length: { maximum: 50 }

  default_scope -> { order(date: :desc) }

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
