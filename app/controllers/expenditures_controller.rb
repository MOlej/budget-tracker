class ExpendituresController < ApplicationController
  def index
    @expenditures = Expenditure.all
    @expenditure = Expenditure.new
  end

  def create
    @expenditure = Expenditure.new(user_params)
    set_defaults_for_missing_params
    @expenditure.save

    redirect_to expenditures_path
  end

  def destroy
    Expenditure.find(params[:id]).destroy

    redirect_to expenditures_path
  end

  private

    def user_params
      params.require(:expenditure).permit(:amount, :title, :category, :date)
    end

    def set_defaults_for_missing_params
      @expenditure.amount = 0 unless params.values[2][:amount].present?
      @expenditure.title = "Untitled" unless params.values[2][:title].present?
      @expenditure.category = "Uncategorised" unless params.values[2][:category].present?
      @expenditure.date = Time.zone.today unless params.values[2][:date].present?
    end
end
