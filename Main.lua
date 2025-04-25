local GUI = require("GUI")
local system = require("System")
local component = require("component")
local modem = component.modem

local PORT = 1234
modem.open(PORT)

-- Получение размеров экрана
local screenWidth, screenHeight = component.gpu.getResolution()

-- Создание окна
local workspace, window = system.addWindow(GUI.titledWindow(1, 1, screenWidth, screenHeight, "Отправка талона"))
window.width, window.height = screenWidth, screenHeight
window.actionButtons.close.onTouch = function()
  window:close()
end

-- Центровка
local inputWidth = math.floor(screenWidth * 0.6)
local centerX = math.floor((screenWidth - inputWidth) / 2)
local lineHeight = 3
local spacing = 2
local startY = 2

-- Поле "Причина" (визуально, не участвует в логике)
window:addChild(GUI.label(centerX, startY, inputWidth, 1, 0x000000, "Причина:"))
window:addChild(GUI.input(
  centerX, startY + lineHeight, inputWidth, lineHeight,
  0xCCCCCC, 0x000000, 0x000000, 0xCCCCCC, 0x2D2D2D, "",
  "Получить / Отправить"
))

-- Поле "Талон"
window:addChild(GUI.label(centerX, startY + 2 * (lineHeight + spacing), inputWidth, 1, 0x000000, "Талон:"))
local ticketInput = window:addChild(GUI.input(
  centerX, startY + 3 * (lineHeight + spacing) - spacing, inputWidth, lineHeight,
  0xCCCCCC, 0x000000, 0x000000, 0xCCCCCC, 0x2D2D2D, "", "123"
))

-- Поле "Окно"
window:addChild(GUI.label(centerX, startY + 4 * (lineHeight + spacing), inputWidth, 1, 0x000000, "Окно:"))
local windowInput = window:addChild(GUI.input(
  centerX, startY + 5 * (lineHeight + spacing) - spacing, inputWidth, lineHeight,
  0xCCCCCC, 0x000000, 0x000000, 0xCCCCCC, 0x2D2D2D, "", "1"
))

-- Кнопка "Отправить"
local button = window:addChild(GUI.button(
  centerX, startY + 6 * (lineHeight + spacing), inputWidth, lineHeight + 1,
  0x4CAF50, 0xFFFFFF, 0x3E8E41, 0xFFFFFF, "Отправить"
))

-- Статус
local status = window:addChild(GUI.label(
  centerX, startY + 7 * (lineHeight + spacing) + 1, inputWidth, 1,
  0x00FF00, "Ожидание ввода..."
))

-- Обработка кнопки
button.onTouch = function()
  local ticket = ticketInput.text
  local win = windowInput.text

  if ticket ~= "" and win ~= "" then
    local message = ticket .. " " .. win
    modem.broadcast(PORT, message)
    status.text = "Отправлено: " .. message
    status.colors.text = 0x00FF00
  else
    status.text = "Ошибка: заполните оба поля"
    status.colors.text = 0xFF0000
  end

  workspace:draw()
end

workspace:draw()
