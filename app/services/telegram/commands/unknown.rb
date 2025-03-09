module Telegram
  module Commands
    class Unknown < Telegram::Commands::Base
      def execute
        send_message('Я тебя не понял(  Нажми /start или выбери команду из меню, чтобы продолжить')
      end
    end
  end
end
