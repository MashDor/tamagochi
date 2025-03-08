  class LowSatietyNotificationJob < ApplicationJob
    queue_as :default

    def perform(id)
      Pet.find(id).low_satiety_notification
    end
  end

