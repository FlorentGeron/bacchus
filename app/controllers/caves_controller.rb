class CavesController < ApplicationController

  def new
    @cave= Cave.new
  end

  def create
    @cave = Cave.new(cave_params)
    @cave.user = current_user
    if @cave.save
      flash[:alert] = "Cave créée!"
      redirect_to root_path
    else
      flash[:alert] = "Merci de revoir les informations"
      render new
    end
  end

  private

  def cave_params
    params.require(:cave).permit(:nom, :localisation, :capacité)
  end

end
