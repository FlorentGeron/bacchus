class AddWishlistToBouteilles < ActiveRecord::Migration[6.1]
  def change
    add_reference :bouteilles, :wishlist, foreign_key: true
  end
end
