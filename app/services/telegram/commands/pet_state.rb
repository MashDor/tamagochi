module Telegram
  module Commands
    class PetState < Telegram::Commands::Base
      command :pet_state, 'Как дела у моего питомца ❓'

      def execute
        user = User.find_by(telegram_id: chat_id)

        pet = user.current_pet

        if pet
          send_message(pet.state_message, Telegram::BotService.main_keyboard)
        else
          send_message("У тебя ещё нет питомца. Готов найти себе друга?", Telegram::BotService.start_keyboard)
        end
      end
    end
  end
end
