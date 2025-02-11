require 'telegram/bot'

class TelegramBotService
  TOKEN = ENV['TELEGRAM_BOT_TOKEN'] # Храним токен в переменных окружения

  def self.listen
    Telegram::Bot::Client.run(TOKEN) do |bot|
      bot.listen do |message|
        puts message
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Привет, #{message.from.first_name}!")
        else
          bot.api.send_message(chat_id: message.chat.id, text: "Не понял команду 🤔")
        end
      end
    end
  end
end
