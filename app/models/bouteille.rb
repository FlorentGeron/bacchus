class Bouteille < ApplicationRecord
  belongs_to :cuvee
  belongs_to :cave
  has_many :degustations

  validates :cuvee_id, :cave_id, :date_achat, :prix, presence: true

  def extract
    self.statut = "à boire"
  end

  def self.weekly_stock
    source_for_chart = {
      date: [],
      stock: []
    }
    stock = Bouteille.all
    count_achat = 0
    count_degust = 0
    stock.each do |bouteille|
      count_achat = count_achat +1
      source_for_chart[:date] << bouteille.date_achat
      source_for_chart[:stock] << count_achat
    end
    degustations = Degustation.all
    degustations.each do |degustation|
      count_degust = count_degust -1
      source_for_chart[:date] << degustation.date_deg
      source_for_chart[:stock] << count_degust
    end
    source_for_chart
  end

end
