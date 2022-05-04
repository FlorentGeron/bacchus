class DegustationsController < ApplicationController
  def new
    @degustation = Degustation.new
    @bouteille = Bouteille.find(params[:bouteille_id])
  end

  def create
    @degustation = Degustation.new(degustation_params)
    @bouteille = Bouteille.find(params[:bouteille_id])
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
end
