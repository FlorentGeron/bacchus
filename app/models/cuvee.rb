class Cuvee < ApplicationRecord
  belongs_to :appellation
  has_many :bouteilles

  validates :appellation_id, :domaine, :cuvee, :annee, :prix_achat, presence: true
end
