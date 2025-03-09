class AddJobIdsToPets < ActiveRecord::Migration[8.0]
  def change
    add_column :pets, :low_satiety_notification_job_id, :string
    add_column :pets, :death_job_id, :string
  end
end
