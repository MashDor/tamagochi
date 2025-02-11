class AddLastFedAtToPet < ActiveRecord::Migration[8.0]
  def change
    add_column :pets, :last_fed_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
