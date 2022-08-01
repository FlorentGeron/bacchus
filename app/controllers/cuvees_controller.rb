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
    @cuvee = create_cuvee_from_params
    if @cuvee.save
      flash[:alert] = "Nouvelle cuvée!"
      redirect_to new_bouteille_path
    else
      flash[:alert] = "Oups! Essayez encore..."
      render 'new'
    end
  end

  def index
    @search_params = {}
    @couleurs = Appellation.all.map(&:couleur).uniq
    @regions = Appellation.all.map(&:region).uniq
    @search_params = search_params if search_params.present?
    @cuvees = filter_cuvees.limit(20)
    @cave = Cave.find_by("caves.nom ILIKE ?", "%#{search_params[:cave]}%") if search_params.present?

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'shared/resultscuvee.html', locals: { cuvees: @cuvees }}
    end
  end

  def show
    @cuvee = Cuvee.includes([:degustations]).find(params[:id])
    @degustations = @cuvee.degustations.uniq
    respond_to do |format|
      format.js
    end
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
    cuvees = Cuvee.includes(:appellation, {:bouteilles => :degustations}, :caves).joins(bouteilles: :cave).where("caves.user_id = ?", current_user.id)
    cuvees = cuvees.joins(:bouteilles).where("bouteilles.statut = ?", "à boire").distinct
    # cuvees = Cave.find_by("nom ILIKE?", "%#{search_params[:cave]}%").bouteilles.map{|bouteille| bouteille.cuvee}.uniq unless search_params[:cave].blank?
    if search_params.present?
      cuvees = cuvees.joins(:appellation).where("appellations.nom ILIKE ? OR cuvees.domaine ILIKE ? OR cuvees.cuvee ILIKE ?", "%#{search_params[:keyword]}%","%#{search_params[:keyword]}%","%#{search_params[:keyword]}%") unless search_params[:keyword].blank?
      cuvees = cuvees.joins(bouteilles: :cave).where("caves.nom LIKE ?", "#{search_params[:cave]}") unless search_params[:cave].blank?
      cuvees = cuvees.joins(:appellation).where("appellations.region LIKE ?", "#{search_params[:region]}") unless search_params[:region].blank?
      cuvees = cuvees.joins(:appellation).where("appellations.couleur LIKE ?", "#{search_params[:couleur]}") unless search_params[:couleur].blank?
    end
    cuvees
  end

  def cuvee_params
    params.require(:cuvee).permit(:appellation, :appellation_id, :domaine, :cuvee, :annee, :date_deg_min, :date_deg_max)
  end

  def create_cuvee_from_params
    Cuvee.new(
      appellation: Appellation.find(cuvee_params[:appellation_id]),
      domaine: cuvee_params[:domaine],
      cuvee: cuvee_params[:cuvee],
      annee: Date.parse("#{cuvee_params['annee(1i)']}-#{cuvee_params['annee(2i)']}-#{cuvee_params['annee(3i)']}"),
      date_deg_min: Date.parse("#{cuvee_params['date_deg_min(1i)']}-#{cuvee_params['date_deg_min(2i)']}-#{cuvee_params['date_deg_min(3i)']}"),
      date_deg_max: Date.parse("#{cuvee_params['date_deg_max(1i)']}-#{cuvee_params['date_deg_max(2i)']}-#{cuvee_params['date_deg_max(3i)']}"),
    )

  end
end
