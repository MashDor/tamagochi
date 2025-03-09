require_relative '../../models/collections/command_collection'

module Telegram
  class CommandHandler
    class << self
      def execute(chat_id, text)
        command = commands.find_by(text:)
        command_class = command ? command.handler : Telegram::Commands::Unknown
        command_class.new(chat_id).execute
      end

      def register(command_name, command_text, command_handler)
        commands.add(Command.new(name: command_name, text: command_text, handler: command_handler))
      end

      def commands
        @commands ||= CommandCollection.new
      end
    end
  end
end
