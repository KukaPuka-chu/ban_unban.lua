-- Получаем локального игрока
local player = game.Players.LocalPlayer

-- Создаем инструмент (меч)
local sword = Instance.new("Tool")
sword.Name = "Classic Sword"
sword.Parent = player.Backpack
sword.RequiresHandle = true

-- Создаем ручку меча
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1,4,1) -- стандартный размер меча
handle.BrickColor = BrickColor.new("Really black")
handle.Parent = sword

-- Привязываем ручку к инструменту
sword.Handle = handle
