require 'telegram/bot'

class TelegramBotService
  TOKEN = ENV['TELEGRAM_BOT_TOKEN'] # Храним токен в переменных окружения

  def self.listen
    Telegram::Bot::Client.run(TOKEN) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          user = User.find_or_initialize_by(telegram_id: message.from.id)
          user.name = message.from.first_name
          user.save

          bot.api.send_message(chat_id: message.chat.id, text: "Привет, #{user.name}!")
        else
          bot.api.send_message(chat_id: message.chat.id, text: "Не понял команду 🤔")
        end
      end
    end
  end
end
