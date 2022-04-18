class Bouteille < ApplicationRecord
  belongs_to :cuvee
  belongs_to :cave
  has_many :degustations

  validates :cuvee_id, :cave_id, :date_achat, :prix, presence: true

  def extract
    self.statut = "à boire"
  end

  def self.daily_stock
    source_for_chart = []
    stock = Bouteille.all
    stock.each do |bouteille|
      source_for_chart << [bouteille.date_achat, 1]
    end
    degustations = Degustation.all
    degustations.each do |degustation|
      source_for_chart << [degustation.date_deg, -1]
    end
    sum =0
    source_for_chart.sort_by{|bouteille| bouteille.first}.map{ |x,y| [x, (sum += y)] }
  end

end
