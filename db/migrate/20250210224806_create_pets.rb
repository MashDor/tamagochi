class CreatePets < ActiveRecord::Migration[8.0]
  def change
    create_table :pets do |t|
      t.integer :satiety, default: 50
      t.datetime :last_fed_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.references :user, null: false,  foreign_key: true
      t.boolean :alive, default: true

      t.timestamps
    end
  end
end
