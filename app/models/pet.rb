class Pet < ApplicationRecord
  belongs_to :user

  after_create_commit :schedule_low_satiety_notification
  after_create_commit :schedule_death

  validates :satiety, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  attribute :satiety, :integer, default: 50
  attribute :last_fed_at, :datetime
  attribute :alive, :boolean, default: true

  DECREASE_SATIETY_PER_MINUTE = 1
  SATIETY_FOR_NOTIFICATION = 10

  def current_satiety
    seconds_passed = ((Time.now - last_fed_at)).to_i
    [satiety - seconds_passed * Pet::DECREASE_SATIETY_PER_MINUTE / 60, 0].max
  end

  def feed(increase_satiety = 10)


    update!(satiety: [current_satiety + increase_satiety, 100].min)
    update!(last_fed_at: Time.now)

    schedule_low_satiety_notification()
    schedule_death()
  end

  def schedule_low_satiety_notification
    if current_satiety > Pet::SATIETY_FOR_NOTIFICATION
      minutes_to_notification = ((current_satiety - Pet::SATIETY_FOR_NOTIFICATION).fdiv(Pet::DECREASE_SATIETY_PER_MINUTE)).minute
      LowSatietyNotificationJob.set(wait: minutes_to_notification).perform_later(self.id)
    end
  end

  def low_satiety_notification
    return if current_satiety > Pet::SATIETY_FOR_NOTIFICATION

    Telegram::BotService.send_message(
      user.telegram_id,
      "Питомец проголодался 😞 Сытость #{Pet::SATIETY_FOR_NOTIFICATION}%"
    )
  end

  def schedule_death
    job = DeathJob.set(wait: (current_satiety.fdiv(Pet::DECREASE_SATIETY_PER_MINUTE)).minute).perform_later(self.id)
  end

  def death
    return unless current_satiety.zero?

    update!(alive: false)

    Telegram::BotService.send_message(
      user.telegram_id,
      "😭 К сожалению, ты плохо заботился о своём питомце. И его больше нет 😭\n\nТы готов завести нового питомца?",
      Telegram::BotService.start_keyboard
    )
  end

  def state_message
    "*Состояние питомца*:\n\n🍖 Сытость: #{current_satiety}%"
  end

end
