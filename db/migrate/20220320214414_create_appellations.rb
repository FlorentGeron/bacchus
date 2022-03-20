class CreateAppellations < ActiveRecord::Migration[6.1]
  def change
    create_table :appellations do |t|
      t.string :pays
      t.string :region
      t.string :nom
      t.string :couleur
      t.string :norme

      t.timestamps
    end
  end
end
