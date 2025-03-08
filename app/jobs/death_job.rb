class DeathJob < ApplicationJob
  queue_as :default

  def perform(id)
    Pet.find(id).death
  end
end

