local component = require("component")
local event = require("event")
local term = require("term")
local gpu = component.gpu
local modem = component.modem

local PORT = 1234
local messages = {}

-- Размер окна
gpu.setResolution(60, 20)

-- Цвета и оформление
local function header()
  term.clear()
  term.setCursor(2, 1)
  io.write("📧 Почта России  |  Очередь")
  term.setCursor(48, 1)
  io.write(os.date("%H:%M %d.%m"))
  term.setCursor(2, 3)
  io.write("Талон   | Окно")
  term.setCursor(2, 4)
  io.write("--------|------")
end

-- Обновление экрана
local function update()
  header()
  for i = 1, #messages do
    local t, w = table.unpack(messages[i])
    term.setCursor(2, 4 + i)
    io.write(string.format("%-7s | %-5s", t, w))
  end
  term.setCursor(2, 18)
  io.write("Ожидание следующего сообщения...")
end

-- Запуск
modem.open(PORT)
header()

while true do
  local _, _, _, _, _, msg = event.pull("modem_message")
  local ticket, window = msg:match("^(%S+)%s+(%S+)$")
  if ticket and window then
    table.insert(messages, {ticket, window})
    if #messages > 12 then
      table.remove(messages, 1)
    end
    update()
  end
end
