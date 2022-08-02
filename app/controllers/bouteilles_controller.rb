class BouteillesController < ApplicationController
  before_action :set_bouteille, except: %i[create edit update show]

  def show
    @bouteille = Bouteille.find(params[:id])
  end

  def new
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
    if params[:create].present?
      @number = create_params[:number].to_i
      @number.times do
        @bouteille = create_bouteille_from_params
        @bouteille.cave = Cave.find(bouteille_params[:cave].to_i)
        flash[:alert] = "ça marche pas" unless @bouteille.save
      end
      redirect_to cuvees_path
    else
      @bouteille = create_bouteille_from_params
      @bouteille.wishlist = current_user.wishlists.last
      flash[:alert] = "ça marche pas" unless @bouteille.save
      redirect_to wishlist_path(current_user.wishlists.last)
    end
  end

  def index
    @bouteilles = Bouteille.includes(:cave).joins(:cave).where("statut= 'mise de côté' AND caves.user_id = #{current_user.id}").order(updated_at: :desc)
  end

  def edit
    @bouteille = Bouteille.find(params[:id])
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

  def destroy
    @bouteille = Bouteille.find(params[:id])
    flash[:alert] = "Bouteille supprimée" if @bouteille.destroy
    redirect_to wishlist_path(current_user.wishlists.last)
  end

  def renderbuttons
    @cuveeref = params[:cuveeref]
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'shared/buttonscuvee.html'}
    end
  end

  def addtolist
    @cuveeref = params[:cuveeref]
    @caves = current_user.caves.map { |cave| [cave.nom, cave.id] }
    @partial = params[:save] == 'wishlist' ? 'shared/add_bottle_to_wishlist_form.html' : 'shared/add_bottle_to_cave_form.html'
    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: @partial}
    end
  end

  def quicksave
    @cuveeref = Cuvee.find(params[:format])
    @wishlist = current_user.wishlists.last
    @bouteille = Bouteille.new(
      cuvee: @cuveeref,
      statut: "à boire",
      prix: 0,
      provenance: "à reprendre",
      wishlist: @wishlist
    )
    raise
    if @bouteille.save
      flash[:alert] = "Ajouté à votre wishlist"
    else
      flash[:alert] = "ça ne marche pas"
    end
    redirect_to wishlist_path(@wishlist)
  end

  def metrics
    @bouteilles = Bouteille.includes(:cuvee, { cuvee: :appellation }).joins(:cave).where("caves.user_id = #{current_user.id}")
    @bouteillesaboire= @bouteilles.where("statut= 'à boire'")
    @degustations = Degustation.joins(:bouteille => [{:cuvee => :appellation}, :cave]).where("date_deg > ? AND caves.user_id = ?", Date.new(2022,01,01), current_user.id)
    @bouteillesachat = @bouteilles.joins(:cuvee => :appellation).where("date_achat > ?", Date.new(2021,12,31))
    # Variables data & colors pour pie chart stock par couleur
    @bouteillescouleurs = @bouteillesaboire.joins(:cuvee => :appellation).group(:couleur).count
    @colorscouleurs = define_colors(@bouteillescouleurs, "couleur")
    # Variables data & colors pour pie chart achat par couleur
    @bouteillesachatcouleurs = @bouteillesachat.group(:couleur).count
    @colorsachatcouleurs = define_colors(@bouteillesachatcouleurs, "couleur")
    # Variables data & colors pour pie char degustations par couleur
    @degustationscouleurs = @degustations.group(:couleur).count
    @colorsdegcouleurs = define_colors(@degustationscouleurs, "couleur")
    # Variables data & colors pour pie chart par region
    @bouteillesregions = @bouteillesaboire.joins(:cuvee => :appellation).group(:region).count
    @colorsregions = define_colors(@bouteillesregions, "region")
    # Variables data & colors pour pie chart achat par region
    @bouteillesachatregions = @bouteillesachat.group(:region).count
    @colorsachatregions = define_colors(@bouteillesachatregions, "region")
    # Variables data & colors pour pie char degustations par couleur
    @degustationsregions = @degustations.group(:region).count
    @colorsdegregions = define_colors(@degustationsregions, "region")
    @daily_stock = dailystock
  end

  private

  def set_bouteille
    @bouteille = Bouteille.new
  end

  def bouteille_params
    params.require(:bouteille).permit(:statut, :cuvee, :cave, :emplacement1, :emplacement2, :emplacement3, :date_achat, :prix, :provenance, :wishlist)
  end

  def create_params
    params.require(:create).permit(:number) if params[:create]
  end

  def filter_cuvees
    Cuvee.where("domaine ILIKE ? OR cuvee ILIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%") unless params[:keyword].blank?
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

  def create_bouteille_from_params
    Bouteille.new(
      cuvee: Cuvee.find(bouteille_params[:cuvee].to_i),
      statut: "à boire",
      emplacement1: bouteille_params[:emplacement1],
      emplacement2: bouteille_params[:emplacement2],
      emplacement3: bouteille_params[:emplacement3],
      date_achat: bouteille_params[:date_achat],
      prix: bouteille_params[:prix].to_f,
      provenance: bouteille_params[:provenance]
    )
  end

  def dailystock
    source_for_chart = []
    stock = Bouteille.all.joins(:cave).where("caves.user_id = ?", current_user.id)
    stock.each do |bouteille|
      source_for_chart << [bouteille.date_achat, 1]
    end
    degustations = Degustation.all.joins(:bouteille => :cave).where("caves.user_id = ?", current_user.id)
    degustations.each do |degustation|
      source_for_chart << [degustation.date_deg, -1]
    end
    sum = 0
    source_for_chart.sort_by{|bouteille| bouteille.first}.map{ |x,y| [x, (sum += y)] }
  end
end
