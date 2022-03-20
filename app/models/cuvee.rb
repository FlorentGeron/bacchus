class Cuvee < ApplicationRecord
  belongs_to :appellation
  has_many :bouteilles
end
