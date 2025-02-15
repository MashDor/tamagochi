class DeathJob < ApplicationJob
  queue_as :default

  def perform(pet)
    pet.death
  end
end

