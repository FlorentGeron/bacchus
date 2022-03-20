class CreateBouteilles < ActiveRecord::Migration[6.1]
  def change
    create_table :bouteilles do |t|
      t.references :cuvee, null: false, foreign_key: true
      t.references :cave, null: false, foreign_key: true
      t.string :emplacement1
      t.string :emplacement2
      t.string :emplacement3
      t.date :date_achat

      t.timestamps
    end
  end
end
