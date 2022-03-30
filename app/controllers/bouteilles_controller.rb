class BouteillesController < ApplicationController

  def new
    @bouteille = Bouteille.new
    @cuvees = Cuvee.all.map { |cuvee| ["#{cuvee.domaine} #{cuvee.cuvee} #{cuvee.annee.year}", cuvee.id] }
    @caves = current_user.caves.map { |cave| [cave.nom, cave.id] }
  end

  def create
    @number = create_params[:number].to_i
    @number.times do
      @bouteille = Bouteille.new(
        cuvee: Cuvee.find(bouteille_params[:cuvee].to_i),
        cave: Cave.find(bouteille_params[:cave].to_i),
        statut: "à boire",
        emplacement1: bouteille_params[:emplacement1],
        emplacement2: bouteille_params[:emplacement2],
        emplacement3: bouteille_params[:emplacement3],
        date_achat: bouteille_params[:date_achat]
        prix: bouteille_params[:prix].to_i
      )
      @bouteille.save
    end
    redirect_to cuvees_path
  end

  def index
    @bouteilles = Bouteille.includes(:cave).where(statut: 'mise de côté').order(updated_at: :desc)
  end

  def update
    @bouteille = Bouteille.find(params[:id])
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
    params.require(:bouteille).permit(:statut, :cuvee, :cave, :emplacement1, :emplacement2, :emplacement3, :date_achat, :prix)
  end

  def create_params
    if params[:create]
      params.require(:create).permit(:number)
    end
  end
end
