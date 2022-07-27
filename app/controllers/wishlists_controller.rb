class WishlistsController < ApplicationController

  def new
    @wishlist = Wishlist.new
  end

  def create
  end

  def edit
    @wishlist = Wishlist.find(params[:id])
  end

  def update
  end

  def show
    @wishlist = Wishlist.find(params[:id])
  end

  def destroy
    @wishlist = Wishlist.destroy(params[:id])
  end


end
