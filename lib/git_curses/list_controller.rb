class ListController
  def initialize(log)
    @log = log
  end

  def run
    with_window do |window|
      input = Input.new(window)
      list_state = ListState.new(log, window.visible_line_count)

      command = :nop

      while command != :quit
        case command
        when :move_down
          list_state.move_down
        when :move_up
          list_state.move_up
        end

        window.update_display(list_state)

        command = input.next_command
      end
    end
  end

private
  attr_reader :log

  def with_window
    window = CursesWindow.new
    window.init_screen
    begin
      yield(window)
    ensure
      window.close_screen
    end
  end
end
