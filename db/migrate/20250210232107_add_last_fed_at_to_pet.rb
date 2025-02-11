class AddLastFedAtToPet < ActiveRecord::Migration[8.0]
  def change
    add_column :pets, :last_fed_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }, max: 100, min: 0
  end
end
