require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @category = Category.new(name: 'Sample category')
    @parent_category = Category.where(parent_id: nil).sample
    @subcategory = Category.where.not(parent_id: nil).sample
  end

  test 'should be valid' do
    @category.parent_id = @parent_category.id
    assert @category.valid?
  end

  test 'name should be present' do
    @category.name = nil
    assert_not @category.valid?
  end

  test 'name should be between 2 and 30 characters' do
    ['a', 'a'*31].each do |name|
      @category.name = name
      assert_not @category.valid?
    end
  end

  test 'parent id should be an integer greater than 0' do
    ['a', 0, -1, 0.0].each do |parent_id|
      @category.parent_id = parent_id
      assert_not @category.valid?
    end
  end

  test 'parent category should exist' do
    @category.parent_id = 4213
    assert_not @category.valid?
  end

  test 'parent category should not be a subcategory' do
    @category.parent_id = @subcategory.id
    assert_not @category.valid?
  end
end

