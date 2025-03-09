module Telegram
  module Commands
    class Base
      class << self
        def command(name, text)
          Telegram::CommandHandler.register(name, text, self)
        end
      end

      attr_reader :chat_id

      def initialize(chat_id)
        @chat_id = chat_id
      end

      def execute
        raise NotImplementedError, "#{self.class}#execute must be implemented"
      end

      private

      def send_message(text, keyboard = nil)
        Telegram::BotService.send_message(chat_id, text, keyboard)
      end
    end
  end
end
