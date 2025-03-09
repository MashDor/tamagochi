module Telegram
  module Commands
    class Feed < Telegram::Commands::Base
      command :feed, 'Покормить рыбкой 🐟'

      def execute
        user = User.find_by(telegram_id: chat_id)

        pet = user.current_pet

        if pet
          pet.feed()
          send_message("Рыбка доставлена в животик 😋\n\n#{pet.state_message}", Telegram::BotService.main_keyboard)
        else
          send_message("У тебя ещё нет питомца. Готов найти себе друга?", Telegram::BotService.start_keyboard)
        end
      end
    end
  end
end
