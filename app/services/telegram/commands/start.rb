module Telegram
  module Commands
    class Start < Telegram::Commands::Base
      command :start, '/start'

      def execute
        user = User.find_by(telegram_id: chat_id)

        if user.current_pet
          pet = user.current_pet

          send_message(
            "Привет, #{user.name}! Твой пушистик скучал.\n\n#{pet.state_message}",
            Telegram::BotService.main_keyboard
          )
        else
          send_message(
            "Привет, #{user.name}! Готов завести своего питомца?",
            Telegram::BotService.start_keyboard
          )
        end
      end
    end
  end
end
