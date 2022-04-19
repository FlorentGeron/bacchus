class Cuvee < ApplicationRecord
  belongs_to :appellation
  has_many :bouteilles
  has_many :caves, through: :bouteilles
  has_many :degustations, through: :bouteilles

  validates :appellation, :domaine, :annee, presence: true


def bouteillesaboire
  self.bouteilles.where("bouteilles.statut = ?", "à boire")
end

def prix_moyen
  teilles = self.bouteilles.map(&:prix)
  teilles.sum / teilles.size
end

end
