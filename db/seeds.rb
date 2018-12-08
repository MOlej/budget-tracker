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

Category.find_or_create_by(name: "Uncategorised")

# Create parent categories
CATEGORIES.map(&:first).each do |name|
  Category.find_or_create_by(name: name)
end

# Create subcategories
CATEGORIES.map(&:second).each_with_index do |category, parent_id|
  category.each do |name|
    Category.find_or_create_by(name: name, parent_id: parent_id + 2)
  end
end
