class Bouteille < ApplicationRecord
  belongs_to :cuvee
  belongs_to :cave
end
