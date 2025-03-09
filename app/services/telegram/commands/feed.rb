module Telegram
  module Commands
    class Feed < Telegram::Commands::Base
      command :feed, 'Покормить рыбкой 🐟'

      FEED_STICKERS = [
        'CAACAgIAAxkBAAIH3WfOHMnoiPI6SpY1jc7sv16LUZcpAALGEgACu0toSEYe-6LBC-1sNgQ',
        'CAACAgIAAxkBAAIH9mfOIubsbw-Ir0hb_tEfPP2ZceMSAAKqFgACrpb5S69MWEZ7SticNgQ',
        'CAACAgQAAxkBAAIH-WfOIyFe5Vlf8zN5vGoMnfXI6vVJAALKDAAC1xFoUbasS8tO_pk4NgQ',
        'CAACAgUAAxkBAAIH-mfOIzmvCI_CRnzBNcAPbiFqVVPQAAL1BgACwab-B1PFlLHR_rQcNgQ',
        'CAACAgIAAxkBAAIH-2fOI1AVhSnPbB1QKbeeEw2A38EYAAImFAAC8S7JS3QRNqwztSRoNgQ',
        'CAACAgIAAxkBAAIH22fOHL_kfyjpSZea6by2b9jhE9ChAAKgCAACRVGTDofaJ0abT-q4NgQ',
        'CAACAgIAAxkBAAIH7mfOH4csbUag1z5TlCRi_nrgV6esAAKSCAACRVGTDiSiobgIXO30NgQ',
        'CAACAgIAAxkBAAIH_mfOI5uZkxvaD_zzGtBazGgrHAntAAI_EgACUoU5SOmosibizZ7wNgQ',
        'CAACAgIAAxkBAAIH_2fOI6wX45MvpxFqdXjVg-OXjf0QAAKgGgACYOYYSu-355laIBDANgQ',
        'CAACAgIAAxkBAAIIAAFnziO70GXfaPbtyPncGRb9WGkL0QACMRQAAsC28EslA_XICggeczYE'
      ]

      def execute
        user = User.find_by(telegram_id: chat_id)

        pet = user.current_pet

        if pet
          if pet.current_satiety < 100
            pet.feed
            send_sticker(FEED_STICKERS.sample)
            send_message("Рыбка доставлена в животик 😋\n\n#{pet.state_message}", Telegram::BotService.main_keyboard)
          else
            send_message("У питомца уже полное пузо рыбов 😋", Telegram::BotService.main_keyboard)
          end
        else
          send_message("У тебя ещё нет питомца. Готов найти себе друга?", Telegram::BotService.start_keyboard)
        end
      end
    end
  end
end
