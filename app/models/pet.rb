class Pet < ApplicationRecord
  belongs_to :user

  after_create_commit :schedule_low_satiety_notification
  after_create_commit :schedule_death

  validates :satiety, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  attribute :satiety, :integer, default: 50
  attribute :last_fed_at, :datetime
  attribute :alive, :boolean, default: true

  before_update :handle_satiety_changed, if: :satiety_changed?
  before_update :handle_alive_changed, if: :alive_changed?

  DECREASE_SATIETY_PER_MINUTE = 0.17
  SATIETY_FOR_NOTIFICATION = 10
  MAX_SATIETY = 100
  MIN_SATIETY = 0
  INCREASE_SATIETY = 10

  def current_satiety
    seconds_passed = ((Time.now - last_fed_at)).to_i
    [(satiety - seconds_passed * Pet::DECREASE_SATIETY_PER_MINUTE / 60).ceil, Pet::MIN_SATIETY].max
  end

  def feed(increase_satiety = Pet::INCREASE_SATIETY)
    update!(satiety: [current_satiety + increase_satiety, Pet::MAX_SATIETY].min)
  end

  def death
    return unless current_satiety.zero?

    update!(alive: false)
  end

  def low_satiety_notification
    return if current_satiety > Pet::SATIETY_FOR_NOTIFICATION

    Telegram::BotService.send_message(
      user.telegram_id,
      "Питомец проголодался 😞 Сытость #{Pet::SATIETY_FOR_NOTIFICATION}%"
    )
  end

  def death_notification
    return if alive

    Telegram::BotService.send_message(
      user.telegram_id,
      "😭 К сожалению, ты плохо заботился о своём питомце. И его больше нет 😭\n\nТы готов завести нового питомца?",
      Telegram::BotService.start_keyboard
    )
  end

  def schedule_low_satiety_notification
    if current_satiety > Pet::SATIETY_FOR_NOTIFICATION
      minutes_to_notification = ((current_satiety - Pet::SATIETY_FOR_NOTIFICATION).fdiv(Pet::DECREASE_SATIETY_PER_MINUTE)).minute

      JobSchedulerService.schedule(
        job_class: LowSatietyNotificationJob,
        wait_time: minutes_to_notification,
        record: self,
        job_column: :low_satiety_notification_job_id
      )
    end
  end

  def schedule_death
    JobSchedulerService.schedule(
      job_class: DeathJob,
      wait_time: (current_satiety.fdiv(Pet::DECREASE_SATIETY_PER_MINUTE)).minute,
      record: self,
      job_column: :death_job_id
    )
  end

  def state_message
    "*Состояние питомца*:\n\n🍖 Сытость: #{current_satiety}%"
  end

  def handle_satiety_changed
    update_column(:last_fed_at, Time.now)

    schedule_low_satiety_notification
    schedule_death
  end

  def handle_alive_changed
    unless alive
      death_notification
    end
  end

end
