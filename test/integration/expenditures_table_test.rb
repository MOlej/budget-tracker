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

    expenditure_id = "expenditure_#{Expenditure.last.id}"
    expenditure = page.find_by_id(expenditure_id).find_css('td')

    assert expenditure[0].visible_text.eql? '$52.13'
    assert expenditure[1].visible_text.eql? 'Walmart'
    assert expenditure[2].visible_text.eql? 'Groceries'
    assert expenditure[3].visible_text.eql? Time.zone.today.strftime

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

    expenditure_id = "expenditure_#{Expenditure.last.id}"
    expenditure = page.find_by_id(expenditure_id).find_css('td')

    assert expenditure[0].visible_text.eql? '$0.00'
    assert expenditure[1].visible_text.eql? 'Untitled'
    assert expenditure[2].visible_text.eql? 'Uncategorised'
    assert expenditure[3].visible_text.eql? Time.zone.today.strftime
  end

  test 'verify form for new expenditure' do
    visit ('/expenditures')

    assert page.has_field?('expenditure_amount', with: /^$/, type: 'number')
    assert page.has_field?('expenditure_title', with: '', type: 'text')
    assert page.has_field?('expenditure_category', with: '', type: 'select')
    assert page.has_field?('expenditure_date', with: Time.zone.today, type: 'date')
  end

  test 'add new expenditure after sorting' do
    visit('/expenditures')

    assert_difference 'Expenditure.count', 1 do
      click_button('Add')
    end

    # Sort table
    click_link('Amount')

    assert_difference 'Expenditure.count', 1 do
      click_button('Add')
    end

    # Refresh page
    visit(current_path)

    assert_difference 'Expenditure.count', 1 do
      click_button('Add')
    end
  end
end
