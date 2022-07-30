class Bouteille < ApplicationRecord
  belongs_to :cuvee
  belongs_to :cave, optional: true
  belongs_to :wishlist, optional: true
  has_many :degustations

  validates :cuvee_id, :date_achat, :prix, presence: true

  #validates :cave_id, presence: true, unless: :wishlist_id
  validates :wishlist_id, presence: true, unless: :cave_id

  def extract
    self.statut = "à boire"
  end



end
