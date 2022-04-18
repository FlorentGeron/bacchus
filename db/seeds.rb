# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"
require "date"

puts "All right, folks! Let's seed!"

puts "destroying all previous records"
Degustation.destroy_all
Bouteille.destroy_all
Cave.destroy_all
User.destroy_all
Cuvee.destroy_all
Appellation.destroy_all

puts "creating 2 users"
me = User.create!(
  email: "master@bacchus.com",
  password: "000000"
)

you = User.create!(
  email: "slave@bacchus.com",
  password:"000000"
)

puts "created #{User.count}  #{'user'.pluralize(User.count)}"

puts "creating 3 caves"
orleans = Cave.create!(
  nom: "Orleans",
  localisation: "Orleans",
  capacité: 200,
  user: me
)

paris = Cave.create!(
  nom: "Paris",
  localisation: "Paris",
  capacité: 180,
  user: me
)

sologne = Cave.create!(
  nom: "Chez Mamie",
  localisation: "Selles Saint Denis",
  capacité: 120,
  user: me
)

puts "created #{Cave.count}  #{'user'.pluralize(Cave.count)}"

puts "creating appellations from csv file"
csv_file = "lib/assets/appellations.csv"
csv_text = File.read(csv_file)
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  t = Appellation.new
  t.pays = row['Pays']
  t.region = row['Région']
  t.nom = row['Nom']
  t.couleur = row['Couleur']
  t.norme = row['Norme']
  t.save!
end

puts "created #{Appellation.count}  #{'appellation'.pluralize(Appellation.count)}"

puts "creating cuvees from csv file"

csv_cuvee = "lib/assets/cuvees.csv"
csv_source = File.read(csv_cuvee)
csv_parsed = CSV.parse(csv_source, :headers => true)
csv_parsed.each do |row|
  c = Cuvee.new
  c.appellation = Appellation.find(row['Appellation'].to_i)
  c.domaine = row['Domaine']
  c.cuvee = row['Cuvée']
  c.annee = DateTime.strptime(row['Année'], '%Y')
  c.date_deg_min = DateTime.strptime(row['date_deg_min'], '%Y')
  c.save!
end

puts "created #{Cuvee.count}  #{'cuvee'.pluralize(Cuvee.count)}"

puts "creating Bouteilles from csv!"

csv_path = "lib/assets/Bouteilles.csv"
csv_read = File.read(csv_path)
csv_parse = CSV.parse(csv_read, :headers => true)
csv_parse.each do |row|
  b = Bouteille.new
  b.cuvee = Cuvee.find(row['Cuvee'].to_i)
  b.cave = Cave.find(row['Cave'].to_i)
  b.emplacement1 = row['Emplacement']
  b.date_achat = Date.parse(row['Ajouté_le'])
  b.statut = row['statut']
  b.provenance = row['Provenance']
  b.prix = row['Prix'].to_f
  b.save!
end

puts "created #{Bouteille.count}  #{'bouteille'.pluralize(Bouteille.count)}"

puts "creating degustations now"

csv_degs = "lib/assets/Degustations.csv"
csv_source_degs = File.read(csv_degs)
csv_parse_degs = CSV.parse(csv_source_degs, :headers => true)
csv_parse_degs.each do |row|
  d = Degustation.new
  d.bouteille = Bouteille.find(row['Bouteille_id'].to_i)
  d.date_deg = Date.parse(row['Date_deg'])
  d.commentaire = row['Commentaire']
  d.note_cuvee = 4
  d.save!
end

puts "created #{Degustation.count}  #{'degustation'.pluralize(Degustation.count)}"

puts "That's all, folks! Happy Programming."
