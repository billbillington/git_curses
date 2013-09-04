module GitCurses
  class DisplayIndex
    def initialize(options = {})
      index = options.fetch(:index) { 0 }
      visible_line_count = options.fetch(:visible_line_count)
      item_count = options.fetch(:item_count)

      raise ArgumentError.new('index supplied must be positive') if index < 0
      raise ArgumentError.new('visible_line_count supplied must be positive') if visible_line_count < 0
      raise ArgumentError.new('item_count supplied must be positive') if item_count < 0

      @max_index = [item_count - visible_line_count, 0].max

      @internal_index = options.fetch(:index_service) { BoundedIndex.method(:new) }.call(index: index, max_index: max_index)
    end

    attr_reader :internal_index, :max_index

    def index
      internal_index.index
    end

    def move_up
      internal_index.move_up
    end

    def move_down
      internal_index.move_down
    end

    private
    attr_reader :internal_index
  end
end
