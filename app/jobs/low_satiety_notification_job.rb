  class LowSatietyNotificationJob < ApplicationJob
    queue_as :default

    def perform(pet)
      pet.low_satiety_notification
    end
  end

