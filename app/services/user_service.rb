class UserService
  class << self
    def create_or_update_user(telegram_id, name = nil)
      user = User.find_or_initialize_by(telegram_id: telegram_id)
      user.name = name
      user.save
    end
  end
end
