require 'test_helper'

class ExpendituresTableTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  test 'add and delete expenditure' do
    visit('/expenditures')

    # Add new valid expenditure
    click_link('Add new expenditure')
    fill_in('expenditure_amount', with: '52.13')
    fill_in('expenditure_title', with: 'Walmart')
    select('Groceries', from: 'expenditure_category')
    fill_in('expenditure_date', with: Time.zone.today)

    click_button('Create Expenditure')
    wait_for_ajax

    expenditure_id = "expenditure_#{Expenditure.last.id}"
    expenditure = page.find_by_id(expenditure_id).find_css('td')

    assert expenditure[0].visible_text.eql? '$52.13'
    assert expenditure[1].visible_text.eql? 'Walmart'
    assert expenditure[2].visible_text.eql? 'Groceries'
    assert expenditure[3].visible_text.eql? Time.zone.today.strftime

    # Delete added expenditure
    within(:css, "##{expenditure_id}") { click_link('delete') }
    wait_for_ajax
    assert_not page.has_css?("tr#expenditure_#{expenditure_id}")
  end

  test 'add expenditure without amount, title and category' do
    visit('/expenditures')

    click_link('Add new expenditure')
    click_button('Create Expenditure')
    wait_for_ajax

    expenditure_id = "expenditure_#{Expenditure.last.id}"
    expenditure = page.find_by_id(expenditure_id).find_css('td')

    assert expenditure[0].visible_text.eql? '$0.00'
    assert expenditure[1].visible_text.eql? 'Untitled'
    assert expenditure[2].visible_text.eql? 'Uncategorised'
    assert expenditure[3].visible_text.eql? Time.zone.today.strftime
  end

  test 'verify form for new expenditure' do
    visit ('/expenditures')

    click_link('Add new expenditure')

    assert page.has_field?('expenditure_amount', with: /^$/, type: 'number')
    assert page.has_field?('expenditure_title', with: '', type: 'text')
    assert page.has_field?('expenditure_category', with: '', type: 'select')
    assert page.has_field?('expenditure_date', with: Time.zone.today.strftime, type: 'text')
  end

  test 'sort table' do
    visit('/expenditures')

    # sort by amount ascending
    click_link('Amount')

    within(:xpath, "//table/tbody/tr[1]") do
      assert page.has_content?('$1.99')
    end

    # sort by amount descending
    click_link('Amount')

    within(:xpath, "//table/tbody/tr[1]") do
      assert page.has_content?('$30.00')
    end
    # secondary date sort
    within(:xpath, "//table/tbody/tr[2]") do
      assert page.has_content?('$30.00')
      assert page.has_content?('2018-10-21')
    end

    # sort by title (case insensitive)
    click_link('Title')

    within(:xpath, "//table/tbody/tr[2]") do
      assert page.has_content?('a')
    end

    within(:xpath, "//table/tbody/tr[3]") do
      assert page.has_content?('A')
    end
  end

  test 'edit expendtiure' do
    visit('/expenditures')

    within(:xpath, '//*[@id="expenditures_table"]/tbody/tr[1]') do
      click_link('edit')
    end

    wait_for_ajax

    within(:xpath, '//*[@id="modal-window"]/div/div') do
      assert page.has_field?('expenditure_amount', with: '1.99', type: 'number')
      assert page.has_field?('expenditure_title', with: 'Pizza', type: 'text')
      assert page.has_field?('expenditure_category', with: 'Fast Food', type: 'select')
      assert page.has_field?('expenditure_date', with: '2018-10-26', type: 'text')

      fill_in('expenditure_title', with: 'Test title')
      click_button('Update Expenditure')
    end

    wait_for_ajax

    within(:xpath, "//table/tbody/tr[1]") do
      assert page.has_content?('Test title')
    end
  end

  test 'search expenditure' do
    visit('/expenditures')

    assert page.has_field?('search', type: 'text')
    fill_in('search', with: 'Gas')
    click_button('Search')

    wait_for_ajax

    assert page.has_content?(expenditures[0].title)
    assert page.has_content?(expenditures[0].category)
    assert page.has_content?(expenditures[0].amount.to_s)

    assert_not page.has_content?(expenditures[1].title)
    assert_not page.has_content?(expenditures[2].title)
  end
end
