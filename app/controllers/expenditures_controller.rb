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

  def create
    @expenditure = Expenditure.new(user_params)
    @expenditure.save

    redirect_back(fallback_location: expenditures_path)
  end

  def destroy
    Expenditure.find(params[:id]).destroy

    redirect_back(fallback_location: expenditures_path)
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
