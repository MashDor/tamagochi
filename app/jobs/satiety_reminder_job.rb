  class SatietyReminderJob < ApplicationJob
    queue_as :default

    def perform(*args)
      Rails.logger.info "Питомец голоден"
      puts "Питомец голоден"
    end
  end
