class AppellationsController < ApplicationController
  def index
    @appellations = Appellation.all
    @cuvee = Cuvee.new
    if params[:keyword].present?
      @search_params = params[:keyword]
      @appellationscollection = filter_appellations.map { |appellation| [appellation.nom, appellation.id] }
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'shared/appellationforcuvee.html', locals: { appellations: @appellationscollection }}
    end
  end

  private

  def filter_appellations
    Appellation.where("nom ILIKE ?", "%#{params[:keyword]}%") unless params[:keyword].blank?
  end
end
