require_relative './base_collection'

class CommandCollection < BaseCollection\

  def add(command)
    unless @items.any? { |c| c.name == command.name }
      @items << command
    end
  end

  def find(name)
    @items.find { |command| command.name == name }
  end
end
