class Appellation < ApplicationRecord
  has_many :cuvees
  has_many :bouteilles, through: :cuvees
  
  validates :pays, :region, :couleur, :norme, presence: true
  validates :nom, presence: true

  require "open-uri"
  require "nokogiri"
  require "csv"


  def self.scrap(url)
    appelation_list = []
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    csv_file = "lib/assets/appellations.csv"

    html_doc.search("a").each do |element|
      appelation_list << element.text.strip
    end
    CSV.open(csv_file, "wb") do |csv|
        csv << ["nom"]
        csv << appelation_list
    end
  end
end
