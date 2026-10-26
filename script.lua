--[[
	ULTIMATE YOUTUBE SHOWCASE SCRIPT (DEV TESTING SUITE)
	Features: CFrame SpeedHack, Advanced Fly, Target Lock Aimbot with Dynamic Crosshair & Blue-Pink Glow, Player-Only ESP (White Outline + Red Fill).
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Очистка старой версии GUI
if PlayerGui:FindFirstChild("UltimateDevHub") then
	PlayerGui.UltimateDevHub:Destroy()
end

-- Главный контейнер
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateDevHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 430)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 65)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Кастомный фон (Image ID из запроса)
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://112525965968613"
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.ImageTransparency = 0.4
BackgroundImage.ZIndex = 0
BackgroundImage.Parent = MainFrame

-- Верхняя панель (Header)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ EXECUTOR HUB | v3.5 PRO"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 2
TitleLabel.Parent = Header

-- Кнопки управления окном (Закрыть [X] и Свернуть [-])
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -38, 0.5, -16)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.ZIndex = 3
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 32, 0, 32)
MinimizeButton.Position = UDim2.new(1, -75, 0.5, -16)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.ZIndex = 3
MinimizeButton.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Логика перемещения окна (Dragging)
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

-- Создание плавающей кнопки при сворачивании (Иконка из запроса: 96019926640194)
local FloatButton = Instance.new("ImageButton")
FloatButton.Name = "FloatButton"
FloatButton.Size = UDim2.new(0, 50, 0, 50)
FloatButton.Position = UDim2.new(0, 30, 0.5, -25)
FloatButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
FloatButton.Image = "rbxassetid://96019926640194"
FloatButton.Visible = false
FloatButton.ZIndex = 10
FloatButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(120, 100, 255)
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatButton

-- Сворачивание и разворачивание
MinimizeButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	FloatButton.Visible = true
end)

FloatButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	FloatButton.Visible = false
end)

-- Боковая панель навигации (Sidebar)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 2
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

-- Контейнер для вкладок
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -170, 1, -48)
ContentContainer.Position = UDim2.new(0, 165, 0, 44)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 2
ContentContainer.Parent = MainFrame

local Tabs = {}
local TabButtons = {}

local function createTab(name)
	local TabScroll = Instance.new("ScrollingFrame")
	TabScroll.Size = UDim2.new(1, 0, 1, 0)
	TabScroll.BackgroundTransparency = 1
	TabScroll.BorderSizePixel = 0
	TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabScroll.ScrollBarThickness = 4
	TabScroll.Visible = false
	TabScroll.ZIndex = 2
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

	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, 0, 0, 36)
	Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
	Btn.BackgroundTransparency = 0.3
	Btn.Font = Enum.Font.GothamSemibold
	Btn.Text = name
	Btn.TextColor3 = Color3.fromRGB(160, 160, 180)
	Btn.TextSize = 13
	Btn.ZIndex = 2
	Btn.Parent = Sidebar

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 8)
	BtnCorner.Parent = Btn

	Btn.MouseButton1Click:Connect(function()
		for _, t in pairs(Tabs) do t.Visible = false end
		for _, b in pairs(TabButtons) do 
			TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 40), TextColor3 = Color3.fromRGB(160, 160, 180)}):Play()
		end
		TabScroll.Visible = true
		TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 80, 250), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)

	table.insert(TabButtons, Btn)
	Tabs[name] = TabScroll
	return TabScroll
end

local MovementTab = createTab("Movement")
local CombatTab = createTab("Combat")
local VisualsTab = createTab("Visuals")

-- UI Компоненты (Тумблеры и Слайдеры)
local function addToggle(tab, text, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(1, 0, 0, 44)
	ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
	ToggleFrame.BackgroundTransparency = 0.4
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.ZIndex = 2
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
	Label.ZIndex = 2
	Label.Parent = ToggleFrame

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Size = UDim2.new(0, 42, 0, 22)
	ToggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
	ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
	ToggleBtn.Text = ""
	ToggleBtn.ZIndex = 2
	ToggleBtn.Parent = ToggleFrame

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(1, 0)
	BtnCorner.Parent = ToggleBtn

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 18, 0, 18)
	Circle.Position = UDim2.new(0, 2, 0.5, -9)
	Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Circle.ZIndex = 2
	Circle.Parent = ToggleBtn

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = Circle

	local active = false
	ToggleBtn.MouseButton1Click:Connect(function()
		active = not active
		local targetColor = active and Color3.fromRGB(110, 80, 250) or Color3.fromRGB(45, 45, 65)
		local targetPos = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)

		TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()

		callback(active)
	end)
end

local function addSlider(tab, text, min, max, default, callback)
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Size = UDim2.new(1, 0, 0, 60)
	SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
	SliderFrame.BackgroundTransparency = 0.4
	SliderFrame.BorderSizePixel = 0
	SliderFrame.ZIndex = 2
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
	Label.ZIndex = 2
	Label.Parent = SliderFrame

	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(1, -30, 0, 6)
	Bar.Position = UDim2.new(0, 15, 0, 38)
	Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
	Bar.BorderSizePixel = 0
	Bar.ZIndex = 2
	Bar.Parent = SliderFrame

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = Bar

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
	Fill.BackgroundColor3 = Color3.fromRGB(110, 80, 250)
	Fill.BorderSizePixel = 0
	Fill.ZIndex = 2
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

-- Глобальные переменные функций для очистки при выходе
local activeConnections = {}

-- ============================================================
-- 1. CFRAME SPEEDHACK
-- ============================================================
local cframeSpeedEnabled = false
local cframeSpeedValue = 25

addToggle(MovementTab, "CFrame SpeedHack", function(state)
	cframeSpeedEnabled = state
end)

addSlider(MovementTab, "Speed Value", 1, 300, 25, function(val)
	cframeSpeedValue = val
end)

table.insert(activeConnections, RunService.RenderStepped:Connect(function(dt)
	if cframeSpeedEnabled then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			local rootPart = char.HumanoidRootPart
			if humanoid.MoveDirection.Magnitude > 0 then
				rootPart.CFrame = rootPart.CFrame + (humanoid.MoveDirection * (cframeSpeedValue * dt))
			end
		end
	end
end))

-- ============================================================
-- 2. ADVANCED FLY (С красивыми настройками и указателями Вверх/Вниз)
-- ============================================================
local flying = false
local flySpeed = 50
local bv, bg

addToggle(MovementTab, "Advanced Fly", function(state)
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
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

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

addSlider(MovementTab, "Flight Speed", 10, 200, 50, function(val)
	flySpeed = val
end)

-- Информационная плашка для полета (показывает управление Вверх/Вниз)
local FlyInfoFrame = Instance.new("Frame")
FlyInfoFrame.Size = UDim2.new(1, 0, 0, 55)
FlyInfoFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
FlyInfoFrame.BackgroundTransparency = 0.4
FlyInfoFrame.BorderSizePixel = 0
FlyInfoFrame.ZIndex = 2
FlyInfoFrame.Parent = MovementTab

local FlyInfoCorner = Instance.new("UICorner")
FlyInfoCorner.CornerRadius = UDim.new(0, 8)
FlyInfoCorner.Parent = FlyInfoFrame

local FlyInfoLabel = Instance.new("TextLabel")
FlyInfoLabel.Size = UDim2.new(1, -20, 1, 0)
FlyInfoLabel.Position = UDim2.new(0, 10, 0, 0)
FlyInfoLabel.BackgroundTransparency = 1
FlyInfoLabel.Font = Enum.Font.GothamMedium
FlyInfoLabel.Text = "Fly Controls:\n[Space] - Up (Вверх)  |  [LeftShift] - Down (Вниз)"
FlyInfoLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
FlyInfoLabel.TextSize = 12
FlyInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
FlyInfoLabel.ZIndex = 2
FlyInfoLabel.Parent = FlyInfoFrame

-- ============================================================
-- 3. ESP (Только Игроки: Белый контур + Красная заливка)
-- ============================================================
local espEnabled = false

addToggle(VisualsTab, "Player ESP (White Outline / Red Fill)", function(state)
	espEnabled = state
	if not espEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChild("DevPlayerESP") then
				plr.Character.DevPlayerESP:Destroy()
			end
		end
	end
end)

table.insert(activeConnections, RunService.RenderStepped:Connect(function()
	if espEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local char = plr.Character
				if not char:FindFirstChild("DevPlayerESP") then
					local hl = Instance.new("Highlight")
					hl.Name = "DevPlayerESP"
					hl.Adornee = char
					hl.FillColor = Color3.fromRGB(220, 40, 40) -- Красная заливка
					hl.FillTransparency = 0.4
					hl.OutlineColor = Color3.fromRGB(255, 255, 255) -- Белый контур
					hl.OutlineTransparency = 0
					hl.Parent = char
				end
			end
		end
	end
end))

-- ============================================================
-- 4. AIMBOT (Жосткая фиксация камеры + Сине-Розовый перелив + Динамический прицел ID: 117749037231625)
-- ============================================================
local aimbotEnabled = false

addToggle(CombatTab, "Hard-Lock Aimbot & Dynamic Crosshair", function(state)
	aimbotEnabled = state
end)

-- Создание кастомного переливающегося прицела на цель
local AimCrosshair = Instance.new("ImageLabel")
AimCrosshair.Name = "AimCrosshair"
AimCrosshair.Size = UDim2.new(0, 40, 0, 40)
AimCrosshair.AnchorPoint = Vector2.new(0.5, 0.5)
AimCrosshair.BackgroundTransparency = 1
AimCrosshair.Image = "rbxassetid://117749037231625"
AimCrosshair.Visible = false
AimCrosshair.ZIndex = 15
AimCrosshair.Parent = ScreenGui

table.insert(activeConnections, RunService.RenderStepped:Connect(function(dt)
	local camera = workspace.CurrentCamera
	local closestTarget = nil
	local shortestDistance = math.huge

	if aimbotEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") then
				local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
				if humanoid.Health > 0 then
					local hrp = plr.Character.HumanoidRootPart
					local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
					if onScreen then
						local screenDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
						if screenDist < shortestDistance then
							shortestDistance = screenDist
							closestTarget = hrp
						end
					end
				end
			end
		end

		if closestTarget then
			-- Жесткая фиксация камеры на цель без возможности двигать
			camera.CFrame = CFrame.new(camera.CFrame.Position, closestTarget.Position)

			-- Подсветка цели сине-
