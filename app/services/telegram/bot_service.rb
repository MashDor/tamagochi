require 'telegram/bot'

module Telegram
  class BotService
    TOKEN = ENV['TELEGRAM_BOT_TOKEN']

    class << self
      attr_accessor :bot

      def listen
        Telegram::Bot::Client.run(TOKEN) do |bot_instance|
          @bot = bot_instance

          @bot.listen do |message|
            UserService.create_or_update_user(message.from.id, message.from.first_name)

            Telegram::CommandHandler.execute(message.chat.id, message.text)
          end
        end
      end

      def send_message(chat_id, text, keyboard = nil)
        return unless @bot

        bot.api.send_message(
          chat_id: chat_id,
          text: text,
          parse_mode: "Markdown",
          reply_markup: keyboard
        )
      end

      def start_keyboard
        base_keyboard(:get_pet)
      end

      def main_keyboard
        base_keyboard(:pet_state, :feed)
      end

      private

      def base_keyboard(*commands)
        buttons = commands.map do |command_name|
          [Telegram::Bot::Types::KeyboardButton.new(text: Telegram::CommandHandler.commands.find(command_name).text)]
        end

        Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons, resize_keyboard: true)
      end
    end
  end
end
