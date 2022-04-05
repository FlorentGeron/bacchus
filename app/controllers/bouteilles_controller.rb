class BouteillesController < ApplicationController

  def new
    @bouteille = Bouteille.new
    if params[:keyword].present?
      @cuveesforsearch = filter_cuvees.map { |cuvee| ["#{cuvee.domaine} #{cuvee.cuvee} #{cuvee.annee.year}", cuvee.id] }
    else
      @cuveesforsearch = [["#{Cuvee.last.domaine} #{Cuvee.last.cuvee} #{Cuvee.last.annee.year}", Cuvee.last.id]]
    end

    @caves = current_user.caves.map { |cave| [cave.nom, cave.id] }

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'shared/formcuvee.html', locals: { cuveesforsearch: @cuveesforsearch } }
    end
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
        date_achat: bouteille_params[:date_achat],
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

  def renderbuttons
    @cuveeref = params[:cuveeref]
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'shared/buttonscuvee.html'}
    end
  end

  def metrics
    @bouteilles = Bouteille.includes(:cuvee, { cuvee: :appellation }).where(statut: 'à boire')
    #@bouteilles.map{}
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

  def filter_cuvees
    cuvees = Cuvee.where("domaine ILIKE ? OR cuvee ILIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%") unless params[:keyword].blank?
  end
end
