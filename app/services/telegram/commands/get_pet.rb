module Telegram
  module Commands
    class GetPet < Telegram::Commands::Base
      command :get_pet, 'Завести питомца 🐶'

      def execute
        text = ""
        user = User.find_by(telegram_id: chat_id)

        begin
          pet = PetService.create_pet(user)

          text = "Поздравляю! Теперь у тебя есть собственный комочек шерсти и радости🐶\n\n#{pet.state_message}"
        rescue
          text = "Тебе уже есть о ком заботиться 🤍"
        end

        send_message(text, Telegram::BotService.main_keyboard)
      end
    end
  end
end
