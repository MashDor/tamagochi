if Rails.env.production?
  Thread.new { TelegramBotService.listen }
end
