class ListController
  def initialize(log)
    @log = log
  end

  def run
    with_window do |window|
      input = Input.new(window)
      list_state = ListState.new(log, window.visible_line_count)

      command = :nop
      done = false

      while !done
        case command
        when :quit
          done = true
        when :copy_sha
          copy_sha(list_state.index)
          done = true
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

  def copy_sha(index)
    `echo #{log[index].fetch(:sha)} | tr -d "\n" | pbcopy`
  end

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
