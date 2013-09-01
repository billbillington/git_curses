class Input
  def initialize(window)
    @window = window
  end

  def next_command
    case next_char
    when 'q'
      :quit
    when ' '
      :copy_sha
    when Curses::Key::DOWN
      :move_down
    when Curses::Key::UP
      :move_up
    end
  end

  private
  def next_char
    @window.getch
  end
end
