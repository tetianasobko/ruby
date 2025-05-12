require_relative 'manager'
require_relative 'user_interface'

manager = Manager.new
ui = UserInterface.new(manager)
ui.run 