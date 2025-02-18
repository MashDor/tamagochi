class Pet < ApplicationRecord
  belongs_to :user

  after_create_commit :schedule_low_satiety_notification
  after_create_commit :schedule_death

  validates :satiety, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  attribute :satiety, :integer, default: 50
  attribute :last_fed_at, :datetime, default: Time.now
  attribute :alive, :boolean, default: true

  DECREASE_SATIETY_PER_MINUTE = 1
  SATIETY_FOR_REMINDER = 10

  def current_satiety
    minutes_passed = ((Time.now - last_fed_at) / 60).to_i
    [satiety - minutes_passed * DECREASE_SATIETY_PER_MINUTE, 0].max
  end

  def feed(increase_satiety = 10)
    update!(satiety: current_satiety + increase_satiety)
    update!(last_fed_at: Time.now)

    schedule_low_satiety_notification()
    schedule_death()
  end

  def schedule_low_satiety_notification
    if current_satiety > SATIETY_FOR_NOTIFICATION
      job = LowSatietyNotificationJob.set(wait: ((current_satiety - SATIETY_FOR_NOTIFICATION) / DECREASE_SATIETY_PER_MINUTE).minute).perform_later(self)
      p job
    end
  end

  def low_satiety_notification
    return if current_satiety > SATIETY_FOR_NOTIFICATION

    bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
    bot.api.send_message(chat_id: user.telegram_id, text: "Питомец проголодался 😞 Сытость #{current_satiety}%", parse_mode: 'Markdown')
  end

  def schedule_death
    job = DeathJob.set(wait: (current_satiety / DECREASE_SATIETY_PER_MINUTE).minute).perform_later(self)
  end

  def death
    return if current_satiety != 0

    update!(alive: false)

    bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
    bot.api.send_message(chat_id: user.telegram_id, text: "😭 К сожалению, ты плохо заботился о своём питомце. И его больше нет 😭\n\nТы готов завести нового питомца?", parse_mode: 'Markdown', reply_markup: TelegramBotService.start_keyboard)
  end

  def state_message
    "*Состояние питомца*:\n\n🍖 Сытость: #{current_satiety}%"
  end

end
