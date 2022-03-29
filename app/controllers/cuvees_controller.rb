class CuveesController < ApplicationController

def index
@search_params = {}
@couleurs = Appellation.all.map(&:couleur).uniq
@regions = Appellation.all.map(&:region).uniq
if search_params.present?
  @search_params = search_params
  @cuvees = filter_cuvees
  @cave = Cave.find_by("caves.nom ILIKE ?", "%#{search_params[:cave]}%")
  else
  @cuvees = Cuvee.all.joins(:bouteilles).where("bouteilles.statut = ?", "à boire").distinct
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
  cuvees = Cuvee.all.joins(:bouteilles).where("bouteilles.statut = ?", "à boire").distinct
  # cuvees = Cave.find_by("nom ILIKE?", "%#{search_params[:cave]}%").bouteilles.map{|bouteille| bouteille.cuvee}.uniq unless search_params[:cave].blank?
  cuvees = cuvees.joins(:appellation).where("appellations.nom ILIKE ?", "%#{search_params[:keyword]}%") unless search_params[:keyword].blank?
  cuvees = cuvees.joins(:caves).where("caves.nom LIKE ?", "#{search_params[:cave]}").distinct unless search_params[:cave].blank?
  cuvees = cuvees.joins(:appellation).where("region LIKE ?", "#{search_params[:region]}") unless search_params[:region].blank?
  cuvees = cuvees.joins(:appellation).where("couleur LIKE ?", "#{search_params[:couleur]}") unless search_params[:couleur].blank?
  cuvees
  end

end
