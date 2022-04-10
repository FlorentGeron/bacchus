# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"

puts "All right, folks! Let's seed!"

puts "destroying all previous records"
Degustation.destroy_all
Bouteille.destroy_all
Cave.destroy_all
User.destroy_all
Cuvee.destroy_all
Appellation.destroy_all

puts "creating a user"
me = User.create!(
  email: "master@bacchus.com",
  password: "000000"
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
  c.save!
end

puts "created #{Cuvee.count}  #{'cuvee'.pluralize(Cuvee.count)}"

puts "creating Bouteilles now!"

bouteille1 = Bouteille.create!(
  cave: orleans,
  cuvee: Cuvee.first,
  date_achat: Date.new(2022, 1, 1),
  statut: "à boire",
  prix: 14
)

bouteille2 = Bouteille.create!(
  cave: orleans,
  cuvee: Cuvee.first,
  date_achat: Date.new(2022, 1, 1),
  statut: "à boire",
  prix: 14
)

bouteille3 = Bouteille.create!(
  cave: orleans,
  cuvee: Cuvee.first,
  date_achat: Date.new(2022, 1, 1),
  statut: "à boire",
  prix: 16
)

bouteille4 = Bouteille.create!(
  cave: paris,
  cuvee: Cuvee.first,
  date_achat: Date.new(2022, 1, 1),
  statut: "à boire",
  prix: 18
)

bouteille5 = Bouteille.create!(
  cave: paris,
  cuvee: Cuvee.last,
  date_achat: Date.new(2022, 1, 1),
  statut: "à boire",
  prix: 18
)

bouteille6 = Bouteille.create!(
  cave: paris,
  cuvee: Cuvee.last,
  date_achat: Date.new(2022, 1, 1),
  statut: "à boire",
  prix: 24
)

bouteille7 = Bouteille.create!(
  cave: paris,
  cuvee: Cuvee.last,
  date_achat: Date.new(2022, 1, 1),
  statut: "à boire",
  prix: 32
)

bouteille8 = Bouteille.create!(
  cave: sologne,
  cuvee: Cuvee.first,
  date_achat: Date.new(2022, 1, 1),
  statut: "à boire",
  prix: 48
)


bouteille9 = Bouteille.create!(
  cave: paris,
  cuvee: Cuvee.last,
  date_achat: Date.new(2022, 1, 1),
  statut: "mise de côté",
  prix: 12
)


bouteille10 = Bouteille.create!(
  cave: paris,
  cuvee: Cuvee.last,
  date_achat: Date.new(2022, 1, 1),
  statut: "mise de côté",
  prix: 14
)


bouteille11 = Bouteille.create!(
  cave: orleans,
  cuvee: Cuvee.first,
  date_achat: Date.new(2022, 1, 1),
  statut: "mise de côté",
  prix: 15
)

puts "created #{Bouteille.count}  #{'bouteille'.pluralize(Bouteille.count)}"

puts "creating degustations now"

deg1 = Degustation.create!(
  bouteille: bouteille1,
  date_deg: Date.new(2022, 1, 4),
  note_cuvee: 5,
  commentaire: "Pas trop mal"
)

puts "created #{Degustation.count}  #{'degustation'.pluralize(Degustation.count)}"

puts "That's all, folks! Happy Programming."
