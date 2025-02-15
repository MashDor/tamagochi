class UserService
  class << self
    def getUserFromTelegram(telegram_id, name)
      user = User.find_or_initialize_by(telegram_id: telegram_id)
      user.name = name
      user.save

      user
    end
  end
end
