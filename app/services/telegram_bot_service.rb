require 'telegram/bot'

class TelegramBotService
  TOKEN = ENV['TELEGRAM_BOT_TOKEN'] # Храним токен в переменных окружения
  class << self
    def listen
      Telegram::Bot::Client.run(TOKEN) do |bot|
        bot.listen do |message|
          user = UserService.getUserFromTelegram(message.from.id, message.from.first_name)

          case message.text
          when '/start'
            if user.current_pet
              pet = user.current_pet

              bot.api.send_message(
                chat_id: message.chat.id,
                text: "Привет, #{user.name}! Твой пушистик скучал.\n\n#{pet.state_message}",
                parse_mode: "Markdown",
                reply_markup: main_keyboard
              )
            else
              bot.api.send_message(
                chat_id: message.chat.id,
                text: "Привет, #{user.name}! Готов завести своего питомца?",
                reply_markup: start_keyboard
              )
            end
          when 'Завести питомца 🐶'
            text = ""
            begin
              pet = PetService.create_pet(user)

              text = "Поздравляю! Теперь у тебя есть собственный комочек шерсти и радости🐶\n\n#{pet.state_message}"
            rescue PetAlreadyExistsError => e
              text = "Тебе уже есть о ком заботиться"
            end
            bot.api.send_message(
              chat_id: message.chat.id,
              text: text,
              parse_mode: "Markdown",
              reply_markup: main_keyboard
            )
          when 'Как дела у моего питомца ❓'
            if user.current_pet
              bot.api.send_message(chat_id: message.chat.id, text: user.current_pet.state_message, parse_mode: "Markdown")
            else
              bot.api.send_message(
                chat_id: message.chat.id,
                text: "У тебя ещё нет питомца. Готов найти себе друга?",
                reply_markup: main_keyboard
              )
            end
          when 'Покормить рыбкой 🐟'
            if user.current_pet
              user.current_pet.feed()
              bot.api.send_message(chat_id: message.chat.id, text: "Рыбка доставлена в животик 😋\n\n#{user.current_pet.state_message}", parse_mode: "Markdown")
            else
              bot.api.send_message(
                chat_id: message.chat.id,
                text: "У тебя ещё нет питомца. Готов найти себе друга?",
                reply_markup: main_keyboard
              )
            end
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Не понял команду 🤔 Если хочешь начать нажми /start")
          end
        end
      end
    end

    def start_keyboard
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          [Telegram::Bot::Types::KeyboardButton.new(text: 'Завести питомца 🐶')],
        ],
        resize_keyboard: true,
      )
    end

    def main_keyboard
      Telegram::Bot::Types::ReplyKeyboardMarkup.new(
        keyboard: [
          [Telegram::Bot::Types::KeyboardButton.new(text: 'Как дела у моего питомца ❓')],
          [Telegram::Bot::Types::KeyboardButton.new(text: 'Покормить рыбкой 🐟')],
        ],
        resize_keyboard: true,
      )
    end
  end
end

