class CreateDegustations < ActiveRecord::Migration[6.1]
  def change
    create_table :degustations do |t|
      t.references :bouteille, null: false, foreign_key: true
      t.date :date_deg
      t.string :plat
      t.float :note_cuvee
      t.text :commentaire
      t.float :note_accord
      t.text :commentaire_accord

      t.timestamps
    end
  end
end
