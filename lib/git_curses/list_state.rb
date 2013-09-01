module GitCurses
  class ListState
    def initialize(log, visible_line_count)
      @log = log
      @visible_line_count = visible_line_count
      @line_index = BoundedIndex.new(index: 0, max_index: log.count.as_index)
      @display_index = DisplayIndex.new(
                         index: 0,
                         visible_line_count: visible_line_count,
                         item_count: log.count
                       )
      max_highlight_index = [log.count, visible_line_count].min.as_index
      @highlight = Highlight.new(max_highlight_index)
    end

    def move_up
      line_index.move_up

      highlight.move_up

      if highlight.upper_boundary_pushed?
        display_index.move_up
      end
    end

    def move_down
      line_index.move_down

      highlight.move_down

      if highlight.lower_boundary_pushed?
        display_index.move_down
      end
    end

    def highlighted?(index)
      highlight.highlighted?(index)
    end

    def debug_message
      ""
    end

    def display_items
      log.items.slice(display_index.index, visible_line_count)
    end

    def index
      line_index.index
    end

    private
    attr_reader :line_index, :highlight, :display_index, :log, :visible_line_count
  end
end
