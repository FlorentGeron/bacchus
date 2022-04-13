class AddProvenanceToBouteilles < ActiveRecord::Migration[6.1]
  def change
    add_column :bouteilles, :provenance, :string
  end
end
