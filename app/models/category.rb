class Category < ApplicationRecord
  belongs_to :parent_category, class_name: 'Category', foreign_key: 'parent_id', optional: true
  belongs_to :user, foreign_key: true, optional: true

  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id'
  has_many :expenditures

  validates :name, presence: true, length: { in: 2..30 }
  validates :parent_id, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validate :parent_category_existence
  validate :category_nesting_level

  def self.parent_categories
    @parent_categories ||= Category.where(parent_id: nil).where.not(name: 'Uncategorised')
  end

  def base_category?
    user_id == nil
  end

  def subcategories
    subcategories
  end

  private

  def parent_category_existence
    if parent_id? && parent_id > 0 && parent_category.nil?
      errors.add(:parent_category, 'should exist')
    end
  end

  def category_nesting_level
    if parent_id? && parent_id > 0 && parent_category.present? && parent_category.parent_id?
      errors.add(:parent_category, 'should not be a subcategory')
    end
  end
end
