class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :bouteille
end
