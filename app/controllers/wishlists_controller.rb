class WishlistsController < ApplicationController

  def new
    @wishlist = Wishlist.new
  end

  def create
    @wishlist = Wishlist.new(wishlist_params)
    @wishlist.user = current_user
    if @wishlist.save
      flash[:alert] = "Whishlist créée!"
      redirect_to wishlist_path(@wishlist)
    else
      flash[:alert] = "Merci de revoir les informations"
      render new
    end
  end
  end

  def show
    @wishlist = Wishlist.find(params[:id])
  end

  private

  def wishlist_params
    params.require(:wishlist).permit(:name)
  end

end
