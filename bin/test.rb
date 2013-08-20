#!/usr/bin/env ruby

require "debugger"
require "curses"
require_relative "../lib/git_curses"
include GitCurses

ListController.new(GitLog.new).run
