class User < ApplicationRecord
  has_many :pets, dependent: :destroy

  def current_pet
    pets.last if pets.last.alive
  end
end
