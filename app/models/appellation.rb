class Appellation < ApplicationRecord
  has_many :cuvees

  validates :pays, :region, :couleur, :norme, presence: true
  validates :nom, presence: true, uniqueness: true
end
