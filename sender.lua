local component = require("component")
local modem = component.modem
local term = require("term")

local port = 1234 -- тот самый канал

modem.open(port) -- открываем порт на всякий
term.clear()
print("=== СЕНДЕР ===")

while true do
  io.write("Талон: ")
  local ticket = io.read()
  io.write("Окно: ")
  local window = io.read()

  local message = ticket .. " " .. window
  modem.broadcast(port, message)
  print("Отправлено: " .. message)
end
