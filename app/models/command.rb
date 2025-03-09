class Command
  attr_accessor :name, :text, :handler

  def initialize(name:, text:, handler:)
    @name = name
    @text = text
    @handler = handler
  end
end
