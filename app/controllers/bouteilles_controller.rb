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
        prix: bouteille_params[:prix].to_f,
        provenance: bouteille_params[:provenance]
      )
      @bouteille.save
    end
    redirect_to cuvees_path
  end

  def index
    @bouteilles = Bouteille.includes(:cave).joins(:cave).where("statut= 'mise de côté' AND caves.user_id = #{current_user.id}").order(updated_at: :desc)
  end

  def edit
    @bouteille = Bouteille.find(params[:id])
    @set_statut = @bouteille.statut == "mise de côté" ? "à boire" : "mise de côté"
    @caves = current_user.caves
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
    @bouteilles = Bouteille.includes(:cuvee, { cuvee: :appellation }).joins(:cave).where("statut= 'à boire' AND caves.user_id = #{current_user.id}")
    @degustations = Degustation.joins(:bouteille => [{:cuvee => :appellation}, :cave]).where("date_deg > ? AND caves.user_id = ?", Date.new(2022,01,01), current_user.id)
    @bouteillesachat = @bouteilles.joins(:cuvee => :appellation).where("date_achat > ?", Date.new(2021,12,31))
    # Variables data & colors pour pie chart stock par couleur
    @bouteillescouleurs = @bouteilles.joins(:cuvee => :appellation).group(:couleur).count
    @colorscouleurs = define_colors(@bouteillescouleurs, "couleur")
    # Variables data & colors pour pie chart achat par couleur
    @bouteillesachatcouleurs = @bouteillesachat.group(:couleur).count
    @colorsachatcouleurs = define_colors(@bouteillesachatcouleurs, "couleur")
    # Variables data & colors pour pie char degustations par couleur
    @degustationscouleurs = @degustations.group(:couleur).count
    @colorsdegcouleurs = define_colors(@degustationscouleurs, "couleur")
    # Variables data & colors pour pie chart par region
    @bouteillesregions = @bouteilles.joins(:cuvee => :appellation).group(:region).count
    @colorsregions = define_colors(@bouteillesregions, "region")
    # Variables data & colors pour pie chart achat par region
    @bouteillesachatregions = @bouteillesachat.group(:region).count
    @colorsachatregions = define_colors(@bouteillesachatregions, "region")
    # Variables data & colors pour pie char degustations par couleur
    @degustationsregions = @degustations.group(:region).count
    @colorsdegregions = define_colors(@degustationsregions, "region")
  end

private

  def bouteille_params
    params.require(:bouteille).permit(:statut, :cuvee, :cave, :emplacement1, :emplacement2, :emplacement3, :date_achat, :prix, :provenance)
  end

  def create_params
      params.require(:create).permit(:number) if params[:create]
  end

  def filter_cuvees
    cuvees = Cuvee.where("domaine ILIKE ? OR cuvee ILIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%") unless params[:keyword].blank?
  end

  def define_colors(data, type)
    result = []
    if type == "couleur"
      data.each { |p, _| result << Appellation::COULEURCOLORS[p.to_sym] }
    else
      data.each { |p, _| result << Appellation::REGIONCOLORS[p.to_sym] }
    end
    result
  end
end
