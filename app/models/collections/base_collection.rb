class BaseCollection
  def initialize
    @items = []
  end

  def add(item)
    unless @items.any? { |i| i.id == item.id }
      @items << item
    end
  end

  def find_by(**conditions)
    @items.find { |item| conditions.all? { |key, value| item.send(key) == value } }
  end

  def find(id)
    @items.find { |item| item.id == id }
  end

  def all
    @items
  end
end
