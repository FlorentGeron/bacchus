class DegustationsController < ApplicationController
  before_action :set_bouteille

  def new
    @degustation = Degustation.new
  end

  def create
    @degustation = Degustation.new(degustation_params)
    @degustation.bouteille = @bouteille
    if @degustation.save
      @bouteille.statut = "bue"
      @bouteille.save
      flash[:alert] = "Nouvelle degustation! Cette bouteille est considérée 'bue' "
      redirect_to cuvees_path
    else
      render new
    end
  end

  private

  def degustation_params
    params.require(:degustation).permit(:date_deg, :plat, :note_cuvee, :commentaire, :note_accord, :commentaire_accord)
  end

  def set_bouteille
    @bouteille = Bouteille.find(params[:bouteille_id])
  end
end
