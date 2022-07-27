class AddWishlistToBouteilles < ActiveRecord::Migration[6.1]
  def change
    add_column :bouteilles, :wishlist_id, :references
  end
end
