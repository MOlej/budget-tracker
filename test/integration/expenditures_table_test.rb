require 'test_helper'

class ExpendituresTableTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  test 'add and delete expenditure' do
    visit ('/expenditures')

    # Add new valid expenditure
    fill_in('expenditure_amount', with: '52.13')
    fill_in('expenditure_title', with: 'Walmart')
    select('Groceries', from: 'expenditure_category')
    fill_in('expenditure_date', with: Time.zone.today)

    assert_difference 'Expenditure.count', 1 do
      click_button('Add')
    end

    expenditure_id = "expenditure_#{Expenditure.first.id}"
    expenditure = page.find_by_id(expenditure_id)

    assert expenditure.has_content?('$52.13')
    assert expenditure.has_content?('Walmart')
    assert expenditure.has_content?('Groceries')
    assert expenditure.has_content?(Time.zone.today)

    # Delete added expenditure
    assert_difference 'Expenditure.count', -1 do
      within(:css, "##{expenditure_id}") { click_link('delete') }
    end
  end

  test 'add expenditure without amount, title and category' do
    visit ('/expenditures')

    assert_difference 'Expenditure.count', 1 do
      click_button('Add')
    end

    expenditure_id = "expenditure_#{Expenditure.first.id}"
    expenditure = page.find_by_id(expenditure_id)

    assert expenditure.has_content?('$0.00')
    assert expenditure.has_content?('Untitled')
    assert expenditure.has_content?('Uncategorised')
    assert expenditure.has_content?(Time.zone.today)
  end

  test 'verify form for new expenditure' do
    visit ('/expenditures')

    assert page.has_field?('expenditure_amount', with: /^$/, type: 'number')
    assert page.has_field?('expenditure_title', with: '', type: 'text')
    assert page.has_field?('expenditure_category', with: '', type: 'select')
    assert page.has_field?('expenditure_date', with: Time.zone.today, type: 'date')
  end
end
