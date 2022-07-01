class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if user_signed_in?
      homepath = current_user.caves.count.positive? ? cuvees_path : new_cave_path
      redirect_to homepath
    end
  end

  def settings
  end

  def welcome
    @user = current_user
    @bouteilles = Bouteille.includes(:cuvee, { cuvee: :appellation }).joins(:cave).where("statut= 'à boire' AND caves.user_id = #{@user.id}")
    @caves = @user.caves
    @lastdegs = Degustation.joins(:bouteille => [{:cuvee => :appellation}, :cave]).where("date_deg > ? AND caves.user_id = ?", Date.new(2022,01,01), @user.id).order(date_deg: :desc).max(3)
    @lastbuys = Cuvee.joins(:bouteilles).where("date_achat > ?", Date.new(2021,12,31)).distinct.max(3)
  end
end
