module GitCurses
  class BoundedIndex
    def initialize(options = {})
      @index = options.fetch(:index) { 0 }
      @max_index = options.fetch(:max_index)
      raise ArgumentError.new('index supplied must be positive') if index < 0
      raise ArgumentError.new('max_index supplied must be positive') if max_index < 0
      raise ArgumentError.new('index supplied out of bounds') if index > max_index
    end

    attr_reader :index

    def move_up
      self.index = [index - 1, 0].max
    end

    def move_down
      self.index = [index + 1, max_index].min
    end

  private
    attr_writer :index
    attr_reader :max_index
  end
end
