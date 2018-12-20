class CategoriesController < ApplicationController
  def index
    @user_categories = current_user.categories
    @custom_category = Category.new
    @categories = Category.parent_categories
  end

  def create
    @custom_category = Category.new(category_params)
    @custom_category.user_id = current_user.id
    @custom_category.save

    redirect_back(fallback_location: user_categories_path)
  end

  def destroy
    @user_category = Category.find(params[:id])
    @user_category.destroy

    redirect_back(fallback_location: user_categories_path)
  end

  private

  def category_params
    params.require(:category).permit(:parent_id, :name)
  end
end
