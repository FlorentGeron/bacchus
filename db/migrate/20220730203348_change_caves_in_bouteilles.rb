class ChangeCavesInBouteilles < ActiveRecord::Migration[6.1]
  def change
    change_column_null :bouteilles, :cave_id, true
  end
end
