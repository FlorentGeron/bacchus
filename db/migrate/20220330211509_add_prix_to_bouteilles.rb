class AddPrixToBouteilles < ActiveRecord::Migration[6.1]
  def change
    add_column :bouteilles, :prix, :integer
  end
end
