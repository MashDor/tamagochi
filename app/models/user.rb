class User < ApplicationRecord
  has_many :pets, dependent: :destroy

  def current_pet
    pets.find(&:alive)
  end
end
