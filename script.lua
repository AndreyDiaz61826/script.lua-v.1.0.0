--[[
	============================================================
	ULTIMATE DEVELOPER TESTING SUITE & ADMIN PANEL
	Designed for Roblox Game Testing & Debugging
	============================================================
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Удаляем старый GUI если он уже есть (для удобства перезапуска)
if PlayerGui:FindFirstChild("DevTestingSuiteGui") then
	PlayerGui.DevTestingSuiteGui:Destroy()
end

-- Создание главного контейнера ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevTestingSuiteGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Главное окно (Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 60)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Верхняя панель (Header для перетаскивания)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ DEVELOPER TESTING SUITE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -40, 0.5, -17.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(235, 65, 65)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Логика перетаскивания окна мышкой
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Боковая панель навигации (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(21, 21, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

-- Контейнер для вкладок (Content Area)
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -170, 1, -55)
ContentContainer.Position = UDim2.new(0, 165, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Таблицы вкладок
local Tabs = {}
local TabButtons = {}
local currentActiveTab = nil

local function createTab(name)
	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, 0)
	TabScroll.BackgroundTransparency = 1
	TabScroll.BorderSizePixel = 0
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabScroll.ScrollBarThickness = 4
	TabScroll.Visible = false
	TabScroll.Parent = ContentContainer

	local Layout = Instance.new("UIListLayout")
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Padding = UDim.new(0, 10)
	Layout.Parent = TabScroll

	local Padding = Instance.new("UIPadding")
	Padding.PaddingTop = UDim.new(0, 5)
	Padding.PaddingLeft = UDim.new(0, 5)
	Padding.PaddingRight = UDim.new(0, 10)
	Padding.Parent = TabScroll

	-- Кнопка в сайдбаре
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 0, 36)
	Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
	Btn.Font = Enum.Font.GothamSemibold
	Btn.Text = name
	Btn.TextColor3 = Color3.fromRGB(160, 160, 180)
	Btn.TextSize = 13
	Btn.Parent = Sidebar

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 8)
	BtnCorner.Parent = Btn

	Btn.MouseButton1Click:Connect(function()
		for _, t in pairs(Tabs) do t.Visible = false end
		for _, b in pairs(TabButtons) do 
			TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 42), TextColor3 = Color3.fromRGB(160, 160, 180)}):Play()
		end
		TabScroll.Visible = true
		TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 80, 240), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		currentActiveTab = name
	end)

	table.insert(TabButtons, Btn)
	Tabs[name] = TabScroll
	return TabScroll
end

-- Создаем вкладки
local MovementTab = createTab("Movement")
local VisualsTab = createTab("Visuals")
local AutomationTab = createTab("Automation")

-- Функция создания Тумблера (Toggle)
local function addToggle(tab, text, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 44)
	ToggleFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.Parent = tab

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = ToggleFrame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.Position = UDim2.new(0, 15, 0, 0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.GothamMedium
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(220, 220, 230)
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = ToggleFrame

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Size = UDim2.new(0, 42, 0, 22)
	ToggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	ToggleBtn.Text = ""
	ToggleBtn.Parent = ToggleFrame

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(1, 0)
	BtnCorner.Parent = ToggleBtn

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 18, 0, 18)
	Circle.Position = UDim2.new(0, 2, 0.5, -9)
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.Parent = ToggleBtn

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle

	local active = false
	ToggleBtn.MouseButton1Click:Connect(function()
		active = not active
		local targetColor = active and Color3.fromRGB(90, 80, 240) or Color3.fromRGB(45, 45, 60)
		local targetPos = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)

		TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()

		callback(active)
	end)
end

-- Функция создания Слайдера (Slider)
local function addSlider(tab, text, min, max, default, callback)
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Size = UDim2.new(1, 0, 0, 60)
	SliderFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
	SliderFrame.BorderSizePixel = 0
	SliderFrame.Parent = tab

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = SliderFrame

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -30, 0, 25)
	Label.Position = UDim2.new(0, 15, 0, 5)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.GothamMedium
	Label.Text = text .. ": " .. tostring(default)
	Label.TextColor3 = Color3.fromRGB(220, 220, 230)
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = SliderFrame

	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(1, -30, 0, 6)
	Bar.Position = UDim2.new(0, 15, 0, 38)
	Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	Bar.BorderSizePixel = 0
	Bar.Parent = SliderFrame

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = Bar

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
	Fill.BackgroundColor3 = Color3.fromRGB(90, 80, 240)
	Fill.BorderSizePixel = 0
	Fill.Parent = Bar

	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = Fill

	local draggingSlider = false
	Bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
			Fill.Size = UDim2.new(pos, 0, 1, 0)
			local val = math.floor(min + (max - min) * pos)
			Label.Text = text .. ": " .. tostring(val)
			callback(val)
		end
	end)
end

-- ============================================================
-- ФУНКЦИОНАЛ СКРИПТА (Movement, Visuals, Automation)
-- ============================================================

-- 1. FLY (Полет)
local flying = false
local flySpeed = 50
local bv, bg

addToggle(MovementTab, "Smooth Flight Mode", function(state)
	flying = state
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart

	if flying then
		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.Parent = hrp

		bg = Instance.new("BodyGyro")
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.CFrame = hrp.CFrame
		bg.Parent = hrp

		task.spawn(function()
			while flying and char and hrp and hrp.Parent do
				local cam = workspace.CurrentCamera
				local moveDir = Vector3.new()
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end

				bv.Velocity = moveDir * flySpeed
				bg.CFrame = cam.CFrame
				RunService.RenderStepped:Wait()
			end
			if bv then bv:Destroy() end
			if bg then bg:Destroy() end
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

addSlider(MovementTab, "Flight Speed", 16, 200, 50, function(val)
	flySpeed = val
end)

-- 2. SPEEDHACK (Модификатор скорости бега)
addSlider(MovementTab, "WalkSpeed Multiplier", 16, 150, 16, function(val)
	local char = LocalPlayer.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
	end
end)

-- 3. INVISIBLE (Невидимость персонажа)
addToggle(VisualsTab, "Client Character Invisibility", function(state)
	local char = LocalPlayer.Character
	if not char then return end
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") or part:IsA("Decal") then
			part.Transparency = state and 1 or 0
		end
	end
end)

-- 4. ESP (Подсветка игроков через Highlight)
addToggle(VisualsTab, "Player ESP Box & Highlight", function(state)
	if state then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				if not player.Character:FindFirstChild("DevESP") then
					local hl = Instance.new("Highlight")
					hl.Name = "DevESP"
					hl.Adornee = player.Character
					hl.FillColor = Color3.fromRGB(235, 65, 65)
					hl.OutlineColor = Color3.fromRGB(255, 255, 255)
					hl.FillTransparency = 0.5
					hl.Parent = player.Character
				end
			end
		end
	else
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("DevESP") then
				player.Character.DevESP:Destroy()
			end
		end
	end
end)

-- 5. AUTO CLICKER (Автокликер для кликабельных механик плейса)
local autoClicking = false
local clickCPS = 10

addToggle(AutomationTab, "Auto Clicker Simulator", function(state)
	autoClicking = state
	task.spawn(function()
		while autoClicking do
			task.wait(1 / clickCPS)
			local vim = game:GetService("VirtualInputManager")
			vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
			vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
		end
	end)
end)

addSlider(AutomationTab, "Clicks Per Second (CPS)", 1, 50, 10, function(val)
	clickCPS = val
end)

-- Активируем первую вкладку при старте по умолчанию
Tabs["Movement"].Visible = true
TweenService:Create(TabButtons[1], TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 80, 240), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()

print("[DevTestingSuite]: Скрипт успешно инициализирован и готов к работе в твоем плейсе!")
