class CuveesController < ApplicationController

def new
  @appellations = Appellation.all.map { |appellation| ["#{appellation.nom}", appellation.id] }
  if params[:format].present?
    @cuveeref = Cuvee.find(params[:format].to_i)
    @cuvee = Cuvee.new(
      appellation: @cuveeref.appellation,
      domaine: @cuveeref.domaine,
      cuvee: @cuveeref.cuvee
    )
  else
    @cuvee = Cuvee.new
  end
end

def create
  @cuvee = Cuvee.new(
    appellation: Appellation.find(cuvee_params[:appellation_id]),
    domaine: cuvee_params[:domaine],
    cuvee: cuvee_params[:cuvee],
    annee: cuvee_params[:annee],
    date_deg_min: cuvee_params[:date_deg_min],
    date_deg_max: cuvee_params[:date_deg_max]
  )
  if @cuvee.save
    flash[:alert] = "Nouvelle cuvée!"
  redirect_to new_bouteille_path
  else
    flash[:alert] = "Oups! Essayez encore..."
  render 'new'
  raise
  end
end

def index
  @search_params = {}
  @couleurs = Appellation.all.map(&:couleur).uniq
  @regions = Appellation.all.map(&:region).uniq
  if search_params.present?
    @search_params = search_params
    @cuvees = filter_cuvees
    @cave = Cave.find_by("caves.nom ILIKE ?", "%#{search_params[:cave]}%")
    else
    cuvees = Cuvee.includes(:appellation, :bouteilles, :degustations, :caves)
    @cuvees = cuvees.joins(:bouteilles).where("bouteilles.statut = ?", "à boire").distinct
  end
end

def show
  @cuvee = Cuvee.find(params[:id])
  @degustations = @cuvee.degustations.uniq
end



private
def search_params
  if params[:search]
    params.require(:search).permit(
      :cave,
      :region,
      :couleur,
      :keyword
    )
  end
end

def filter_cuvees
  cuvees = Cuvee.includes(:appellation, :bouteilles, :degustations, :caves)
  cuvees = cuvees.joins(:bouteilles).where("bouteilles.statut = ?", "à boire").distinct
  # cuvees = Cave.find_by("nom ILIKE?", "%#{search_params[:cave]}%").bouteilles.map{|bouteille| bouteille.cuvee}.uniq unless search_params[:cave].blank?
  cuvees = cuvees.joins(:appellation).where("appellations.nom ILIKE ?", "%#{search_params[:keyword]}%") unless search_params[:keyword].blank?
  cuvees = cuvees.joins(:caves).where("caves.nom LIKE ?", "#{search_params[:cave]}").distinct unless search_params[:cave].blank?
  cuvees = cuvees.joins(:appellation).where("appellations.region LIKE ?", "#{search_params[:region]}") unless search_params[:region].blank?
  cuvees = cuvees.joins(:appellation).where("appellations.couleur LIKE ?", "#{search_params[:couleur]}") unless search_params[:couleur].blank?
  cuvees
end

def cuvee_params
  params.require(:cuvee).permit(:appellation, :appellation_id, :domaine, :cuvee, :annee, :date_deg_min, :date_deg_max)
end
end
