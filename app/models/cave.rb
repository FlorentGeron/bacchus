class Cave < ApplicationRecord
  belongs_to :user
  has_many :bouteilles

  validates :nom, :user_id, presence: true
end
