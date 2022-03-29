class BouteillesController < ApplicationController

  def index
    @bouteilles = Bouteille.where(statut: 'mise de côté')
  end

  def update
    @bouteille = Bouteille.find_by(params[:bouteille_id])
    @cuvee = @bouteille.cuvee
    if @bouteille.update(bouteille_params)
      flash[:alert] = "Statut mis à jour"
    else
      flash[:alert] = "Oups ! merci de recommencer"
    end
    redirect_to cuvees_path
  end

private

  def bouteille_params
    params.require(:bouteille).permit(:statut)
  end

end
