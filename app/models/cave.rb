class Cave < ApplicationRecord
  belongs_to :user
  has_many :bouteilles
end
