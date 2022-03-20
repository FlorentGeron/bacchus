class Bouteille < ApplicationRecord
  belongs_to :cuvee
  belongs_to :cave
  has_many :degustations

  validates :cuvee_id, :cave_id, :date_achat, presence: true
end
