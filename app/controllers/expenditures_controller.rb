class ExpendituresController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @expenditures = Expenditure
      .search(params[:search])
      .order(
        Arel.sql("#{case_insensitive(sort_column)} #{sort_direction}"),
        date: :desc,
        created_at: :desc
      )
    @expenditure = Expenditure.new
  end

  def new
    @expenditure = Expenditure.new

    respond_to do |format|
      format.html { render partial: 'form' }
      format.js { render 'form' }
    end
  end

  def create
    @expenditure = Expenditure.new(user_params)

    respond_to do |format|
      if @expenditure.save
        format.html { redirect_back(fallback_location: expenditures_path) }
        format.js
      end
    end
  end

  def edit
    @expenditure = Expenditure.find(params[:id])

    respond_to do |format|
      format.html { render partial: 'form' }
      format.js { render 'form' }
    end
  end

  def update
    @expenditure = Expenditure.find(params[:id])
    @expenditure.update(user_params)

    respond_to do |format|
      format.html { redirect_back(fallback_location: expenditures_path) }
      format.js
    end
  end

  def destroy
    @expenditure = Expenditure.find(params[:id])

    respond_to do |format|
      if @expenditure.destroy
        format.html { redirect_back(fallback_location: expenditures_path) }
        format.js
      end
    end
  end

  private

  def user_params
    params.require(:expenditure).permit(:amount, :title, :category, :date)
  end

  def sort_column
    Expenditure.column_names.include?(params[:column]) ? params[:column] : 'date'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def case_insensitive(column)
    %w[title category].include?(column) ? "lower(#{column})" : column
  end
end
