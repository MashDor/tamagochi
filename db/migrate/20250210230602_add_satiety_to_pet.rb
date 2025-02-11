class AddSatietyToPet < ActiveRecord::Migration[8.0]
  def change
    add_column :pets, :satiety, :integer, default: 50
  end
end
