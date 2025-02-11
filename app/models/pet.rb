class Pet < ApplicationRecord
  belongs_to :user

  validates :satiety, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  attribute :satiety, :integer, default: 50
  attribute :last_fed_at, :datetime, default: Time.now

  DECREASE_SATIETY_PER_MINUTE = 1
  SATIETY_FOR_REMINDER = 10

  def current_satiety
    minutes_passed = ((Time.now - last_fed_at) / 60).to_i
    [satiety - minutes_passed * DECREASE_SATIETY_PER_MINUTE, 0].max
  end

  def feed(increase_satiety = 10)
    raise ArgumentError, "increase_satiety is not an integer" unless increase_satiety.is_a?(Integer)

    update(satiety: satiety + increase_satiety)
    update(last_fed_at: Time.now)

    SatietyReminderJob.set(wait: ((satiety - SATIETY_FOR_REMINDER) / DECREASE_SATIETY_PER_MINUTE).minute).perform_later
  end

end
