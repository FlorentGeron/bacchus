class Appellation < ApplicationRecord
  has_many :cuvees
  has_many :bouteilles, through: :cuvees

  validates :pays, :region, :couleur, :norme, presence: true
  validates :nom, presence: true

  require "open-uri"
  require "nokogiri"
  require "csv"

  REGIONCOLORS = {
    Alsace: '#FAECDD',
    Beaujolais: '#E5044B',
    Bordeaux: '#67103C',
    Bourgogne: '#EA4B7D',
    Champagne: '#DCCCA3',
    Jura: '#E6D61C',
    :'Languedoc-Roussillon' => '#A5D8FF',
    Loire: '#FFB7C3',
    :'Provence-Corse' => '#A77E58',
    Rhône: '#0B7A99',
    :'Savoie Bugey' => '#FFA552',
    :'Sud-Ouest' => '#1CB9E6'
  }

  COULEURCOLORS = {
    Blanc: '#FAECDD',
    :'Blanc Moelleux' => '#FFA552',
    Rouge: '#E5044B',
    Rosé: '#FFB7C3',
    :'Blanc Pétillant' => '#DCCCA3',
    :'Rosé Pétillant' => '#EA4B7D',
    :'Rouge Moelleux' => '#67103C'
  }

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
