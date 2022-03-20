class Degustation < ApplicationRecord
  belongs_to :bouteille

  validates :bouteille_id, :date_deg, :note_cuvee, presence: true
end
