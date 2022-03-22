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
  @cuvees = Cuvee.all
end
end

def show
@cuvee = Cuvee.find(params[:id])
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
    cuvees = Cuvee.all
    #cuvees = Cave.find_by("nom ILIKE?", "%#{search_params[:cave]}%").bouteilles.map{|bouteille| bouteille.cuvee}.uniq unless search_params[:cave].blank?
    cuvees = cuvees.joins(:appellation).where("appellations.nom ILIKE ?", "%#{search_params[:keyword]}%") unless search_params[:keyword].blank?
    cuvees = cuvees.joins(:caves).where("caves.nom ILIKE ?", "%#{search_params[:cave]}%").distinct unless search_params[:cave].blank?
    cuvees = cuvees.joins(:appellation).where("region ILIKE ?", "%#{search_params[:region]}%") unless search_params[:region].blank?
    cuvees = cuvees.joins(:appellation).where("couleur ILIKE ?", "%#{search_params[:couleur]}%") unless search_params[:couleur].blank?
    cuvees
  end

end
