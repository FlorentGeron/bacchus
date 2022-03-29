class Cuvee < ApplicationRecord
  belongs_to :appellation
  has_many :bouteilles
  has_many :caves, through: :bouteilles
  has_many :degustations, through: :bouteilles

  validates :appellation_id, :domaine, :cuvee, :annee, :prix_achat, presence: true


def bouteillesaboire
self.bouteilles.where("bouteilles.statut = ?", "mise de côté")
end

end
