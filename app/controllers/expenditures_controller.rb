class ExpendituresController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :set_expenditure, only: %i[edit update destroy]
  before_action :set_categories, only: %i[edit new]
  before_action :authenticate_user!

  def index
    @expenditures = Expenditure
      .users_expenditures(current_user)
      .search(params[:search])
      .order_by(case_insensitive(sort_column), sort_direction)
  end

  def new
    @expenditure = Expenditure.new

    respond_to do |format|
      format.html { render partial: 'form' }
      format.js { render 'form' }
    end
  end

  def create
    @expenditure = Expenditure.new(expenditure_params)
    @expenditure.user_id = current_user.id

    respond_to do |format|
      if @expenditure.save
        format.html { redirect_back(fallback_location: expenditures_path) }
        format.js
      end
    end
  end

  def edit
    respond_to do |format|
      format.html { render partial: 'form' }
      format.js { render 'form' }
    end
  end

  def update
    @expenditure.update(expenditure_params)

    respond_to do |format|
      format.html { redirect_back(fallback_location: expenditures_path) }
      format.js
    end
  end

  def destroy
    respond_to do |format|
      if @expenditure.destroy
        format.html { redirect_back(fallback_location: expenditures_path) }
        format.js
      end
    end
  end

  private

  def expenditure_params
    params.require(:expenditure).permit(:amount, :title, :category_id, :date)
  end

  def set_expenditure
    @expenditure = Expenditure.find(params[:id])
  end

  def set_categories
    @categories = Category.parent_categories
  end

  def sort_column
    return 'categories.name' if params[:column] == 'category_id'
    Expenditure.column_names.include?(params[:column]) ? params[:column] : 'date'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def case_insensitive(column)
    %w[title category].include?(column) ? "lower(#{column})" : column
  end
end
