class CreateCuvees < ActiveRecord::Migration[6.1]
  def change
    create_table :cuvees do |t|
      t.references :appellation, null: false, foreign_key: true
      t.string :domaine
      t.string :cuvee
      t.date :annee
      t.float :average_grade
      t.float :prix_achat
      t.float :prix_actuel
      t.date :date_deg_min
      t.date :date_deg_max

      t.timestamps
    end
  end
end
