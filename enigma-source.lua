if getgenv().loaded then
    getgenv().library:unload_menu()
end

getgenv().loaded = true

local uis = game.GetService(game, 'UserInputService')
local players = game.GetService(game, 'Players')
local ws = game.GetService(game, 'Workspace')
local rs = game.GetService(game, 'ReplicatedStorage')
local http_service = game.GetService(game, 'HttpService')
local gui_service = game.GetService(game, 'GuiService')
local lighting = game.GetService(game, 'Lighting')
local run = game.GetService(game, 'RunService')
local stats = game.GetService(game, 'Stats')
local coregui = game.GetService(game, 'CoreGui')
local debris = game.GetService(game, 'Debris')
local tween_service = game.GetService(game, 'TweenService')
local sound_service = game.GetService(game, 'SoundService')
local vec2 = Vector2.new
local vec3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new
local rect = Rect.new
local cfr = CFrame.new
local empty_cfr = cfr()
local point_object_space = empty_cfr.PointToObjectSpace
local angle = CFrame.Angles
local dim_offset = UDim2.fromOffset
local color = Color3.new
local rgb = Color3.fromRGB
local hex = Color3.fromHex
local hsv = Color3.fromHSV
local rgbseq = ColorSequence.new
local rgbkey = ColorSequenceKeypoint.new
local numseq = NumberSequence.new
local numkey = NumberSequenceKeypoint.new
local camera = ws.CurrentCamera
local lp = players.LocalPlayer
local mouse = lp.GetMouse(lp)
local gui_offset = gui_service.GetGuiInset(gui_service).Y
local max = math.max
local floor = math.floor
local min = math.min
local abs = math.abs
local noise = math.noise
local rad = math.rad
local random = math.random
local pow = math.pow
local sin = math.sin
local pi = math.pi
local tan = math.tan
local atan2 = math.atan2
local clamp = math.clamp
local insert = table.insert
local find = table.find
local remove = table.remove
local concat = table.concat

getgenv().library = {
    directory = getgenv().NameOfScriptForDirectory or "Script",
    folders = {
        '/fonts',
        '/configs',
    },
    flags = {},
    config_flags = {},
    connections = {},
    notifications = {},
    playerlist_data = {
        players = {},
        player = {},
    },
    colorpicker_open = false,
    gui,
}

local themes = {
    preset = {
        outline = rgb(10, 10, 10),
        inline = rgb(35, 35, 35),
        text = rgb(180, 180, 180),
        text_outline = rgb(0, 0, 0),
        background = rgb(20, 20, 20),
        ['1'] = hex('#711E24'),
        ['2'] = hex('#631F21'),
        ['3'] = hex('#531F1E'),
    },
    utility = {
        inline = {BackgroundColor3 = {}},
        text = {TextColor3 = {}},
        text_outline = {Color = {}},
        ['1'] = {
            BackgroundColor3 = {},
            TextColor3 = {},
            ImageColor3 = {},
            ScrollBarImageColor3 = {},
        },
        ['2'] = {
            BackgroundColor3 = {},
            TextColor3 = {},
            ImageColor3 = {},
            ScrollBarImageColor3 = {},
        },
        ['3'] = {
            BackgroundColor3 = {},
            TextColor3 = {},
            ImageColor3 = {},
            ScrollBarImageColor3 = {},
        },
    },
}
local keys = {
    [Enum.KeyCode.LeftShift] = 'LS',
    [Enum.KeyCode.RightShift] = 'RS',
    [Enum.KeyCode.LeftControl] = 'LC',
    [Enum.KeyCode.RightControl] = 'RC',
    [Enum.KeyCode.Insert] = 'INS',
    [Enum.KeyCode.Backspace] = 'BS',
    [Enum.KeyCode.Return] = 'Ent',
    [Enum.KeyCode.LeftAlt] = 'LA',
    [Enum.KeyCode.RightAlt] = 'RA',
    [Enum.KeyCode.CapsLock] = 'CAPS',
    [Enum.KeyCode.One] = '1',
    [Enum.KeyCode.Two] = '2',
    [Enum.KeyCode.Three] = '3',
    [Enum.KeyCode.Four] = '4',
    [Enum.KeyCode.Five] = '5',
    [Enum.KeyCode.Six] = '6',
    [Enum.KeyCode.Seven] = '7',
    [Enum.KeyCode.Eight] = '8',
    [Enum.KeyCode.Nine] = '9',
    [Enum.KeyCode.Zero] = '0',
    [Enum.KeyCode.KeypadOne] = 'Num1',
    [Enum.KeyCode.KeypadTwo] = 'Num2',
    [Enum.KeyCode.KeypadThree] = 'Num3',
    [Enum.KeyCode.KeypadFour] = 'Num4',
    [Enum.KeyCode.KeypadFive] = 'Num5',
    [Enum.KeyCode.KeypadSix] = 'Num6',
    [Enum.KeyCode.KeypadSeven] = 'Num7',
    [Enum.KeyCode.KeypadEight] = 'Num8',
    [Enum.KeyCode.KeypadNine] = 'Num9',
    [Enum.KeyCode.KeypadZero] = 'Num0',
    [Enum.KeyCode.Minus] = '-',
    [Enum.KeyCode.Equals] = '=',
    [Enum.KeyCode.Tilde] = '~',
    [Enum.KeyCode.LeftBracket] = '[',
    [Enum.KeyCode.RightBracket] = ']',
    [Enum.KeyCode.RightParenthesis] = ')',
    [Enum.KeyCode.LeftParenthesis] = '(',
    [Enum.KeyCode.Semicolon] = ',',
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = '\\',
    [Enum.KeyCode.Comma] = ',',
    [Enum.KeyCode.Period] = '.',
    [Enum.KeyCode.Slash] = '/',
    [Enum.KeyCode.Asterisk] = '*',
    [Enum.KeyCode.Plus] = '+',
    [Enum.KeyCode.Period] = '.',
    [Enum.KeyCode.Backquote] = '`',
    [Enum.UserInputType.MouseButton1] = 'MB1',
    [Enum.UserInputType.MouseButton2] = 'MB2',
    [Enum.UserInputType.MouseButton3] = 'MB3',
    [Enum.KeyCode.Escape] = 'ESC',
    [Enum.KeyCode.Space] = 'SPC',
}

library.__index = library

for _, path in next, library.folders do
    makefolder(library.directory .. path)
end

local flags = library.flags
local config_flags = library.config_flags
local fonts = {}

do
    Register_Font = function(Name, Weight, Style, Asset)
        if not isfile(Asset.Id) then
            writefile(Asset.Id, Asset.Font)
        end
        if isfile(Name .. '.font') then
            delfile(Name .. '.font')
        end

        local Data = {
            name = Name,
            faces = {
                {
                    name = 'Regular',
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Asset.Id),
                },
            },
        }

        writefile(Name .. '.font', game.GetService(game, 'HttpService'):JSONEncode(Data))

        return getcustomasset(Name .. '.font')
    end

    local ProggyTiny = Register_Font('ProggyTiny', 200, 'Normal', {
        Id = 'ProggyTiny.ttf',
        Font = game.HttpGet(game, 
[[https://github.com/barbarianTopG/enigma/raw/refs/heads/main/tahoma_bold.ttf]]),
    })
    local ProggyClean = Register_Font('ProggyClean', 200, 'normal', {
        Id = 'ProggyClean.ttf',
        Font = game.HttpGet(game, 
[[https://github.com/barbarianTopG/enigma/raw/refs/heads/main/ProggyClean.ttf]]),
    })

    fonts = {
        TahomaBold = Font.new(ProggyTiny, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        ProggyClean = Font.new(ProggyClean, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    }
end

library.tween = function(self, obj, properties)
    local tween = tween_service.Create(tween_service, obj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()

    return tween
end
library.close_current_element = function(self, cfg)
    local path = library.current_element_open

    if path then
        path.set_visible(false)

        path.open = false
    end
end
library.resizify = function(self, frame)
    local Frame = Instance.new('TextButton')

    Frame.Position = dim2(1, -10, 1, -10)
    Frame.BorderColor3 = rgb(0, 0, 0)
    Frame.Size = dim2(0, 10, 0, 10)
    Frame.BorderSizePixel = 0
    Frame.BackgroundColor3 = rgb(255, 255, 255)
    Frame.Parent = frame
    Frame.BackgroundTransparency = 1
    Frame.Text = ''

    local resizing = false
    local start_size
    local start
    local og_size = frame.Size

    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            start = input.Position
            start_size = frame.Size
        end
    end)
    Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    library.connection(library, uis.InputChanged, function(input, game_event)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local viewport_x = camera.ViewportSize.X
            local viewport_y = camera.ViewportSize.Y
            local current_size = dim2(start_size.X.Scale, math.clamp(start_size.X.Offset + (input.Position.X - start.X), og_size.X.Offset, viewport_x), start_size.Y.Scale, math.clamp(start_size.Y.Offset + (input.Position.Y - start.Y), og_size.Y.Offset, viewport_y))

            frame.Size = current_size
        end
    end)
end
library.mouse_in_frame = function(self, uiobject)
    local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
    local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

    return (y_cond and x_cond)
end
library.lerp = function(start, finish, t)
    t = t or 0.125

    return start * (1 - t) + finish * t
end
library.draggify = function(self, frame)
    local dragging = false
    local start_size = frame.Position
    local start

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            start_size = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    library.connection(library, uis.InputChanged, function(input, game_event)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local viewport_x = camera.ViewportSize.X
            local viewport_y = camera.ViewportSize.Y
            local current_position = dim2(0, clamp(start_size.X.Offset + (input.Position.X - start.X), 0, viewport_x - frame.Size.X.Offset), 0, math.clamp(start_size.Y.Offset + (input.Position.Y - start.Y), 0, viewport_y - frame.Size.Y.Offset))

            frame.Position = current_position
        end
    end)
end
library.convert = function(self, str)
    local values = {}

    for value in string.gmatch(str, '[^,]+')do
        insert(values, tonumber(value))
    end

    if #values == 4 then
        return unpack(values)
    else
        return
    end
end
library.convert_enum = function(self, enum)
    local enum_parts = {}

    for part in string.gmatch(enum, '[%w_]+')do
        insert(enum_parts, part)
    end

    local enum_table = Enum

    for i = 2, #enum_parts do
        local enum_item = enum_table[enum_parts[i] ]

        enum_table = enum_item
    end

    return enum_table
end

local config_holder

library.update_config_list = function(self)
    if not config_holder then
        return
    end

    local list = {}

    for idx, file in listfiles(library.directory .. '/configs')do
        local name = file.gsub(file, library.directory .. '/configs\\', ''):gsub('.cfg', ''):gsub(library.directory .. '\\configs\\', '')

        list[#list + 1] = name
    end

    config_holder.refresh_options(list)
end
library.get_config = function(self)
    local Config = {}

    for _, v in flags do
        if type(v) == 'table' and v.key then
            Config[_] = {
                active = v.active,
                mode = v.mode,
                key = tostring(v.key),
            }
        elseif type(v) == 'table' and v.Transparency and v.Color then
            Config[_] = {
                Transparency = v.Transparency,
                Color = v.Color:ToHex(),
            }
        else
            Config[_] = v
        end
    end

    return http_service.JSONEncode(http_service, Config)
end
library.load_config = function(self, config_json)
    local config = http_service.JSONDecode(http_service, config_json)

    for _, v in next, config do
        local __DARKLUA_CONTINUE_7 = false

        repeat
            local function_set = library.config_flags[_]

            if _ == 'config_name_list' then
                __DARKLUA_CONTINUE_7 = true

                break
            end
            if function_set then
                if type(v) == 'table' and v.Transparency and v.Color then
                    function_set(hex(v.Color), v.Transparency)
                elseif type(v) == 'table' and v.active then
                    function_set(v)
                else
                    function_set(v)
                end
            end

            __DARKLUA_CONTINUE_7 = true
        until true

        if not __DARKLUA_CONTINUE_7 then
            break
        end
    end
end
library.round = function(self, number, float)
    local multiplier = 1 / (float or 1)

    return floor(number * multiplier + 0.5) / multiplier
end
library.apply_theme = function(self, instance, theme, property)
    insert(themes.utility[theme][property], instance)
end
library.update_theme = function(self, theme, color)
    for _, property in themes.utility[theme]do
        for m, object in property do
            if object[_] == themes.preset[theme] then
                object[_] = color
            end
        end
    end

    themes.preset[theme] = color
end
library.connection = function(self, signal, callback)
    local connection = signal.Connect(signal, callback)

    insert(library.connections, connection)

    return connection
end
library.apply_stroke = function(self, parent)
    local STROKE = library.create(library, 'UIStroke', {
        Parent = parent,
        Color = themes.preset.text_outline,
        LineJoinMode = Enum.LineJoinMode.Miter,
    })

    library.apply_theme(library, STROKE, 'text_outline', 'Color')
end
library.create = function(self, instance, options)
    local ins = Instance.new(instance)

    for prop, value in next, options do
        ins[prop] = value
    end

    if instance == 'TextLabel' or instance == 'TextButton' or instance == 'TextBox' then
        library.apply_theme(library, ins, 'text', 'TextColor3')
        library.apply_stroke(library, ins)
    end

    return ins
end
library.unload_menu = function(self)
    if library.gui then
        library.gui:Destroy()
    end

    for index, connection in next, library.connections do
        connection.Disconnect(connection)

        connection = nil
    end

    if library.sgui then
        library.sgui:Destroy()
    end

    library = nil
end
library.window = function(self, properties)
    local cfg = {
        name = properties.name or properties.Name or 'someone.else',
        size = properties.size or properties.Size or dim2(0, 460, 0, 362),
        selected_tab,
    }

    library.gui = library.create(library, 'ScreenGui', {
        Parent = coregui,
        Name = '\0',
        Enabled = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })

    local window_outline = library.create(library, 'Frame', {
        Parent = library.gui,
        Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = cfg.size,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    window_outline.Position = dim2(0, window_outline.AbsolutePosition.Y, 0, window_outline.AbsolutePosition.Y)
    cfg.main_outline = window_outline

    library.resizify(library, window_outline)
    library.draggify(library, window_outline)

    local title_holder = library.create(library, 'Frame', {
        Parent = window_outline,
        BackgroundTransparency = 0.800000011920929,
        Position = dim2(0, 2, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -4, 0, 20),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0),
    })
    local ui_title = library.create(library, 'TextLabel', {
        FontFace = fonts.TahomaBold,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = title_holder,
        BackgroundTransparency = 1,
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.gradient = library.create(library, 'UIGradient', {
        Color = rgbseq{
            rgbkey(0, themes.preset['1']),
            rgbkey(0.5, themes.preset['2']),
            rgbkey(1, themes.preset['3']),
        },
        Parent = window_outline,
    })

    local tab_button_holder = library.create(library, 'Frame', {
        AnchorPoint = vec2(0, 1),
        Parent = window_outline,
        BackgroundTransparency = 0.800000011920929,
        Position = dim2(0, 2, 1, -2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -4, 0, 20),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0),
    })

    cfg.tab_button_holder = tab_button_holder

    library.create(library, 'UIListLayout', {
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Parent = tab_button_holder,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalFlex = Enum.UIFlexAlignment.Fill,
    })

    return setmetatable(cfg, library)
end

local menu_open = true

uis.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
        menu_open = not menu_open

        if library.gui then
            library.gui.Enabled = menu_open
        end
    end
end)

library.tab = function(self, properties)
    local cfg = {
        name = properties.name or 'visuals',
        count = 0,
    }
    local tab_button = library.create(library, 'TextButton', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(170, 170, 170),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = self.tab_button_holder,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local Page = library.create(library, 'Frame', {
        Parent = self.main_outline,
        BackgroundTransparency = 0.6,
        Position = dim2(0, 2, 0, 24),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -4, 1, -48),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0),
        Visible = false,
    })

    cfg.page = Page

    library.create(library, 'UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalFlex = Enum.UIFlexAlignment.Fill,
        Parent = Page,
        Padding = dim(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalFlex = Enum.UIFlexAlignment.Fill,
    })
    library.create(library, 'UIPadding', {
        PaddingTop = dim(0, 2),
        PaddingBottom = dim(0, 2),
        Parent = Page,
        PaddingRight = dim(0, 2),
        PaddingLeft = dim(0, 2),
    })

    cfg.open_tab = function()
        local selected_tab = self.selected_tab

        if selected_tab then
            selected_tab[1].Visible = false
            selected_tab[2].TextColor3 = rgb(170, 170, 170)
            selected_tab = nil
        end

        Page.Visible = true
        tab_button.TextColor3 = rgb(255, 255, 255)
        self.selected_tab = {Page, tab_button}
    end

    tab_button.MouseButton1Down:Connect(function()
        cfg.open_tab()
    end)

    if not self.selected_tab then
        cfg.open_tab(true)
    end

    return setmetatable(cfg, library)
end

local notifications = {notifs = {}}

library.sgui = library.create(library, 'ScreenGui', {
    Name = 'Hi',
    Parent = gethui(),
})
notifications.refresh_notifs = function(self)
    for i, v in notifications.notifs do
        local Position = vec2(50, 50)

        tween_service.Create(tween_service, v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Position = dim_offset(Position.X, Position.Y + (i * 30)),
        }):Play()
    end
end
notifications.fade = function(self, path, is_fading)
    local fading = is_fading and 1 or 0

    tween_service.Create(tween_service, path, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = fading}):Play()

    for _, instance in path.GetDescendants(path)do
        local __DARKLUA_CONTINUE_13 = false

        repeat
            if not instance.IsA(instance, 'GuiObject') then
                if instance.IsA(instance, 'UIStroke') then
                    tween_service.Create(tween_service, instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = fading}):Play()
                end

                __DARKLUA_CONTINUE_13 = true

                break
            end
            if instance.IsA(instance, 'TextLabel') then
                tween_service.Create(tween_service, instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = fading}):Play()
            elseif instance.IsA(instance, 'Frame') then
                tween_service.Create(tween_service, instance, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                    BackgroundTransparency = instance.Transparency and 0.6 and is_fading and 1 or 0.6,
                }):Play()
            end

            __DARKLUA_CONTINUE_13 = true
        until true

        if not __DARKLUA_CONTINUE_13 then
            break
        end
    end
end
notifications.create_notification = function(self, options)
    local cfg = {
        name = options.name or 'Im Notification',
        outline,
    }
    local outline = library.create(library, 'Frame', {
        Parent = library.sgui,
        Position = dim_offset(-50, 50 + (#notifications.notifs * 30)),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 24),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local dark = library.create(library, 'Frame', {
        Parent = outline,
        BackgroundTransparency = 1,
        Position = dim2(0, 2, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -4, 1, -4),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0),
    })

    library.create(library, 'UIPadding', {
        PaddingTop = dim(0, 7),
        PaddingBottom = dim(0, 6),
        Parent = dark,
        PaddingRight = dim(0, 7),
        PaddingLeft = dim(0, 4),
    })
    library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = dark,
        Size = dim2(0, 0, 1, 0),
        Position = dim2(0, 1, 0, -1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    library.create(library, 'UIGradient', {
        Color = rgbseq{
            rgbkey(0, themes.preset['1']),
            rgbkey(0.5, themes.preset['2']),
            rgbkey(1, themes.preset['3']),
        },
        Parent = outline,
    })

    local index = #notifications.notifs + 1

    notifications.notifs[index] = outline

    notifications.refresh_notifs(notifications)
    tween_service.Create(tween_service, outline, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        AnchorPoint = vec2(0, 0),
    }):Play()
    notifications.fade(notifications, outline, false)
    task.spawn(function()
        task.wait(3)

        notifications.notifs[index] = nil

        notifications.fade(notifications, outline, true)
        task.wait(3)
        outline.Destroy(outline)
    end)
end
library.watermark = function(self, options)
    local cfg = {
        name = options.name or 'nebulahax',
    }
    local outline = library.create(library, 'Frame', {
        Parent = library.sgui,
        Position = dim2(0, 50, 0, 50),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 0, 0, 24),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.watermark_outline = outline

    library.draggify(library, outline)

    local dark = library.create(library, 'Frame', {
        Parent = outline,
        BackgroundTransparency = 0.6,
        Position = dim2(0, 2, 0, 2),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -4, 1, -4),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0),
    })

    library.create(library, 'UIPadding', {
        PaddingTop = dim(0, 7),
        PaddingBottom = dim(0, 6),
        Parent = dark,
        PaddingRight = dim(0, 7),
        PaddingLeft = dim(0, 4),
    })

    local text_title = library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = dark,
        Size = dim2(0, 0, 1, 0),
        Position = dim2(0, 1, 0, -1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.create(library, 'UIGradient', {
        Color = rgbseq{
            rgbkey(0, themes.preset['1']),
            rgbkey(0.5, themes.preset['2']),
            rgbkey(1, themes.preset['3']),
        },
        Parent = outline,
    })

    cfg.update_text = function(text)
        text_title.Text = text
    end

    cfg.update_text(cfg.name)

    return setmetatable(cfg, library)
end

local watermark = library.watermark(library, {
    name = 'someone.else - 100 fps - 100 ping',
})
local fps = 0
local watermark_delay = tick()

run.RenderStepped:Connect(function()
    fps = fps + 1

    if tick() - watermark_delay > 1 then
        watermark_delay = tick()

        local ping = math.floor(stats.PerformanceStats.Ping:GetValue()) .. 'ms'

        watermark.update_text(string.format('someone.else - fps: %s - ping: %s', fps, ping))

        fps = 0
    end
end)

library.column = function(self, properties)
    self.count = self.count + 1

    local cfg = {
        color = library.gradient.Color.Keypoints[self.count].Value,
        count = self.count,
    }
    local scrolling_frame = library.create(library, 'ScrollingFrame', {
        ScrollBarImageColor3 = rgb(0, 0, 0),
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        Parent = self.page,
        LayoutOrder = -1,
        BackgroundTransparency = 1,
        ScrollBarImageTransparency = 1,
        BorderColor3 = rgb(0, 0, 0),
        BackgroundColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        CanvasSize = dim2(0, 0, 0, 0),
    })

    cfg.column = scrolling_frame

    library.create(library, 'UIListLayout', {
        Parent = scrolling_frame,
        Padding = dim(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    return setmetatable(cfg, library)
end
library.section = function(self, properties)
    local cfg = {
        name = properties.name or properties.Name or 'section',
        size = properties.size or 1,
        autofill = properties.auto_fill or false,
        count = self.count,
        color = self.color,
    }
    local accent = library.create(library, 'Frame', {
        Parent = self.column,
        ClipsDescendants = true,
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, fill, tostring(self.count), 'BackgroundColor3')

    local dark = library.create(library, 'Frame', {
        Parent = accent,
        BackgroundTransparency = 0.6,
        Position = dim2(0, 2, 0, 16),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -4, 1, -18),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0),
    })
    local elements = library.create(library, 'Frame', {
        Parent = dark,
        Position = dim2(0, 4, 0, 5),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -8, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    cfg.elements = elements

    if cfg.autofill == false then
        elements.AutomaticSize = Enum.AutomaticSize.Y
        accent.AutomaticSize = Enum.AutomaticSize.Y
        accent.Size = dim2(1, 0, 0, 0)

        local UIPadding = library.create(library, 'UIPadding', {
            Parent = elements,
            Name = '',
            PaddingBottom = dim(0, 7),
        })
    else
        accent.Size = dim2(1, 0, cfg.size, 0)
    end

    library.create(library, 'UIListLayout', {
        Parent = elements,
        Padding = dim(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local title = library.create(library, 'TextLabel', {
        FontFace = fonts.TahomaBold,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = accent,
        Size = dim2(1, 0, 0, 0),
        Position = dim2(0, 4, 0, 2),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.create(library, 'UIListLayout', {
        Parent = ScrollingFrame,
        Padding = dim(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    return setmetatable(cfg, library)
end
library.toggle = function(self, options)
    local cfg = {
        enabled = options.enabled or nil,
        name = options.name or 'Toggle',
        flag = options.flag or tostring(random(1, 9999999)),
        default = options.default or false,
        folding = options.folding or false,
        callback = options.callback or function() end,
        color = self.color,
        count = self.count,
    }
    local toggle = library.create(library, 'TextButton', {
        Parent = self.elements,
        BackgroundTransparency = 1,
        Text = '',
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 12),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = toggle,
        Size = dim2(1, 0, 1, 0),
        Position = dim2(0, 1, 0, -1),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    local accent = library.create(library, 'Frame', {
        AnchorPoint = vec2(1, 0),
        Parent = toggle,
        Position = dim2(1, 0, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 12, 0, 12),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, accent, tostring(self.count), 'BackgroundColor3')

    local fill = library.create(library, 'Frame', {
        Parent = accent,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, fill, tostring(self.count), 'BackgroundColor3')
    library.create(library, 'UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = right_components,
        Padding = dim(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    local elements

    if cfg.folding then
        elements = library.create(library, 'Frame', {
            Parent = self.elements,
            BackgroundTransparency = 1,
            Position = dim2(0, 4, 0, 21),
            Size = dim2(1, 0, 0, 0),
            BorderSizePixel = 0,
            Visible = false,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        cfg.elements = elements

        library.create(library, 'UIListLayout', {
            Parent = elements,
            Padding = dim(0, 6),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
    end

    cfg.set = function(bool)
        fill.BackgroundColor3 = bool and themes.preset[tostring(self.count)] or themes.preset.inline
        flags[cfg.flag] = bool

        cfg.callback(bool)

        if cfg.folding then
            elements.Visible = bool
        end
    end

    cfg.set(cfg.default)

    config_flags[cfg.flag] = cfg.set

    toggle.MouseButton1Click:Connect(function()
        cfg.enabled = not cfg.enabled

        cfg.set(cfg.enabled)
    end)

    return setmetatable(cfg, library)
end
library.list = function(self, options)
    local cfg = {
        callback = options and options.callback or function() end,
        name = options.name or nil,
        scale = options.size or 90,
        items = options.items or {
            '1',
            '2',
            '3',
        },
        visible = options.visible or true,
        option_instances = {},
        current_instance = nil,
        flag = options.flag or 'SET A FLAG U NIGGER',
    }
    local accent = library.create(library, 'Frame', {
        BorderColor3 = rgb(0, 0, 0),
        AnchorPoint = vec2(1, 0),
        Parent = self.elements,
        Position = dim2(1, 0, 0, 0),
        Size = dim2(1, 0, 0, cfg.scale),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, accent, tostring(self.count), 'BackgroundColor3')

    local inline = library.create(library, 'Frame', {
        Parent = accent,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(35, 35, 35),
    })

    library.apply_theme(library, inline, 'inline', 'BackgroundColor3')

    local scrollingframe = library.create(library, 'ScrollingFrame', {
        ScrollBarImageColor3 = rgb(0, 0, 0),
        Active = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        Parent = inline,
        Size = dim2(1, 0, 1, 0),
        LayoutOrder = -1,
        BackgroundTransparency = 1,
        ScrollBarImageTransparency = 1,
        BorderColor3 = rgb(0, 0, 0),
        BackgroundColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        CanvasSize = dim2(0, 0, 0, 0),
    })

    library.create(library, 'UIListLayout', {
        Parent = scrollingframe,
        Padding = dim(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    library.create(library, 'UIPadding', {
        PaddingTop = dim(0, 2),
        PaddingBottom = dim(0, 4),
        Parent = scrollingframe,
        PaddingRight = dim(0, 5),
        PaddingLeft = dim(0, 5),
    })

    cfg.render_option = function(text)
        local text = library.create(library, 'TextButton', {
            FontFace = fonts.ProggyClean,
            TextColor3 = rgb(170, 170, 170),
            BorderColor3 = rgb(0, 0, 0),
            Text = text,
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Parent = scrollingframe,
            BorderSizePixel = 0,
            Size = dim2(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        return text
    end
    cfg.refresh_options = function(options)
        for _, v in cfg.option_instances do
            v.Destroy(v)
        end
        for _, option in next, options do
            local button = cfg.render_option(option)

            insert(cfg.option_instances, button)
            button.MouseButton1Click:Connect(function()
                if cfg.current_instance and cfg.current_instance ~= button then
                    cfg.current_instance.TextColor3 = rgb(170, 170, 170)
                end

                cfg.current_instance = button
                button.TextColor3 = rgb(255, 255, 255)
                flags[cfg.flag] = button.text

                cfg.callback(button.text)
            end)
        end
    end
    cfg.filter_options = function(text)
        for _, v in next, cfg.option_instances do
            if string.find(v.Text, text) then
                v.Visible = true
            else
                v.Visible = false
            end
        end
    end
    cfg.set = function(value)
        for _, buttons in next, cfg.option_instances do
            if buttons.Text == value then
                buttons.TextColor3 = rgb(255, 255, 255)
            else
                buttons.TextColor3 = rgb(170, 170, 170)
            end
        end

        flags[cfg.flag] = value

        cfg.callback(value)
    end

    cfg.refresh_options(cfg.items)

    return setmetatable(cfg, library)
end
library.slider = function(self, options)
    local cfg = {
        name = options.name or nil,
        suffix = options.suffix or '',
        flag = options.flag or tostring(3.2558664223046163E237),
        callback = options.callback or function() end,
        min = options.min or options.minimum or 0,
        max = options.max or options.maximum or 100,
        intervals = options.interval or options.decimal or 1,
        default = options.default or 10,
        value = options.default or 10,
        ignore = options.ignore or false,
        dragging = false,
    }
    local slider = library.create(library, 'Frame', {
        Parent = self.elements,
        BackgroundTransparency = 1,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 25),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local eeeee = library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        RichText = true,
        BorderColor3 = rgb(0, 0, 0),
        Text = 'max distance : 5000',
        Parent = slider,
        Size = dim2(1, 0, 0, 0),
        Position = dim2(0, 1, 0, -2),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.XY,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local outline = library.create(library, 'TextButton', {
        Parent = slider,
        Text = '',
        AutoButtonColor = false,
        Position = dim2(0, 0, 0, 13),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 12),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, outline, tostring(self.count), 'BackgroundColor3')

    local inline = library.create(library, 'Frame', {
        Parent = outline,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline,
    })

    library.apply_theme(library, outline, 'inline', 'BackgroundColor3')

    local accent = library.create(library, 'Frame', {
        Parent = inline,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0.5, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, accent, tostring(self.count), 'BackgroundColor3')

    cfg.set = function(value)
        local valuee = tonumber(value)

        if valuee == nil then
            return
        end

        cfg.value = clamp(library.round(library, valuee, cfg.intervals), cfg.min, cfg.max)
        accent.Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
        eeeee.Text = cfg.name .. "<font color='#AAAAAA'>" .. ' - ' .. tostring(cfg.value) .. cfg.suffix .. '</font>'
        flags[cfg.flag] = cfg.value

        cfg.callback(flags[cfg.flag])
    end

    cfg.set(cfg.default)
    outline.MouseButton1Down:Connect(function()
        cfg.dragging = true
    end)
    library.connection(library, uis.InputChanged, function(input)
        if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local size_x = (input.Position.X - inline.AbsolutePosition.X) / inline.AbsoluteSize.X
            local value = ((cfg.max - cfg.min) * size_x) + cfg.min

            cfg.set(value)
        end
    end)
    library.connection(library, uis.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            cfg.dragging = false
        end
    end)
    cfg.set(cfg.default)

    config_flags[cfg.flag] = cfg.set

    return setmetatable(cfg, library)
end
library.dropdown = function(self, options)
    local cfg = {
        name = options.name or nil,
        flag = options.flag or tostring(random(1, 9999999)),
        items = options.items or {
            '',
        },
        callback = options.callback or function() end,
        multi = options.multi or false,
        scrolling = options.scrolling or false,
        open = false,
        option_instances = {},
        multi_items = {},
        ignore = options.ignore or false,
    }

    cfg.default = options.default or (cfg.multi and {
        cfg.items[1],
    }) or cfg.items[1] or 'None'
    flags[cfg.flag] = {}

    local dropdown = library.create(library, 'Frame', {
        Parent = self.elements,
        BackgroundTransparency = 1,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 16),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local dropdown_holder = library.create(library, 'TextButton', {
        AnchorPoint = vec2(1, 0),
        AutoButtonColor = false,
        Text = '',
        Parent = dropdown,
        Position = dim2(1, 0, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0.5, 0, 0, 16),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, dropdown_holder, tostring(self.count), 'BackgroundColor3')

    local inline = library.create(library, 'Frame', {
        Parent = dropdown_holder,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(35, 35, 35),
    })
    local text = library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = inline,
        Size = dim2(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Position = dim2(0, 0, 0, 1),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local title = library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = dropdown,
        Size = dim2(1, 0, 1, 0),
        Position = dim2(0, 1, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local accent = library.create(library, 'Frame', {
        Parent = library.gui,
        Size = dim2(0.0907348021864891, 0, 0.006218905560672283, 20),
        Position = dim2(0, 500, 0, 100),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, accent, tostring(self.count), 'BackgroundColor3')

    local inline = library.create(library, 'Frame', {
        Parent = accent,
        Size = dim2(1, -2, 1, -2),
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = themes.preset.inline,
    })

    library.apply_theme(library, inline, 'inline', 'BackgroundColor3')
    library.create(library, 'UIListLayout', {
        Parent = inline,
        Padding = dim(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    library.create(library, 'UIPadding', {
        PaddingTop = dim(0, 5),
        PaddingBottom = dim(0, 2),
        Parent = inline,
        PaddingRight = dim(0, 6),
        PaddingLeft = dim(0, 6),
    })

    local padding = library.create(library, 'UIPadding', {
        PaddingBottom = dim(0, 2),
        Parent = accent,
    })

    cfg.render_option = function(text)
        local title = library.create(library, 'TextButton', {
            FontFace = fonts.ProggyClean,
            AutoButtonColor = false,
            TextColor3 = rgb(170, 170, 170),
            BorderColor3 = rgb(0, 0, 0),
            Text = text,
            Parent = inline,
            Size = dim2(1, 0, 0, 0),
            Position = dim2(0, 0, 0, 1),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        return title
    end
    cfg.set_visible = function(bool)
        accent.Visible = bool
    end
    cfg.set = function(value)
        local selected = {}
        local isTable = type(value) == 'table'

        if value == nil then
            return
        end

        for _, option in next, cfg.option_instances do
            if option.Text == value or (isTable and find(value, option.Text)) then
                insert(selected, option.Text)

                cfg.multi_items = selected
                option.TextColor3 = rgb(255, 255, 255)
            else
                option.TextColor3 = rgb(170, 170, 170)
            end
        end

        text.Text = if isTable then concat(selected, ', ')else selected[1]
        flags[cfg.flag] = if isTable then selected else selected[1]

        cfg.callback(flags[cfg.flag])
    end
    cfg.refresh_options = function(list)
        for _, option in next, cfg.option_instances do
            option.Destroy(option)
        end

        cfg.option_instances = {}

        for _, option in next, list do
            local button = cfg.render_option(option)

            insert(cfg.option_instances, button)
            button.MouseButton1Down:Connect(function()
                if cfg.multi then
                    local selected_index = find(cfg.multi_items, button.Text)

                    if selected_index then
                        remove(cfg.multi_items, selected_index)
                    else
                        insert(cfg.multi_items, button.Text)
                    end

                    cfg.set(cfg.multi_items)
                else
                    cfg.set_visible(false)

                    cfg.open = false

                    cfg.set(button.Text)
                end
            end)
        end
    end

    cfg.refresh_options(cfg.items)
    cfg.set(cfg.default)

    config_flags[cfg.flag] = cfg.set

    dropdown_holder.MouseButton1Click:Connect(function()
        cfg.open = not cfg.open
        accent.Size = dim2(0, dropdown_holder.AbsoluteSize.X, 0, accent.Size.Y.Offset)
        accent.Position = dim2(0, dropdown_holder.AbsolutePosition.X, 0, dropdown_holder.AbsolutePosition.Y + 77)

        cfg.set_visible(cfg.open)
    end)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not (library.mouse_in_frame(library, accent) or library.mouse_in_frame(library, dropdown)) then
                cfg.open = false

                cfg.set_visible(false)
            end
        end
    end)

    return setmetatable(cfg, library)
end
library.colorpicker = function(self, options)
    local cfg = {
        name = options.name or 'Color',
        flag = options.flag or tostring(3.2558664223046163E237),
        color = options.color or color(1, 1, 1),
        alpha = options.alpha and 1 - options.alpha or 0,
        open = false,
        callback = options.callback or function() end,
    }
    local colorpicker_element = library.create(library, 'TextButton', {
        Parent = self.elements,
        BackgroundTransparency = 1,
        Text = '',
        AutoButtonColor = false,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 12),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local accent = library.create(library, 'Frame', {
        AnchorPoint = vec2(1, 0),
        Parent = colorpicker_element,
        Position = dim2(1, 0, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 30, 0, 12),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, accent, tostring(self.count), 'BackgroundColor3')

    local colorpicker_element_color = library.create(library, 'Frame', {
        Parent = accent,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = colorpicker_element,
        Size = dim2(1, 0, 1, 0),
        Position = dim2(0, 1, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    local colorpicker = library.create(library, 'Frame', {
        Parent = library.gui,
        Position = dim2(0.6888179183006287, 0, 0.24751244485378265, 0),
        BorderColor3 = rgb(0, 0, 0),
        Visible = false,
        Size = dim2(0, 150, 0, 150),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, colorpicker, tostring(self.count), 'BackgroundColor3')

    local a = library.create(library, 'Frame', {
        Parent = colorpicker,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, a, tostring(self.count), 'BackgroundColor3')

    local e = library.create(library, 'Frame', {
        Parent = a,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0),
        BackgroundTransparency = 0.6,
        ZIndex = -1,
    })
    local _ = library.create(library, 'UIPadding', {
        PaddingTop = dim(0, 7),
        PaddingBottom = dim(0, -13),
        Parent = e,
        PaddingRight = dim(0, 6),
        PaddingLeft = dim(0, 7),
    })
    local textbox_holder = library.create(library, 'Frame', {
        Parent = e,
        Position = dim2(0, 0, 1, -36),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -1, 0, 16),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, textbox_holder, tostring(self.count), 'BackgroundColor3')

    local textbox = library.create(library, 'TextBox', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = '',
        Parent = textbox_holder,
        BackgroundTransparency = 0,
        ClearTextOnFocus = false,
        PlaceholderColor3 = rgb(255, 255, 255),
        Size = dim2(1, -2, 1, -2),
        Position = dim2(0, 1, 0, 1),
        BorderSizePixel = 0,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
        BackgroundColor3 = themes.preset.inline,
    })

    library.apply_theme(library, textbox, 'inline', 'BackgroundColor3')

    local hue_button = library.create(library, 'TextButton', {
        AnchorPoint = vec2(1, 0),
        Text = '',
        AutoButtonColor = false,
        Parent = e,
        Position = dim2(1, -1, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 14, 1, -60),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline,
    })

    library.apply_theme(library, hue_button, 'inline', 'BackgroundColor3')

    local hue_drag = library.create(library, 'Frame', {
        Parent = hue_button,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.create(library, 'UIGradient', {
        Rotation = 90,
        Parent = hue_drag,
        Color = rgbseq{
            rgbkey(0, rgb(255, 0, 0)),
            rgbkey(0.17, rgb(255, 255, 0)),
            rgbkey(0.33, rgb(0, 255, 0)),
            rgbkey(0.5, rgb(0, 255, 255)),
            rgbkey(0.67, rgb(0, 0, 255)),
            rgbkey(0.83, rgb(255, 0, 255)),
            rgbkey(1, rgb(255, 0, 0)),
        },
    })

    local hue_picker = library.create(library, 'Frame', {
        Parent = hue_drag,
        BorderMode = Enum.BorderMode.Inset,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 2, 0, 3),
        Position = dim2(0, -1, 0, -1),
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local alpha_button = library.create(library, 'TextButton', {
        AnchorPoint = vec2(0, 0.5),
        Text = '',
        AutoButtonColor = false,
        Parent = e,
        Position = dim2(0, 0, 1, -48),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -1, 0, 14),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline,
    })

    library.apply_theme(library, alpha_button, 'inline', 'BackgroundColor3')

    local alpha_color = library.create(library, 'Frame', {
        Parent = alpha_button,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 221, 255),
    })
    local alphaind = library.create(library, 'ImageLabel', {
        ScaleType = Enum.ScaleType.Tile,
        BorderColor3 = rgb(0, 0, 0),
        Parent = alpha_color,
        Image = 'rbxassetid://18274452449',
        BackgroundTransparency = 1,
        Size = dim2(1, 0, 1, 0),
        TileSize = dim2(0, 4, 0, 4),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.create(library, 'UIGradient', {
        Parent = alphaind,
        Transparency = numseq{
            numkey(0, 0),
            numkey(1, 1),
        },
    })

    local alpha_picker = library.create(library, 'Frame', {
        Parent = alpha_color,
        BorderMode = Enum.BorderMode.Inset,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 3, 1, 2),
        Position = dim2(0, -1, 0, -1),
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local saturation_value_button = library.create(library, 'TextButton', {
        Parent = e,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -20, 1, -60),
        Text = '',
        AutoButtonColor = false,
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline,
    })

    library.apply_theme(library, saturation_value_button, 'inline', 'BackgroundColor3')

    local colorpicker_color = library.create(library, 'Frame', {
        Parent = saturation_value_button,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 221, 255),
    })
    local val = library.create(library, 'TextButton', {
        Parent = colorpicker_color,
        Text = '',
        AutoButtonColor = false,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 1, 0),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.create(library, 'UIGradient', {
        Parent = val,
        Transparency = numseq{
            numkey(0, 0),
            numkey(1, 1),
        },
    })

    local saturation_value_picker = library.create(library, 'Frame', {
        Parent = colorpicker_color,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 3, 0, 3),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0),
    })
    local inline = library.create(library, 'Frame', {
        Parent = saturation_value_picker,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local saturation_button = library.create(library, 'TextButton', {
        Parent = colorpicker_color,
        Text = '',
        AutoButtonColor = false,
        Size = dim2(1, 0, 1, 0),
        BorderColor3 = rgb(0, 0, 0),
        ZIndex = 2,
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    library.create(library, 'UIGradient', {
        Rotation = 270,
        Transparency = numseq{
            numkey(0, 0),
            numkey(1, 1),
        },
        Parent = saturation_button,
        Color = rgbseq{
            rgbkey(0, rgb(0, 0, 0)),
            rgbkey(1, rgb(0, 0, 0)),
        },
    })

    local dragging_sat = false
    local dragging_hue = false
    local dragging_alpha = false
    local h, s, v = cfg.color:ToHSV()
    local a = cfg.alpha

    flags[cfg.flag] = {}
    cfg.set_visible = function(bool)
        colorpicker.Visible = bool
        colorpicker.Position = dim_offset(colorpicker_element_color.AbsolutePosition.X - 1, colorpicker_element_color.AbsolutePosition.Y + colorpicker_element_color.AbsoluteSize.Y + 65)
    end
    cfg.set = function(color, alpha)
        if color then
            h, s, v = color.ToHSV(color)
        end
        if alpha then
            a = alpha
        end

        local Color = Color3.fromHSV(h, s, v)

        hue_picker.Position = dim2(0, -1, 1 - h, -1)
        alpha_picker.Position = dim2(1 - a, -1, 0, -1)
        saturation_value_picker.Position = dim2(s, -1, 1 - v, -1)
        alpha_color.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        colorpicker_element_color.BackgroundColor3 = Color
        colorpicker_color.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        flags[cfg.flag] = {
            Color = Color,
            Transparency = a,
        }

        local color = colorpicker_element_color.BackgroundColor3

        textbox.Text = string.format('%s, %s, %s, ', library.round(library, color.R * 255), library.round(library, color.G * 255), library.round(library, color.B * 255))
        textbox.Text = textbox.Text .. library.round(library, 1 - a, 0.01)

        cfg.callback(Color, a)
    end
    cfg.update_color = function()
        local mouse = uis.GetMouseLocation(uis)
        local offset = vec2(mouse.X, mouse.Y - gui_offset)

        if dragging_sat then
            s = math.clamp((offset - saturation_value_button.AbsolutePosition).X / saturation_value_button.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp((offset - saturation_value_button.AbsolutePosition).Y / saturation_value_button.AbsoluteSize.Y, 0, 1)
        elseif dragging_hue then
            h = 1 - math.clamp((offset - hue_button.AbsolutePosition).Y / hue_button.AbsoluteSize.Y, 0, 1)
        elseif dragging_alpha then
            a = 1 - math.clamp((offset - alpha_button.AbsolutePosition).X / alpha_button.AbsoluteSize.X, 0, 1)
        end

        cfg.set(nil, nil)
    end

    cfg.set(cfg.color, cfg.alpha)

    config_flags[cfg.flag] = cfg.set

    colorpicker_element.MouseButton1Click:Connect(function()
        cfg.open = not cfg.open

        cfg.set_visible(cfg.open)
    end)
    uis.InputChanged:Connect(function(input)
        if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
            cfg.update_color()
        end
    end)
    library.connection(library, uis.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging_sat = false
            dragging_hue = false
            dragging_alpha = false

            if not (library.mouse_in_frame(library, colorpicker_element) or library.mouse_in_frame(library, colorpicker)) then
                cfg.open = false

                cfg.set_visible(false)
            end
        end
    end)
    alpha_button.MouseButton1Down:Connect(function()
        dragging_alpha = true
    end)
    hue_button.MouseButton1Down:Connect(function()
        dragging_hue = true
    end)
    saturation_button.MouseButton1Down:Connect(function()
        dragging_sat = true
    end)
    textbox.FocusLost:Connect(function()
        local r, g, b, a = library.convert(library, textbox.Text)

        if r and g and b and a then
            cfg.set(rgb(r, g, b), 1 - a)
        end
    end)

    return setmetatable(cfg, library)
end
library.textbox = function(self, options)
    local cfg = {
        name = options.name or '...',
        placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or 'type here...',
        default = options.default,
        flag = options.flag or 'SET ME NIGGA',
        callback = options.callback or function() end,
        visible = options.visible or true,
    }
    local frame = library.create(library, 'TextButton', {
        AnchorPoint = vec2(1, 0),
        Text = '',
        AutoButtonColor = false,
        Parent = self.elements,
        Position = dim2(1, 0, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 16),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, frame, tostring(self.count), 'BackgroundColor3')

    local frame_inline = library.create(library, 'Frame', {
        Parent = frame,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline,
    })

    library.apply_theme(library, frame_inline, 'inline', 'BackgroundColor3')

    local input = library.create(library, 'TextBox', {
        Parent = frame,
        Name = '',
        FontFace = fonts.ProggyClean,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextSize = 12,
        Size = dim2(1, -6, 1, 0),
        RichText = true,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        CursorPosition = -1,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = dim2(0, 6, 0, 0),
        BorderSizePixel = 0,
        PlaceholderColor3 = rgb(170, 170, 170),
    })

    cfg.set = function(text)
        flags[cfg.flag] = text
        input.Text = text

        cfg.callback(text)
    end
    config_flags[cfg.flag] = cfg.set

    if cfg.default then
        cfg.set(cfg.default)
    end

    input.GetPropertyChangedSignal(input, 'Text'):Connect(function()
        cfg.set(input.Text)
    end)

    return setmetatable(cfg, library)
end
library.keybind = function(self, options)
    local cfg = {
        flag = options.flag or 'SET ME A FLAG NOWWW!!!!',
        callback = options.callback or function() end,
        open = false,
        binding = nil,
        name = options.name or nil,
        ignore_key = options.ignore or false,
        key = options.key or nil,
        mode = options.mode or 'toggle',
        active = options.default or false,
        hold_instances = {},
    }

    flags[cfg.flag] = {}

    local keybind = library.create(library, 'Frame', {
        Parent = self.elements,
        BackgroundTransparency = 1,
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 16),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local keybind_holder = library.create(library, 'TextButton', {
        AnchorPoint = vec2(1, 0),
        AutoButtonColor = false,
        Text = '',
        Parent = keybind,
        Position = dim2(1, 0, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0.5, 0, 0, 16),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, accent, tostring(self.count), 'BackgroundColor3')

    local inline = library.create(library, 'Frame', {
        Parent = keybind_holder,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(35, 35, 35),
    })
    local text = library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = inline,
        Size = dim2(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Position = dim2(0, 0, 0, -1),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local title = library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = keybind,
        Size = dim2(1, 0, 1, 0),
        Position = dim2(0, 1, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })
    local accent = library.create(library, 'Frame', {
        Parent = library.gui,
        Visible = false,
        Size = dim2(0.0907348021864891, 0, 0.006218905560672283, 20),
        Position = dim2(0, 500, 0, 100),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, accent, tostring(self.count), 'BackgroundColor3')

    local inline = library.create(library, 'Frame', {
        Parent = accent,
        Size = dim2(1, -2, 1, -2),
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = themes.preset.inline,
    })

    library.apply_theme(library, inline, 'inline', 'BackgroundColor3')
    library.create(library, 'UIListLayout', {
        Parent = inline,
        Padding = dim(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    library.create(library, 'UIPadding', {
        PaddingTop = dim(0, 5),
        PaddingBottom = dim(0, 2),
        Parent = inline,
        PaddingRight = dim(0, 6),
        PaddingLeft = dim(0, 6),
    })

    local padding = library.create(library, 'UIPadding', {
        PaddingBottom = dim(0, 2),
        Parent = accent,
    })
    local options = {
        'Hold',
        'Toggle',
        'Always',
    }

    for _, v in options do
        local option = library.create(library, 'TextButton', {
            FontFace = fonts.ProggyClean,
            TextColor3 = rgb(170, 170, 170),
            BorderColor3 = rgb(0, 0, 0),
            Text = v,
            Parent = inline,
            Position = dim2(0, 0, 0, 1),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 12,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        cfg.hold_instances[v] = option

        option.MouseButton1Click:Connect(function()
            cfg.set(v)
            cfg.set_visible(false)

            cfg.open = false
        end)
    end

    cfg.modify_mode_color = function(path)
        for _, v in cfg.hold_instances do
            v.TextColor3 = rgb(170, 170, 170)
        end

        if cfg.hold_instances[path] then
            cfg.hold_instances[path].TextColor3 = rgb(255, 255, 255)
        end
    end
    cfg.set_mode = function(mode)
        cfg.mode = mode

        if mode == 'Always' then
            cfg.set(true)
        elseif mode == 'Hold' then
            cfg.set(false)
        end

        flags[cfg.flag].mode = mode

        cfg.modify_mode_color(mode)
    end
    cfg.set = function(input)
        if type(input) == 'boolean' then
            local __cached = input

            if cfg.mode == 'Always' then
                __cached = true
            end

            cfg.active = __cached

            cfg.callback(__cached)
        elseif tostring(input):find('Enum') then
            input = input.Name == 'Escape' and '...' or input
            cfg.key = input or '...'

            cfg.callback(cfg.active or false)
        elseif find({
            'Toggle',
            'Hold',
            'Always',
        }, input) then
            cfg.set_mode(input)

            if input == 'Always' then
                cfg.active = true
            end

            cfg.callback(cfg.active or false)
        elseif type(input) == 'table' then
            input.key = type(input.key) == 'string' and input.key ~= '...' and library.convert_enum(library, input.key) or input.key
            input.key = input.key == Enum.KeyCode.Escape and '...' or input.key
            cfg.key = input.key or '...'
            cfg.mode = input.mode or 'Toggle'

            cfg.set_mode(input.mode)

            if input.active then
                cfg.active = input.active
            end
        end

        flags[cfg.flag] = {
            mode = cfg.mode,
            key = cfg.key,
            active = cfg.active,
        }

        local _text = tostring(cfg.key) ~= 'Enums' and (keys[cfg.key] or tostring(cfg.key):gsub('Enum.', '')) or nil
        local __text = _text and (tostring(_text):gsub('KeyCode.', ''):gsub('UserInputType.', ''))

        text.Text = ' ' .. __text .. ' '
    end
    cfg.set_visible = function(bool)
        accent.Visible = bool
        accent.Size = dim2(0, keybind_holder.AbsoluteSize.X, 0, accent.Size.Y.Offset)
        accent.Position = dim2(0, keybind_holder.AbsolutePosition.X, 0, keybind_holder.AbsolutePosition.Y + 77)
    end

    keybind_holder.MouseButton1Down:Connect(function()
        task.wait()

        text.Text = '...'
        cfg.binding = library.connection(library, uis.InputBegan, function(
            keycode,
            game_event
        )
            cfg.set(keycode.KeyCode)
            cfg.binding:Disconnect()

            cfg.binding = nil
        end)
    end)
    keybind_holder.MouseButton2Down:Connect(function()
        cfg.open = not cfg.open

        cfg.set_visible(cfg.open)
    end)
    library.connection(library, uis.InputBegan, function(input, game_event)
        if not game_event then
            if input.KeyCode == cfg.key then
                if cfg.mode == 'Toggle' then
                    cfg.active = not cfg.active

                    cfg.set(cfg.active)
                elseif cfg.mode == 'Hold' then
                    cfg.set(true)
                end
            end
        end
    end)
    library.connection(library, uis.InputEnded, function(input, game_event)
        if game_event then
            return
        end

        local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

        if selected_key == cfg.key then
            if cfg.mode == 'Hold' then
                cfg.set(false)
            end
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not (library.mouse_in_frame(library, keybind_holder) or library.mouse_in_frame(library, accent)) then
                cfg.open = false

                cfg.set_visible(false)
            end
        end
    end)

    config_flags[cfg.flag] = cfg.set

    cfg.set({
        mode = cfg.mode,
        active = cfg.active,
        key = cfg.key,
    })

    return setmetatable(cfg, library)
end
library.button = function(self, options)
    local cfg = {
        name = options.name or 'button',
        callback = options.callback or function() end,
    }
    local frame = library.create(library, 'TextButton', {
        AnchorPoint = vec2(1, 0),
        Text = '',
        AutoButtonColor = false,
        Parent = self.elements,
        Position = dim2(1, 0, 0, 0),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, 0, 0, 16),
        BorderSizePixel = 0,
        BackgroundColor3 = self.color,
    })

    library.apply_theme(library, frame, tostring(self.count), 'BackgroundColor3')

    local frame_inline = library.create(library, 'Frame', {
        Parent = frame,
        Position = dim2(0, 1, 0, 1),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(1, -2, 1, -2),
        BorderSizePixel = 0,
        BackgroundColor3 = themes.preset.inline,
    })

    library.apply_theme(library, frame_inline, 'inline', 'BackgroundColor3')

    local text = library.create(library, 'TextLabel', {
        FontFace = fonts.ProggyClean,
        TextColor3 = rgb(255, 255, 255),
        BorderColor3 = rgb(0, 0, 0),
        Text = cfg.name,
        Parent = frame,
        Size = dim2(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Position = dim2(0, 1, 0, 1),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 12,
        BackgroundColor3 = rgb(255, 255, 255),
    })

    frame.MouseButton1Click:Connect(function()
        cfg.callback()
    end)

    return setmetatable(cfg, library)
end
