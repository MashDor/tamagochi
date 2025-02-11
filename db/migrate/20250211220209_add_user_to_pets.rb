class AddUserToPets < ActiveRecord::Migration[8.0]
  def change
    add_reference :pets, :user, null: false, foreign_key: true
  end
end
