class Fixnum
  def as_index
    self - 1
  end
end

class ListState
  attr_reader :item_index, :highlight_index, :list_index

  def initialize(line_count)
    self.item_index = 0
    self.line_count = line_count
    self.highlight_index = 0
    self.list_index = 0
  end

  def move_up
    self.item_index = [item_index - 1, 0].max

    old_highlight_index = highlight_index
    self.highlight_index = [self.highlight_index - 1, 0].max
    highlight_index_changed = old_highlight_index != highlight_index

    if !highlight_index_changed && highlight_index == 0
      self.list_index = [list_index - 1, 0].max
    end
  end

  def move_down
    self.item_index = [item_index + 1, line_count.as_index].min

    old_highlight_index = highlight_index
    self.highlight_index = [self.highlight_index + 1, VISIBLE_LINES.as_index].min
    highlight_index_changed = old_highlight_index != highlight_index

    if !highlight_index_changed && highlight_index == VISIBLE_LINES.as_index
      self.list_index = [list_index + 1, line_count - VISIBLE_LINES].min
    end
  end

private
  attr_writer   :item_index, :highlight_index, :list_index
  attr_accessor :line_count
end