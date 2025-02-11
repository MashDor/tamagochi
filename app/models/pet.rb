class Pet < ApplicationRecord
  belongs_to :user

  validates :satiety, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  attribute :satiety, :integer, default: 50
  attribute :last_fed_at, :datetime, default: Time.now

  def current_satiety
    minutes_passed = ((Time.now - last_fed_at) / 60).to_i
    [satiety - minutes_passed, 0].max
  end

  def feed(increase_satiety = 10)
    raise ArgumentError, "increase_satiety is not an integer" unless increase_satiety.is_a?(Integer)

    self.satiety += increase_satiety
    self.last_fed_at = Time.now
  end

end
