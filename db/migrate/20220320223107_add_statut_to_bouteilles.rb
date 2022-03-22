class AddStatutToBouteilles < ActiveRecord::Migration[6.1]
  def change
    add_column :bouteilles, :statut, :string
  end
end
