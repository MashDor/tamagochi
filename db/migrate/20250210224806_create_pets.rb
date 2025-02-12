class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.integer :satiety, :integer, default: 50, max: 100, min: 0
      t.datetime :last_fed_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
      t.references :user, null: false,  foreign_key: true

      t.timestamps
    end
  end
end
