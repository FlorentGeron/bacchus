class DegustationsController < ApplicationController
  def new
    @degustation = Degustation.new
    @bouteille = Bouteille.find(params[:bouteille_id])
  end

  def create
  end

  def edit
  end

  def delete
  end

  def update
  end
end
