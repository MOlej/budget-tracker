class ExpendituresController < ApplicationController
  def index
    @expenditures = Expenditure.all
    @expenditure = Expenditure.new
  end

  def create
    @expenditure = Expenditure.new(user_params)
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
end
