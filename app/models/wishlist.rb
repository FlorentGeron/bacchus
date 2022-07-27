class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :bouteilles
end
