local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local library = {}

function library:create_ui(ui_name)
	local Converted = 
		{
			["_ScreenGui"] = Instance.new("ScreenGui");
			["_Frame"] = Instance.new("Frame");
			["_Folder"] = Instance.new("Folder");
			["_Tab Selector"] = Instance.new("ScrollingFrame");
			["_Padding"] = Instance.new("Frame");
			["_Script"] = Instance.new("Script");
			["_UIListLayout"] = Instance.new("UIListLayout");
			["_TopFrame"] = Instance.new("Frame");
			["_HideUI"] = Instance.new("Frame");
			["_HideUI Button"] = Instance.new("TextButton");
			["_UICorner4"] = Instance.new("UICorner");
			["_Script3"] = Instance.new("Script");
			["_UIStroke2"] = Instance.new("UIStroke");
			["_UICorner5"] = Instance.new("UICorner");
			["_Brand"] = Instance.new("TextLabel");
			["_Brand1"] = Instance.new("TextLabel");
		}


	local ShowUI_Converted = 
		{
			["_ShowUI"] = Instance.new("Frame");
			["_HideUI"] = Instance.new("Frame");
			["_HideUI Button"] = Instance.new("TextButton");
			["_UICorner"] = Instance.new("UICorner");
			["_Script"] = Instance.new("Script");
			["_UICorner1"] = Instance.new("UICorner");
			["_UIStroke"] = Instance.new("UIStroke");
		}

	-- ensure the executor has real gethui

	local parent = game:GetService("CoreGui");

	if gethui then
		pcall(function()
			local hui = gethui();

			if type(hui) == "userdata" and hui ~= parent and hui.Parent == parent then
				parent = hui
			end
		end)
	end

	Converted["_ScreenGui"].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Converted["_ScreenGui"].Parent = parent

	Converted["_Frame"].BackgroundColor3 = Color3.fromRGB(34.00000177323818, 34.00000177323818, 34.00000177323818)
	Converted["_Frame"].BorderColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871)
	Converted["_Frame"].Position = UDim2.new(0.251889855, 0, 0.281309366, 0)
	Converted["_Frame"].Size = UDim2.new(0.422185302, 0, 0.437177271, 0)
	Converted["_Frame"].Parent = Converted["_ScreenGui"]
	Converted["_Frame"].Active = true;

	Converted["_Folder"].Parent = Converted["_Frame"];
	Converted["_Folder"].Name = "BodyContainer";

	local function drag(obj, real_gui)
		obj.Active = true;
		real_gui.Active = true;

		local dragging
		local dragInput
		local dragStart
		local startPos

		local gameProc

		local function update(input)
			local delta = input.Position - dragStart
			real_gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end

		obj.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = real_gui.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		obj.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)

		UserInputService.InputChanged:Connect(function(input,gameprocessed)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	end

	--drag(Converted["_Frame"])

	local is_touch = not game:GetService("UserInputService").KeyboardEnabled;

	local function tween_property(obj, data, length)
		TweenService:Create(obj, TweenInfo.new(if type(length) == "number" then length else 0.3,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0), data):Play() 
	end

	local function change_viewport()
		local y = workspace.CurrentCamera.ViewportSize.Y
		local x = workspace.CurrentCamera.ViewportSize.X

		if y < 800 then
			tween_property(Converted["_Frame"], {Size = UDim2.new(0.7, 0, 0.8, 0), Position = UDim2.new(0.1, 0, 0.1, 0)})
		else
			tween_property(Converted["_Frame"], {Size = UDim2.new(if x < 800 then 0.7 else 0.3, 0, 0.35, 0)})
		end
	end

	change_viewport();

	if not is_touch then
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(change_viewport)
	end

	local old_size = Converted["_Frame"].Size;
	local hidden = false;

	local should_animate = not is_touch

	local function animate_stroke(Button)
		local CurrentColor;

		if not should_animate then
			return function(color) CurrentColor = color end
		end

		local UIStroke = Button.Parent["UIStroke"];
		CurrentColor = UIStroke.Color;

		Button.MouseEnter:Connect(function()
			tween_property(UIStroke, {Color = Color3.fromRGB(0,0,0)})
		end)

		Button.MouseLeave:Connect(function()
			tween_property(UIStroke, {Color = CurrentColor}, 0.5)
		end)


		return function(color) CurrentColor = color end
	end

	local function animate_button(Button, Color)
		local CurrentColor = Button.BackgroundColor3;
		local color = if Color ~= nil then Color else Color3.fromRGB(18, 18, 18)

		if should_animate then
			Button.MouseEnter:Connect(function()
				tween_property(Button, {BackgroundColor3 = color})
			end)

			Button.MouseLeave:Connect(function()
				tween_property(Button, {BackgroundColor3 = CurrentColor}, 0.5)
			end)
		end

		return function(color) CurrentColor = color end
	end

	local function animate_label(obj)
		if not should_animate then
			return
		end

		local CurrentColor = obj.TextColor3;

		obj.MouseEnter:Connect(function()
			tween_property(obj, {TextColor3 = Color3.fromRGB(150, 150, 150)})
		end)

		obj.MouseLeave:Connect(function()
			tween_property(obj, {TextColor3 = CurrentColor}, 0.5)
		end)
	end

	ShowUI_Converted["_ShowUI"].BackgroundColor3 = Color3.fromRGB(34.00000177323818, 34.00000177323818, 34.00000177323818)
	ShowUI_Converted["_ShowUI"].BackgroundTransparency = 1
	ShowUI_Converted["_ShowUI"].BorderColor3 = Color3.fromRGB(47.0000009983778, 47.0000009983778, 47.0000009983778)
	ShowUI_Converted["_ShowUI"].Position = UDim2.new(-3.63088368e-08, 0, 0.684627593, 0)
	ShowUI_Converted["_ShowUI"].Size = UDim2.new(0.0791195706, 0, 0.0190174319, 25)
	ShowUI_Converted["_ShowUI"].Name = "ShowUI"
	ShowUI_Converted["_ShowUI"].Parent =  Converted["_ScreenGui"]
	ShowUI_Converted["_ShowUI"].Visible = false;

	ShowUI_Converted["_HideUI"].BackgroundColor3 = Color3.fromRGB(32.00000189244747, 32.00000189244747, 32.00000189244747)
	ShowUI_Converted["_HideUI"].BorderSizePixel = 0
	ShowUI_Converted["_HideUI"].Position = UDim2.new(0.0122932605, 0, 0.076511234, 0)
	ShowUI_Converted["_HideUI"].Size = UDim2.new(0.973484159, 0, 0.822000146, 0)
	ShowUI_Converted["_HideUI"].Name = "HideUI"
	ShowUI_Converted["_HideUI"].Parent = ShowUI_Converted["_ShowUI"]

	ShowUI_Converted["_HideUI Button"].Font = Enum.Font.SourceSansBold
	ShowUI_Converted["_HideUI Button"].Text = "Show "..ui_name
	ShowUI_Converted["_HideUI Button"].TextColor3 = Color3.fromRGB(255, 255, 255)
	ShowUI_Converted["_HideUI Button"].TextScaled = true
	ShowUI_Converted["_HideUI Button"].TextSize = 14
	ShowUI_Converted["_HideUI Button"].TextWrapped = true
	ShowUI_Converted["_HideUI Button"].AutoButtonColor = false
	ShowUI_Converted["_HideUI Button"].BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871)
	ShowUI_Converted["_HideUI Button"].Position = UDim2.new(0.0156153198, 0, 0.0267633926, 0)
	ShowUI_Converted["_HideUI Button"].Size = UDim2.new(0.975390494, 0, 0.951338112, 0)
	ShowUI_Converted["_HideUI Button"].Name = "HideUI Button"
	ShowUI_Converted["_HideUI Button"].Parent = ShowUI_Converted["_HideUI"]

	ShowUI_Converted["_HideUI Button"].MouseButton1Down:Connect(function()				
		Converted["_Frame"].Visible = hidden;
		ShowUI_Converted["_ShowUI"].Visible = not hidden;

		hidden = not hidden;
	end)

	ShowUI_Converted["_UICorner"].CornerRadius = UDim.new(0, 2)
	ShowUI_Converted["_UICorner"].Parent = ShowUI_Converted["_HideUI Button"]

	ShowUI_Converted["_Script"].Parent = ShowUI_Converted["_HideUI Button"]

	ShowUI_Converted["_UICorner1"].CornerRadius = UDim.new(0, 2)
	ShowUI_Converted["_UICorner1"].Parent = ShowUI_Converted["_HideUI"]

	ShowUI_Converted["_UIStroke"].Color = Color3.fromRGB(192.00000375509262, 79.00000289082527, 79.00000289082527)
	ShowUI_Converted["_UIStroke"].Parent = ShowUI_Converted["_HideUI"]

	drag(Converted["_TopFrame"], Converted["_Frame"])

	animate_button(ShowUI_Converted["_HideUI Button"])
	animate_stroke(ShowUI_Converted["_HideUI Button"])

	Converted["_Tab Selector"].CanvasSize = UDim2.new(0, 0, 0, 0)
	Converted["_Tab Selector"].ElasticBehavior = Enum.ElasticBehavior.Never
	Converted["_Tab Selector"].HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	Converted["_Tab Selector"].ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	Converted["_Tab Selector"].ScrollBarThickness = 3
	Converted["_Tab Selector"].Active = true
	Converted["_Tab Selector"].BackgroundColor3 = Color3.fromRGB(34.00000177323818, 34.00000177323818, 34.00000177323818)
	Converted["_Tab Selector"].BorderColor3 = Color3.fromRGB(47.0000009983778, 47.0000009983778, 47.0000009983778)
	Converted["_Tab Selector"].BorderSizePixel = 0
	Converted["_Tab Selector"].Size = UDim2.new(0.200000003, 0, 1, 0)
	Converted["_Tab Selector"].ZIndex = -1
	Converted["_Tab Selector"].Name = "Tab Selector"
	Converted["_Tab Selector"].Parent = Converted["_Frame"]
	
	Converted["_UIListLayout"].Padding = UDim.new(0, 5)
	Converted["_UIListLayout"].HorizontalAlignment = Enum.HorizontalAlignment.Center
	Converted["_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
	Converted["_UIListLayout"].Parent = Converted["_Tab Selector"]
	

	Converted["_Tab Selector"].CanvasSize = UDim2.new(0, 0, 0, Converted["_UIListLayout"].AbsoluteContentSize.Y)
	Converted["_UIListLayout"]:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Converted["_Tab Selector"].CanvasSize = UDim2.new(0, 0, 0, Converted["_UIListLayout"].AbsoluteContentSize.Y)
	end)

	Converted["_Padding"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Converted["_Padding"].BackgroundTransparency = 1
	Converted["_Padding"].Position = UDim2.new(1.89903005e-07, 0, 0, 0)
	Converted["_Padding"].Size = UDim2.new(0, 156, 0, 25)
	Converted["_Padding"].Name = "Padding"
	Converted["_Padding"].Parent = Converted["_Tab Selector"]

	Converted["_Script"].Parent = Converted["_Tab Selector"]

	Converted["_TopFrame"].BackgroundColor3 = Color3.fromRGB(34.00000177323818, 34.00000177323818, 34.00000177323818)
	Converted["_TopFrame"].BorderColor3 = Color3.fromRGB(47.0000009983778, 47.0000009983778, 47.0000009983778)
	Converted["_TopFrame"].Size = UDim2.new(1, 0, 0, 25)
	Converted["_TopFrame"].Name = "TopFrame"
	Converted["_TopFrame"].Parent = Converted["_Frame"]
	Converted["_TopFrame"].Active = true;


	Converted["_HideUI"].BackgroundColor3 = Color3.fromRGB(32.00000189244747, 32.00000189244747, 32.00000189244747)
	Converted["_HideUI"].BorderSizePixel = 0
	Converted["_HideUI"].Position = UDim2.new(0.884634316, 0, 0.076511234, 0)
	Converted["_HideUI"].Size = UDim2.new(0.101143323, 0, 0.822000146, 0)
	Converted["_HideUI"].Name = "HideUI"
	Converted["_HideUI"].Parent = Converted["_TopFrame"]

	Converted["_HideUI Button"].Font = Enum.Font.SourceSansBold
	Converted["_HideUI Button"].Text = "Hide"
	Converted["_HideUI Button"].TextColor3 = Color3.fromRGB(255, 255, 255)
	Converted["_HideUI Button"].TextSize = 14
	Converted["_HideUI Button"].AutoButtonColor = false
	Converted["_HideUI Button"].BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871)
	Converted["_HideUI Button"].Position = UDim2.new(0.0156153198, 0, 0.0267633926, 0)
	Converted["_HideUI Button"].Size = UDim2.new(0.975390494, 0, 0.951338112, 0)
	Converted["_HideUI Button"].Name = "HideUI Button"
	Converted["_HideUI Button"].Parent = Converted["_HideUI"]

	Converted["_HideUI Button"].MouseButton1Down:Connect(function()				
		Converted["_Frame"].Visible = hidden;
		ShowUI_Converted["_ShowUI"].Visible = not hidden;

		hidden = not hidden;
	end)

	Converted["_UICorner4"].CornerRadius = UDim.new(0, 2)
	Converted["_UICorner4"].Parent = Converted["_HideUI Button"]

	Converted["_Script3"].Parent = Converted["_HideUI Button"]

	Converted["_UIStroke2"].Color = Color3.fromRGB(192.00000375509262, 79.00000289082527, 79.00000289082527)
	Converted["_UIStroke2"].Parent = Converted["_HideUI"]

	Converted["_UICorner5"].CornerRadius = UDim.new(0, 2)
	Converted["_UICorner5"].Parent = Converted["_HideUI"]

	Converted["_Brand"].Font = Enum.Font.Unknown
	Converted["_Brand"].RichText = true
	Converted["_Brand"].Text = "<font family=\"rbxasset://fonts/families/SourceSansPro.json\" style=\"Normal\" weight=\"400\" >Pet Simulator X </font><font family=\"rbxasset://fonts/families/SourceSansPro.json\" style=\"Normal\" weight=\"700\" >Hub</font>"
	Converted["_Brand"].TextColor3 = Color3.fromRGB(255, 255, 255)
	Converted["_Brand"].TextSize = 15
	Converted["_Brand"].TextXAlignment = Enum.TextXAlignment.Left
	Converted["_Brand"].TextYAlignment = Enum.TextYAlignment.Top
	Converted["_Brand"].BackgroundTransparency = 1
	Converted["_Brand"].BorderSizePixel = 0
	Converted["_Brand"].Position = UDim2.new(0.208000004, 0, 0.165626228, 0)
	Converted["_Brand"].Size = UDim2.new(0.283623546, 0, 0.821537793, 0)
	Converted["_Brand"].Name = "Brand"
	Converted["_Brand"].Parent = Converted["_TopFrame"]

	Converted["_Brand1"].Font = Enum.Font.SourceSans
	Converted["_Brand1"].Text = ui_name
	Converted["_Brand1"].TextColor3 = Color3.fromRGB(255, 255, 255)
	Converted["_Brand1"].TextSize = 15
	Converted["_Brand1"].TextXAlignment = Enum.TextXAlignment.Left
	Converted["_Brand1"].TextYAlignment = Enum.TextYAlignment.Top
	Converted["_Brand1"].BackgroundTransparency = 1
	Converted["_Brand1"].BorderSizePixel = 0
	Converted["_Brand1"].Position = UDim2.new(0.00841608364, 0, 0.165626228, 0)
	Converted["_Brand1"].Size = UDim2.new(0.0996849537, 0, 0.781537771, 0)
	Converted["_Brand1"].Name = "Brand"
	Converted["_Brand1"].Parent = Converted["_TopFrame"]


	animate_stroke(Converted["_HideUI Button"])

	local first_item = nil;

	local item_map = {}

	local function create_tab_item(section_name)

		-- Button

		local TabSelectorButton = Instance.new("Frame");
		local _TextButton = Instance.new("TextButton");
		local _UICorner = Instance.new("UICorner");
		local _UIStroke = Instance.new("UIStroke");
		local _UICorner1 = Instance.new("UICorner");
		
		TabSelectorButton.BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871)
		TabSelectorButton.BorderSizePixel = 0
		TabSelectorButton.Position = UDim2.new(0.884634316, 0, 0.076511234, 0)
		TabSelectorButton.Size = UDim2.new(0.970000029, 0, 0, 25)
		TabSelectorButton.Name = "Tab Selector Button"
		TabSelectorButton.Parent = Converted["_Tab Selector"]

		_TextButton.Font = Enum.Font.SourceSans
		_TextButton.Text = section_name
		_TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		_TextButton.TextSize = 14
		_TextButton.TextWrapped = true
		_TextButton.AutoButtonColor = false
		_TextButton.BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871)
		_TextButton.Position = UDim2.new(0.0284459032, 0, 0.026763916, 0)
		_TextButton.Size = UDim2.new(0.968975306, 0, 0.951338172, 0)
		_TextButton.Parent = TabSelectorButton

		_UICorner.CornerRadius = UDim.new(0, 2)
		_UICorner.Parent = _TextButton

		_UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		_UIStroke.Color = if first_item == nil then Color3.fromRGB(62, 125, 220) else Color3.fromRGB(47, 47, 47) 
		_UIStroke.LineJoinMode = Enum.LineJoinMode.Bevel
		_UIStroke.Parent = TabSelectorButton

		_UICorner1.CornerRadius = UDim.new(0, 2)
		_UICorner1.Parent = TabSelectorButton

		---

		local Body = Instance.new("ScrollingFrame");

		Body.CanvasSize = UDim2.new(0, 0, 0, 0)
		Body.ElasticBehavior = Enum.ElasticBehavior.Never
		Body.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
		Body.ScrollBarThickness = 3
		Body.VerticalScrollBarInset = Enum.ScrollBarInset.Always
		Body.Active = true
		Body.BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871)
		Body.BorderColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871)
		Body.Position = UDim2.new(0.201616988, 0, 0, 0)
		Body.Size = UDim2.new(0.798627853, 0, 1, 0)
		Body.ZIndex = if first_item == nil then 0 else -1
		Body.Name = "Body"
		Body.Parent = Converted["_Folder"]

		if first_item == nil then
			first_item = Body;
		end

		local _UIListLayout1 = Instance.new("UIListLayout");
		local _Padding1 = Instance.new("Frame");

		_UIListLayout1.Padding = UDim.new(0, 5)
		_UIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		_UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		_UIListLayout1.Parent = Body

		_Padding1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		_Padding1.BackgroundTransparency = 1
		_Padding1.Position = UDim2.new(0.378448039, 0, 0, 0)
		_Padding1.Size = UDim2.new(0, 156, 0, 31)
		_Padding1.Name = "Padding"
		_Padding1.Parent = Body

		local ScrollingFrame = Body;
		local ListLayout = ScrollingFrame["UIListLayout"]

		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)

		ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
		end)

		--local change_save = animate_stroke(_TextButton);		

		_TextButton.MouseButton1Down:Connect(function()
			for i,v in pairs(Converted["_Folder"]:GetChildren()) do
				if v == Body then
					v.ZIndex = 0;
					v.Visible = true;
				else
					v.ZIndex = -1
					v.Visible = false;
				end
			end

			for i,v in pairs(item_map) do
				if v.Button["UIStroke"] == _UIStroke then
					--change_save(Color3.fromRGB(62, 125, 220))
					tween_property(_UIStroke, {Color = Color3.fromRGB(62, 125, 220)})		
				else
					--change_save(Color3.fromRGB(47, 47, 47))
					tween_property(v.Button["UIStroke"], {Color = Color3.fromRGB(47, 47, 47)})		
				end
			end
		end)

		table.insert(item_map, {
			Button = TabSelectorButton,
			Body = Body;
		})

		return Body;
	end


	local function add_toggle(container, text, call_back, Options)
		local checked = if type(Options) == "table" and Options.toggled then true else false

		local Toggle = Instance.new("Frame")
		local SectionTitle = Instance.new("TextLabel")
		local TextButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")

		Toggle.Name = "Toggle"
		Toggle.Parent = container
		Toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BackgroundTransparency = 1.000
		Toggle.Position = UDim2.new(0, 0, 0.201342285, 0)
		Toggle.Size = UDim2.new(1.00000012, 0, 0, 20)

		SectionTitle.Name = "SectionTitle"
		SectionTitle.Parent = Toggle
		SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SectionTitle.BackgroundTransparency = 1.000
		SectionTitle.Position = UDim2.new(0.0309575722, 0, -0.000866699207, 0)
		SectionTitle.Size = UDim2.new(0.471285462, 0, 0, 25)
		SectionTitle.Font = Enum.Font.Roboto;
		SectionTitle.Text = text
		SectionTitle.RichText = true;
		SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		SectionTitle.TextSize = 14.000
		SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

		animate_label(SectionTitle);

		TextButton.Parent = Toggle
		TextButton.BackgroundColor3 = if checked then Color3.fromRGB(66, 155, 251) else Color3.fromRGB(47, 47, 47)
		TextButton.BorderColor3 = Color3.fromRGB(30, 30, 30)
		TextButton.BorderSizePixel = 0
		TextButton.Position = if not is_touch then  UDim2.new(0.876043081, 0, 0.104295351, 0) else UDim2.new(0.776043081, 0, 0.104295351, 0)
		TextButton.Size = if not is_touch then UDim2.new(0.100542352, 0, 0, 20) else UDim2.new(0.2, 0, 0, 20)
		TextButton.AutoButtonColor = false
		TextButton.Font = Enum.Font.SourceSansBold
		TextButton.Text = ""
		TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton.TextSize = 14.000

		UICorner.Parent = TextButton

		local change_save = animate_button(TextButton);				
		TextButton.MouseButton1Down:Connect(function(...)
			checked = not checked;

			local new_color = if checked then Color3.fromRGB(66, 155, 251) else Color3.fromRGB(47, 47, 47)

			change_save(new_color)
			tween_property(TextButton, {BackgroundColor3 = new_color}, 0.5)

			if call_back then
				call_back(checked, ...)
			end
		end)	


		local returns = 
			{
				_raw_section = Toggle,
			}

		function returns:change_state(state, call_callback)
			checked = state;

			local new_color = if checked then Color3.fromRGB(66, 155, 251) else Color3.fromRGB(47, 47, 47)

			change_save(new_color)
			tween_property(TextButton, {BackgroundColor3 = new_color}, 0.5)

			if call_callback then
				call_back(checked)
			end
		end

		function returns:get_state()
			return checked;
		end

		function returns:change_callback(new_callback)
			local old = call_back
			call_back = new_callback;
			return old;
		end

		return returns;
	end

	local function add_button(container, text, call_back, options)
		local Button = Instance.new("Frame")
		local TextButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")

		Button.Name = "Button"
		Button.Parent = container
		Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Button.BackgroundTransparency = 1.000
		Button.Position = UDim2.new(0, 0, 0.201342285, 0)
		Button.Size = UDim2.new(1.00000012, 0, 0, 20);

		TextButton.Parent = Button
		TextButton.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
		TextButton.BorderColor3 = Color3.fromRGB(30, 30, 30)
		TextButton.BorderSizePixel = 0
		TextButton.Position = UDim2.new(0, 20, 0, 0)
		TextButton.Size = UDim2.new(1, -40, 1, 0)
		TextButton.AutoButtonColor = false
		TextButton.Font = Enum.Font.SourceSansBold
		TextButton.Text = text
		TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton.TextSize = 14.000
		TextButton.RichText = true;

		UICorner.Parent = TextButton

		animate_button(TextButton, Color3.fromRGB(80,80,80));

		TextButton.MouseButton1Down:Connect(function(...)
			if call_back then
				call_back(...)
			end
		end)

		local returns = 
			{
				_raw_section = Button,
			}

		function returns:change_callback(new_callback)
			local old = call_back
			call_back = new_callback;
			return old;
		end

		return returns
	end
	local function add_textbox(container, text, call_back, options)
		local TextBox = Instance.new("Frame")
		local TextBox_2 = Instance.new("TextBox")
		local UICorner = Instance.new("UICorner")
		local SectionTitle = Instance.new("TextLabel")

		TextBox.Name = "TextBox"
		TextBox.Parent = container
		TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BackgroundTransparency = 1.000
		TextBox.Position = UDim2.new(0, 0, 0.201342285, 0)
		TextBox.Size = UDim2.new(1.00000012, 0, 0, 20)

		TextBox_2.Parent = TextBox
		TextBox_2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		TextBox_2.Position = UDim2.new(0.504510999, 0, 0.103999332, 0)
		TextBox_2.Size = UDim2.new(0.472488761, 0, 0, 20)
		TextBox_2.Font = Enum.Font.RobotoCondensed
		TextBox_2.PlaceholderText = "Enter Something..."
		TextBox_2.Text = ""
		TextBox_2.TextColor3 = Color3.fromRGB(200, 200, 200)
		TextBox_2.TextSize = 14.000
		TextBox_2.TextWrapped = true

		UICorner.Parent = TextBox_2

		SectionTitle.Name = "SectionTitle"
		SectionTitle.Parent = TextBox
		SectionTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		SectionTitle.BackgroundTransparency = 1.000
		SectionTitle.Position = UDim2.new(0.0309575722, 0, -0.000866699207, 0)
		SectionTitle.Size = UDim2.new(0.471285462, 0, 0, 25)
		SectionTitle.Font = Enum.Font.Roboto;
		SectionTitle.Text = text
		SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		SectionTitle.TextSize = 14.000
		SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

		animate_button(TextBox_2, Color3.fromRGB(80,80,80));

		TextBox_2.FocusLost:Connect(function(enter, ...)
			if enter and call_back then
				call_back(TextBox_2.Text, enter, ...)
			end
		end)

		TextBox_2.Changed:Connect(function()
			if #TextBox_2.Text >= 17 then
				TextBox_2.TextScaled = true
			else
				TextBox_2.TextScaled = false
			end 
		end)

		local returns = 
			{
				_raw_section = TextBox,
			}

		function returns:change_callback(new_callback)
			local old = call_back
			call_back = new_callback;
			return old;
		end

		return returns
	end
	local function add_label(container, text, options)
		local Label = Instance.new("Frame")
		local SectionTitle = Instance.new("TextLabel")

		Label.Name = "Label"
		Label.Parent = container
		Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Label.BackgroundTransparency = 1.000
		Label.Position = UDim2.new(0, 0, 0.201342285, 0)
		Label.Size = UDim2.new(1.00000012, 0, 0, 20)

		SectionTitle.Name = "SectionTitle"
		SectionTitle.Parent = Label
		SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SectionTitle.BackgroundTransparency = 1.000
		SectionTitle.Position = UDim2.new(0.0309575181, 0, -0.000866699207, 0)
		SectionTitle.Size = UDim2.new(0.942010283, 0, 0, 25)
		SectionTitle.Font = Enum.Font.SourceSansBold
		SectionTitle.Text = text
		SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		SectionTitle.TextSize = 14.000
		SectionTitle.TextWrapped = true
		SectionTitle.RichText = true;
		local returns = 
			{
				_raw_section = Label,
			}

		if options ~= nil then
			if options.no_animate then
				return returns;
			end
		end

		animate_label(SectionTitle);

		return returns;
	end

	local all_dropdowns = {}
	local function add_dropdown(container, text, items, call_back, default_index)
		local DropDown = Instance.new("Frame")
		local SectionTitle = Instance.new("TextLabel")
		local TextButton = Instance.new("TextButton")
		local ImageLabel = Instance.new("ImageButton")
		local UICorner = Instance.new("UICorner")

		--Properties:

		DropDown.Name = "DropDown"
		DropDown.Parent = container
		DropDown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		DropDown.BackgroundTransparency = 1.000
		DropDown.Position = UDim2.new(0, 0, 0.201342285, 0)
		DropDown.Size = UDim2.new(1.00000012, 0, 0, 20)

		SectionTitle.Name = "SectionTitle"
		SectionTitle.Parent = DropDown
		SectionTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		SectionTitle.BackgroundTransparency = 1.000
		SectionTitle.Position = UDim2.new(0.0309576616, 0, -0.000866699207, 0)
		SectionTitle.Size = UDim2.new(0.531552494, 0, 0, 25)
		SectionTitle.Font = Enum.Font.Roboto;
		SectionTitle.Text = text
		SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		SectionTitle.TextSize = 14.000
		SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
		SectionTitle.RichText = true;

		animate_label(SectionTitle);

		TextButton.Parent = DropDown
		TextButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		TextButton.Position = UDim2.new(0.591587305, 0, 0.103999332, 0)
		TextButton.Size = UDim2.new(0.385412335, 0, 0, 20)
		TextButton.AutoButtonColor = false
		TextButton.Font = Enum.Font.SourceSans
		TextButton.Text = ""
		TextButton.TextColor3 = Color3.fromRGB(200, 200, 200)
		TextButton.TextSize = 14.000
		TextButton.TextWrapped = true
		TextButton.TextXAlignment = Enum.TextXAlignment.Left

		ImageLabel.Parent = TextButton
		ImageLabel.AnchorPoint = Vector2.new(1, 0.100000001)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.Position = UDim2.new(0.557063043, 0, 0.253999323, 0)
		ImageLabel.Size = UDim2.new(0.117121845, 0, -0.5, 20)
		ImageLabel.Image = "rbxassetid://13787501336"

		UICorner.Parent = TextButton

		animate_button(TextButton, Color3.fromRGB(80,80,80));

		local function create_scrolling(container)
			local ScrollingFrame = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")

			ScrollingFrame.Parent = container
			ScrollingFrame.Active = true
			ScrollingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.Position = UDim2.new(0.00139268604, 0, 0.741610765, 0)
			ScrollingFrame.Size = UDim2.new(0.997214556, 0, 0.382550329, -35)
			ScrollingFrame.ScrollBarThickness = 5
			ScrollingFrame.Visible = false

			table.insert(all_dropdowns, { scroll = ScrollingFrame, label = ImageLabel } );

			UIListLayout.Parent = ScrollingFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
			end)


			local returns = 
				{
					_raw_section = ScrollingFrame,
				}

			function returns:add_toggle(title, callback, options)
				return add_toggle(self._raw_section, title, callback, options)
			end

			function returns:add_button(title, callback, options)
				return add_button(self._raw_section, title, callback, options)
			end

			function returns:add_textbox(title, callback, options)
				return add_textbox(self._raw_section, title, callback, options)
			end

			function returns:add_dropdown(title, items, call_back, default_index)
				return add_dropdown(self._raw_section, title, items, call_back, default_index)
			end

			function returns:add_label(title, options)
				return add_label(self._raw_section, title, options)
			end

			return returns;
		end

		local ret = create_scrolling(container);
		local ScrollingFrame = ret["_raw_section"]

		ret["_raw_dropdown"] = DropDown;

		local function manage_dropdown()
			ScrollingFrame.Visible = not ScrollingFrame.Visible;

			ImageLabel.Image = if ScrollingFrame.Visible then "rbxassetid://13787681128" else "rbxassetid://13787501336" 

			for i,v in pairs(all_dropdowns) do
				if v.scroll ~= ScrollingFrame then
					v.scroll.Visible = false;
					v.label.Image = "rbxassetid://13787501336";
				end
			end
		end

		TextButton.MouseButton1Down:Connect(manage_dropdown)
		ImageLabel.MouseButton1Down:Connect(manage_dropdown)

		if type(items) == "table" then	
			local SelectedItem = if default_index ~= nil then "Selected - "..items[default_index] else "";

			local SelectedLabel = ret:add_label(SelectedItem, { no_animate = true })["_raw_section"]["SectionTitle"];
			SelectedLabel.TextColor3 = Color3.fromRGB(26, 80, 161)

			for i,v in ipairs(items) do
				ret:add_button(v, function()
					SelectedItem = v;
					SelectedLabel.Text = "Selected - "..v;

					if(#SelectedLabel.Text > 25) then
						SelectedLabel.TextScaled = true
					end

					manage_dropdown();

					if call_back then
						call_back(v)
					end
				end)
			end
		end

		return ret
	end

	local function create_dual_section(body, section_name)
		local DualSection_Converted = 
			{
				["_DualSection"] = Instance.new("Frame");
				["_UICorner"] = Instance.new("UICorner");
				["_UIListLayout"] = Instance.new("UIListLayout");
				["_Script"] = Instance.new("Script");
				["_UIStroke"] = Instance.new("UIStroke");
				["_SectionTitle"] = Instance.new("TextLabel");
				["_Child_Container"] = Instance.new("Frame");
				["_Child_Container_UIListLayout"] = Instance.new("UIListLayout");
			}

		DualSection_Converted["_DualSection"].BackgroundColor3 = Color3.fromRGB(255, 170.0000050663948, 255)
		DualSection_Converted["_DualSection"].BackgroundTransparency = 1
		DualSection_Converted["_DualSection"].BorderSizePixel = 0
		DualSection_Converted["_DualSection"].Position = UDim2.new(0.00843677018, 0, 0.0708661452, 0)
		DualSection_Converted["_DualSection"].Size = UDim2.new(0.975687921, 0, -0.551181078, 415)
		DualSection_Converted["_DualSection"].Name = "DualSection"
		DualSection_Converted["_DualSection"].Parent = body

		DualSection_Converted["_UICorner"].CornerRadius = UDim.new(0, 2)
		DualSection_Converted["_UICorner"].Parent = DualSection_Converted["_DualSection"]

		DualSection_Converted["_SectionTitle"].Font = Enum.Font.SourceSansBold
		DualSection_Converted["_SectionTitle"].Text = section_name
		DualSection_Converted["_SectionTitle"].TextColor3 = Color3.fromRGB(255, 255, 255)
		DualSection_Converted["_SectionTitle"].TextSize = 18
		DualSection_Converted["_SectionTitle"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		DualSection_Converted["_SectionTitle"].BackgroundTransparency = 0
		DualSection_Converted["_SectionTitle"].Position = UDim2.new(0.00224300986, 0, 0.0158002395, 0)
		DualSection_Converted["_SectionTitle"].Size = UDim2.new(1, 0, 0, 25)
		DualSection_Converted["_SectionTitle"].Name = "SectionTitle"
		DualSection_Converted["_SectionTitle"].Parent = DualSection_Converted["_DualSection"]
		DualSection_Converted["_SectionTitle"].BorderColor3 = Color3.fromRGB(47.0000009983778, 47.0000009983778, 47.0000009983778)

		animate_label(DualSection_Converted["_SectionTitle"]);

		DualSection_Converted["_UIListLayout"].Padding = UDim.new(0, 5)
		DualSection_Converted["_UIListLayout"].HorizontalAlignment = Enum.HorizontalAlignment.Center
		DualSection_Converted["_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
		DualSection_Converted["_UIListLayout"].Parent = DualSection_Converted["_DualSection"]

		DualSection_Converted["_Script"].Parent = DualSection_Converted["_DualSection"]

		DualSection_Converted["_UIStroke"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		DualSection_Converted["_UIStroke"].Color = Color3.fromRGB(47.0000009983778, 47.0000009983778, 47.0000009983778)
		DualSection_Converted["_UIStroke"].LineJoinMode = Enum.LineJoinMode.Bevel
		DualSection_Converted["_UIStroke"].Parent = DualSection_Converted["_DualSection"]

		DualSection_Converted["_Child_Container"].Name = "Container"
		DualSection_Converted["_Child_Container"].Parent = DualSection_Converted["_DualSection"]
		DualSection_Converted["_Child_Container"].BackgroundColor3 = Color3.fromRGB(85, 255, 127)
		DualSection_Converted["_Child_Container"].BackgroundTransparency = 1.000
		DualSection_Converted["_Child_Container"].Position = UDim2.new(-1.17203562e-07, 0, 0.222222224, 0)
		DualSection_Converted["_Child_Container"].Size = UDim2.new(1.00000024, 0, 0, 375)

		DualSection_Converted["_Child_Container_UIListLayout"].Parent = DualSection_Converted["_Child_Container"]
		DualSection_Converted["_Child_Container_UIListLayout"].FillDirection = Enum.FillDirection.Horizontal
		DualSection_Converted["_Child_Container_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder

		local function make_section()
			local section_data = 
				{
					["_Child_Container_Section_Section1"] = Instance.new("Frame");
					["_Child_Container_Section_UIListLayout"] = Instance.new("UIListLayout");
				}

			section_data["_Child_Container_Section_Section1"].BackgroundColor3 = Color3.fromRGB(30.00000011175871, 30.00000011175871, 30.00000011175871)
			section_data["_Child_Container_Section_Section1"].BackgroundTransparency = 1
			section_data["_Child_Container_Section_Section1"].BorderColor3 = Color3.fromRGB(47.0000009983778, 47.0000009983778, 47.0000009983778)
			section_data["_Child_Container_Section_Section1"].BorderMode = Enum.BorderMode.Middle
			section_data["_Child_Container_Section_Section1"].Position = UDim2.new(0.620344639, 0, 0.0708661452, 0)
			section_data["_Child_Container_Section_Section1"].Size = UDim2.new(0.5, 0, 0, 149)
			section_data["_Child_Container_Section_Section1"].Name = "Section"
			section_data["_Child_Container_Section_Section1"].Parent = DualSection_Converted["_Child_Container"]

			section_data["_Child_Container_Section_UIListLayout"].Padding = UDim.new(0, 10)
			section_data["_Child_Container_Section_UIListLayout"].HorizontalAlignment = Enum.HorizontalAlignment.Center
			section_data["_Child_Container_Section_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
			section_data["_Child_Container_Section_UIListLayout"].Parent = section_data["_Child_Container_Section_Section1"]

			coroutine.wrap(function()
				local script = Instance.new('Script', section_data["_Child_Container_Section_Section1"])

				local Section = script.Parent;
				local ListLayout = Section["UIListLayout"]

				Section.Size = UDim2.new(0.5, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)

				ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					Section.Size = UDim2.new(0.5, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
				end)
			end)()

			local returns = 
				{
					_raw_section = section_data["_Child_Container_Section_Section1"],
				}

			function returns:add_toggle(title, callback, options)
				return add_toggle(self._raw_section, title, callback, options)
			end

			function returns:add_button(title, callback, options)
				return add_button(self._raw_section, title, callback, options)
			end

			function returns:add_textbox(title, callback, options)
				return add_textbox(self._raw_section, title, callback, options)
			end

			function returns:add_dropdown(title, items, call_back, default_index)
				return add_dropdown(self._raw_section, title, items, call_back, default_index)
			end

			function returns:add_label(title, options)
				return add_label(self._raw_section, title, options)
			end

			return returns;
		end

		coroutine.wrap(function()
			local script = Instance.new('Script', DualSection_Converted["_Child_Container"])

			local Section = script.Parent;
			local ListLayout = Section["UIListLayout"]

			Section.Size = UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y)

			ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y)
			end)
		end)()


		coroutine.wrap(function()
			local script = Instance.new('Script', DualSection_Converted["_DualSection"])

			local Section = script.Parent;
			local ListLayout = Section["UIListLayout"]

			Section.Size = UDim2.new(0.983, 0, 0, ListLayout.AbsoluteContentSize.Y)

			ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(0.983, 0, 0, ListLayout.AbsoluteContentSize.Y)
			end)
		end)()

		return 
			{
				make_section(),
				make_section()
			}
	end

	local function create_section(body, section_name)
		local DualSection_Converted = 
			{
				["_DualSection"] = Instance.new("Frame");
				["_UICorner"] = Instance.new("UICorner");
				["_UIListLayout"] = Instance.new("UIListLayout");
				["_Script"] = Instance.new("Script");
				["_UIStroke"] = Instance.new("UIStroke");
				["_SectionTitle"] = Instance.new("TextLabel");
				["_Child_Container"] = Instance.new("Frame");
				["_Child_Container_UIListLayout"] = Instance.new("UIListLayout");
			}

		DualSection_Converted["_DualSection"].BackgroundColor3 = Color3.fromRGB(255, 170.0000050663948, 255)
		DualSection_Converted["_DualSection"].BackgroundTransparency = 1
		DualSection_Converted["_DualSection"].BorderSizePixel = 0
		DualSection_Converted["_DualSection"].Position = UDim2.new(0.00843677018, 0, 0.0708661452, 0)
		DualSection_Converted["_DualSection"].Size = UDim2.new(0.975687921, 0, -0.551181078, 415)
		DualSection_Converted["_DualSection"].Name = "DualSection"
		DualSection_Converted["_DualSection"].Parent = body

		DualSection_Converted["_UICorner"].CornerRadius = UDim.new(0, 2)
		DualSection_Converted["_UICorner"].Parent = DualSection_Converted["_DualSection"]

		DualSection_Converted["_SectionTitle"].Font = Enum.Font.SourceSansBold
		DualSection_Converted["_SectionTitle"].Text = section_name
		DualSection_Converted["_SectionTitle"].TextColor3 = Color3.fromRGB(255, 255, 255)
		DualSection_Converted["_SectionTitle"].TextSize = 18
		DualSection_Converted["_SectionTitle"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		DualSection_Converted["_SectionTitle"].BackgroundTransparency = 0
		DualSection_Converted["_SectionTitle"].Position = UDim2.new(0.00224300986, 0, 0.0158002395, 0)
		DualSection_Converted["_SectionTitle"].Size = UDim2.new(1, 0, 0, 25)
		DualSection_Converted["_SectionTitle"].Name = "SectionTitle"
		DualSection_Converted["_SectionTitle"].Parent = DualSection_Converted["_DualSection"]
		DualSection_Converted["_SectionTitle"].BorderColor3 = Color3.fromRGB(47.0000009983778, 47.0000009983778, 47.0000009983778)

		animate_label(DualSection_Converted["_SectionTitle"]);

		DualSection_Converted["_UIListLayout"].Padding = UDim.new(0, 5)
		DualSection_Converted["_UIListLayout"].HorizontalAlignment = Enum.HorizontalAlignment.Center
		DualSection_Converted["_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
		DualSection_Converted["_UIListLayout"].Parent = DualSection_Converted["_DualSection"]

		DualSection_Converted["_Script"].Parent = DualSection_Converted["_DualSection"]

		DualSection_Converted["_UIStroke"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		DualSection_Converted["_UIStroke"].Color = Color3.fromRGB(47.0000009983778, 47.0000009983778, 47.0000009983778)
		DualSection_Converted["_UIStroke"].LineJoinMode = Enum.LineJoinMode.Bevel
		DualSection_Converted["_UIStroke"].Parent = DualSection_Converted["_DualSection"]

		DualSection_Converted["_Child_Container"].Name = "Container"
		DualSection_Converted["_Child_Container"].Parent = DualSection_Converted["_DualSection"]
		DualSection_Converted["_Child_Container"].BackgroundColor3 = Color3.fromRGB(85, 255, 127)
		DualSection_Converted["_Child_Container"].BackgroundTransparency = 1.000
		DualSection_Converted["_Child_Container"].Position = UDim2.new(-1.17203562e-07, 0, 0.222222224, 0)
		DualSection_Converted["_Child_Container"].Size = UDim2.new(1.00000024, 0, 0, 375)

		DualSection_Converted["_Child_Container_UIListLayout"].Padding = UDim.new(0, 10)
		DualSection_Converted["_Child_Container_UIListLayout"].HorizontalAlignment = Enum.HorizontalAlignment.Center
		DualSection_Converted["_Child_Container_UIListLayout"].SortOrder = Enum.SortOrder.LayoutOrder
		DualSection_Converted["_Child_Container_UIListLayout"].Parent = DualSection_Converted["_Child_Container"]

		local returns = 
			{
				_raw_section = DualSection_Converted["_Child_Container"],
			}

		function returns:add_toggle(title, callback, options)
			return add_toggle(self._raw_section, title, callback, options)
		end

		function returns:add_button(title, callback, options)
			return add_button(self._raw_section, title, callback, options)
		end

		function returns:add_textbox(title, callback, options)
			return add_textbox(self._raw_section, title, callback, options)
		end

		function returns:add_dropdown(title, items, call_back, default_index)
			return add_dropdown(self._raw_section, title, items, call_back, default_index)
		end

		function returns:add_label(title)
			return add_label(self._raw_section, title)
		end

		coroutine.wrap(function()
			local script = Instance.new('Script', DualSection_Converted["_Child_Container"])

			local Section = script.Parent;
			local ListLayout = Section["UIListLayout"]

			Section.Size = UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)

			ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(1, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
			end)
		end)()


		coroutine.wrap(function()
			local script = Instance.new('Script', DualSection_Converted["_DualSection"])

			local Section = script.Parent;
			local ListLayout = Section["UIListLayout"]

			Section.Size = UDim2.new(0.983, 0, 0, ListLayout.AbsoluteContentSize.Y)

			ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section.Size = UDim2.new(0.983, 0, 0, ListLayout.AbsoluteContentSize.Y)
			end)
		end)()

		return returns;
	end

	local returns = {}

	function returns:create_tab(tab_name)
		local Body = create_tab_item(tab_name);

		local returns = 
			{
				_raw_section = Body,
			}

		function returns:create_dual_section(...)
			return create_dual_section(Body, ...)
		end

		function returns:create_section(...)
			return create_section(Body, ...)
		end

		return returns
	end

	return returns
end


local ui = library:create_ui("Project WD");

-- CREDITS TAB

local credits = ui:create_tab("Credits")
local section = credits:create_section("Credits");


section:add_label("Project WD made by W41K3R")
section:add_label("Project WD is apart of the Fluxus Script Program!")

section:add_button("Copy Discord", function()
    setclipboard("https://discord.gg/projectwd")
end)

-- AUTO FARM TAB

local autofarm = ui:create_tab("Auto Farms")
local dual_section = autofarm:create_dual_section("Auto Farms")
local section_a = dual_section[1]
local section_b = dual_section[2]

section_a:add_label("Main Farms")
section_b:add_label("Misc Farms")

section_a:add_toggle("Super Farm(Kick)", function(toggled)
    warn(toggled)
end)

section_a:add_toggle("Normal Farm", function(toggled)
    warn(toggled)
end)

section_a:add_dropdown("Select Mode", {"example item", "example item 2"}, function(selected)

end)

section_a:add_dropdown("Select Area", {"example item", "example item 2"}, function(selected)

end)

section_a:add_dropdown("Select Area (Optional)", {"example item", "example item 2"}, function(selected)

end)

section_a:add_toggle("Chest Farm", function(toggled)
    warn(toggled)
end)

section_a:add_dropdown("Select Chest", {"example item", "example item 2"}, function(selected)

end)

section_a:add_dropdown("Hacker Portal Farm", {"example item", "example item 2"}, function(selected)

end)

section_a:add_dropdown("Diamond Sniper", {"example item", "example item 2"}, function(selected)
warn(selected)
end)

section_b:add_toggle("<font family=\"rbxasset://fonts/families/Roboto.json\" style=\"Normal\" weight=\"400\" color=\"rgb(255,255,255)\" transparency=\"0\">3x Server Damage </font><font family=\"rbxasset://fonts/families/Roboto.json\" style=\"Italic\" weight=\"700\" color=\"rgb(192, 79, 79)\" transparency=\"0\">Boost</font>", function(toggled)
    warn(toggled)
end)

section_b:add_toggle("<font family=\"rbxasset://fonts/families/Roboto.json\" style=\"Normal\" weight=\"400\" color=\"rgb(255,255,255)\" transparency=\"0\">3x Server Damage </font><font family=\"rbxasset://fonts/families/Roboto.json\" style=\"Italic\" weight=\"700\" color=\"rgb(81,146,243)\" transparency=\"0\">Boost</font>", function(toggled)
    warn(toggled)
end)

section_b:add_toggle("Instant Collect", function(toggled)
    warn(toggled)
end)

section_b:add_toggle("Collect Gifts", function(toggled)
    warn(toggled)
end)

section_b:add_toggle("Collect Lootbags", function(toggled)
    warn(toggled)
end)

section_b:add_toggle("No Lag", function(toggled)
    warn(toggled)
end, {toggled = true})
