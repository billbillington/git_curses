require 'active_support/core_ext/module/delegation'

class CursesWindow
  CURSOR_INVISIBLE = 0

  HIGHLIGHT_COLOR  = 1
  NORMAL_COLOR     = 2

  def initialize
    # Don't echo user input
    Curses.noecho
    # Setup colors
    Curses.start_color
    Curses.init_pair(HIGHLIGHT_COLOR, Curses::COLOR_BLACK, Curses::COLOR_WHITE)
    Curses.init_pair(NORMAL_COLOR, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
    # Make chars typed by user availble to program instantly
    Curses.cbreak
    # Make cursor invisible
    Curses.curs_set(CURSOR_INVISIBLE)
  end

  attr_reader :window
  delegate :getch, :to => :window

  def init_screen
    @window = Curses.init_screen
    @window.keypad(true)
  end

  def close_screen
    Curses.close_screen
  end

  def visible_line_count
    screen_height
  end

  def update_display(list_state)
    reset_cursor
    display_lines(list_state)
    display_debug_message(list_state.debug_message)
    refresh_window
  end

private
  def display_debug_message(message)
    if message.to_s != ''
      error_line_index =  screen_height - 2
      clear_line(error_line_index)
      @window.setpos(error_line_index, 0)
      print_line("** #{message}")
    end
  end

  def clear_line(index)
    @window.setpos(index, 0)
    print(' ' * Curses.cols())
  end

  def reset_cursor
    @window.setpos(0 ,0)
  end

  def refresh_window
    @window.refresh
  end

  def display_lines(list_state)
    list_state.display_items.each_with_index do |item, index|
      style = list_state.highlighted?(index) ? :highlight : :normal
      print(item.fetch(:sha), style)
      print(' - ', style)
      if item[:branches]
        print("#{item.fetch(:branches)} ", style)
      end
      print("#{item.fetch(:subject)} ", style)
      print("#{item.fetch(:author)} ", style)
      print("#{item.fetch(:date)} ", style)
      print "\n"
    end
  end

  def print(text, style = :normal)
    @window.attron(Curses::color_pair(color_for_style(style))| Curses::A_NORMAL) do
      @window.addstr(text)
    end
  end

  def display_line(line, style = :normal)
    print("#{line}\n", style)
  end

  def color_for_style(style)
    case style
    when :normal
      NORMAL_COLOR
    when :highlight
      HIGHLIGHT_COLOR
    end
  end

  def screen_height
    Curses.lines()
  end
end
