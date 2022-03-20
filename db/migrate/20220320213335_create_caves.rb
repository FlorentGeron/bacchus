class CreateCaves < ActiveRecord::Migration[6.1]
  def change
    create_table :caves do |t|
      t.string :nom
      t.string :localisation
      t.integer :capacité
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
