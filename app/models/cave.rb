class Cave < ApplicationRecord
  belongs_to :user
  has_many :bouteilles
  has_many :cuvees, through: :bouteilles

  validates :nom, :user_id, presence: true

def bouteillesaboire
  self.bouteilles.where("bouteilles.statut = ?", "mise de côté")
end

end
