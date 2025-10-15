Enigma GUI Library Documentation (skidded ui from someone.else)

This document provides a comprehensive overview and API reference for the enigma GUI library, a powerful framework for creating interactive menus and interfaces within the Roblox engine.

Note: This library is designed for advanced scripting environments that provide access to functions like getgenv, makefolder, writefile, and getcustomasset. It will not work in a standard Roblox LocalScript.

Table of Contents

Overview & Core Concepts

Initialization

Container Elements

Window

Tab

Column

Section

Interface Widgets (Elements)

Toggle

Slider

Dropdown

List

Colorpicker

Keybind

Button

Textbox

Additional Systems

Configuration Management

Notifications

Watermark

Theming

Full Example

1. Overview & Core Concepts

This library provides a hierarchical system for building a complete graphical user interface. The structure is logical and nested:

Window -> Tab -> Column -> Section -> Widgets

getgenv().library: This is the global environment table where all library functions, state, and UI elements are stored.

Flags: The state of every interactive widget is stored in a table located at getgenv().library.flags. Each widget is assigned a unique flag (a string key), and its value is stored there (e.g., flags.aimbot_enabled = true). This is the foundation of the configuration system.

Callbacks: Most widgets accept a callback function that executes whenever the widget's value is changed by the user.

2. Initialization

To start, you must create a window. All other elements will be parented to this window.

code
Lua
download
content_copy
expand_less
-- Assuming the library code has been executed
local window = library:window({
    name = "My Awesome UI",
    size = UDim2.new(0, 500, 0, 400) -- UDim2.new(ScaleX, OffsetX, ScaleY, OffsetY)
})
**3. Container Elements

These elements are used to structure the layout of your UI.

Window

The main container for the entire UI. It is draggable and resizable by default.

Function: library:window(properties)

Properties:

name (string): The text displayed in the title bar.

size (UDim2): The initial size of the window.

Returns: A window object.

Tab

Tabs create separate pages within the window, allowing for better organization. A corresponding button is automatically created at the bottom of the window.

Function: window:tab(properties)

Properties:

name (string): The text displayed on the tab's button.

Returns: A tab object.

code
Lua
download
content_copy
expand_less
local main_tab = window:tab({ name = "Main" })
local visuals_tab = window:tab({ name = "Visuals" })
Column

Columns are vertical containers inside a tab. They allow you to arrange sections side-by-side.

Function: tab:column()

Returns: A column object.

code
Lua
download
content_copy
expand_less
-- Create two columns within the "Visuals" tab
local visuals_column1 = visuals_tab:column()
local visuals_column2 = visuals_tab:column()
Section

Sections are titled containers inside a column. This is where you will place the actual interactive widgets.

Function: column:section(properties)

Properties:

name (string): The title of the section.

Returns: A section object.

code
Lua
download
content_copy
expand_less
local player_esp_section = visuals_column1:section({ name = "Player ESP" })
4. Interface Widgets (Elements)

Widgets are the interactive elements your users will engage with. They are created inside section objects.

Toggle

A simple on/off checkbox.

Function: section:toggle(options)

Options:

name (string): The label for the toggle.

flag (string): Required. Unique identifier for storing its state.

default (boolean): The initial state (true for on, false for off). Defaults to false.

callback (function): Called with the new boolean state when changed. function(newState)

folding (boolean): If true, creates a collapsible area that is only visible when the toggle is on. New elements can be added to the returned toggle object.

Returns: A toggle object with a .set(bool) method.

code
Lua
download
content_copy
expand_less
local esp_toggle = player_esp_section:toggle({
    name = "Enable ESP",
    flag = "player_esp_enabled",
    default = true,
    callback = function(enabled)
        print("ESP is now:", enabled)
    end
})

-- To change its value via script:
esp_toggle:set(false)
Slider

A draggable slider for selecting a number within a range.

Function: section:slider(options)

Options:

name (string): The label for the slider.

flag (string): Required. Unique identifier.

min (number): The minimum value. Defaults to 0.

max (number): The maximum value. Defaults to 100.

default (number): The starting value.

interval (number): The step value. Use 0.1 for one decimal place, 1 for whole numbers. Defaults to 1.

suffix (string): Text to append to the value display (e.g., "m").

callback (function): Called with the new number when changed. function(newValue)

Returns: A slider object with a .set(number) method.

code
Lua
download
content_copy
expand_less
player_esp_section:slider({
    name = "Max Distance",
    flag = "player_esp_distance",
    min = 50,
    max = 2000,
    default = 500,
    suffix = "m",
    callback = function(distance)
        print("ESP distance set to:", distance)
    end
})
Dropdown

A dropdown menu for selecting one or more items.

Function: section:dropdown(options)

Options:

name (string): The label for the dropdown.

flag (string): Required. Unique identifier.

items (array of strings): The list of options to display.

default (string or array of strings): The pre-selected item(s).

multi (boolean): If true, allows selecting multiple items. Defaults to false.

callback (function): Called when the selection changes. Receives a string for single-select or an array of strings for multi-select.

Returns: A dropdown object with .set(value) and .refresh_options(list) methods.

code
Lua
download
content_copy
expand_less
player_esp_section:dropdown({
    name = "Target Part",
    flag = "esp_target_part",
    items = {"Head", "HumanoidRootPart", "Torso"},
    default = "HumanoidRootPart",
    callback = function(partName)
        print("Targeting:", partName)
    end
})
List

A scrollable list for selecting a single item. Useful for player lists.

Function: section:list(options)

Options:

flag (string): Required. Unique identifier.

items (array of strings): The list of options to display.

size (number): The vertical height of the list box in pixels. Defaults to 90.

callback (function): Called with the selected item's text (string).

Returns: A list object with .set(value), .refresh_options(list), and .filter_options(text) methods.

code
Lua
download
content_copy
expand_less
local player_list = some_section:list({
    flag = "selected_player",
    items = {"Player1", "Player2", "Player3"},
    callback = function(playerName)
        print(playerName, "was selected.")
    end
})

-- Update the list dynamically
player_list:refresh_options({"NewPlayerA", "NewPlayerB"})
Colorpicker

A complete color selection widget with hue, saturation, value, and alpha controls.

Function: section:colorpicker(options)

Options:

name (string): The label for the color picker.

flag (string): Required. Unique identifier.

color (Color3): The default color. Defaults to white.

alpha (number): The default transparency (0 = opaque, 1 = transparent). Defaults to 0.

callback (function): Called when the color changes. function(newColor, newAlpha)

Returns: A colorpicker object with a .set(Color3, alpha) method.

Flag Value: Stores a table: { Color = Color3, Transparency = number }

code
Lua
download
content_copy
expand_less
player_esp_section:colorpicker({
    name = "Box Color",
    flag = "esp_box_color",
    color = Color3.fromRGB(255, 0, 0),
    alpha = 0,
    callback = function(color, alpha)
        print("New color:", color, "Alpha:", 1 - alpha)
    end
})
Keybind

An element for setting a key or mouse button to trigger actions.

Function: section:keybind(options)

Options:

name (string): The label for the keybind.

flag (string): Required. Unique identifier.

key (Enum.KeyCode or Enum.UserInputType): The default key.

mode (string): "Toggle", "Hold", or "Always". Defaults to "Toggle".

callback (function): Called when the keybind's active state changes. function(isActive)

Returns: A keybind object.

Flag Value: Stores a table: { key = Enum, mode = string, active = boolean }

Usage: Left-click to set a new key. Right-click to change the mode.

code
Lua
download
content_copy
expand_less
some_section:keybind({
    name = "Toggle Fly",
    flag = "fly_keybind",
    key = Enum.KeyCode.F,
    mode = "Toggle",
    callback = function(isActive)
        -- Your fly script logic here
        print("Fly is active:", isActive)
    end
})
Button

A simple clickable button.

Function: section:button(options)

Options:

name (string): The text on the button.

callback (function): Called when the button is clicked.

Returns: A button object.

code
Lua
download
content_copy
expand_less
some_section:button({
    name = "Rejoin Server",
    callback = function()
        -- Rejoin logic
        print("Button clicked!")
    end
})
Textbox

A field for user text input.

Function: section:textbox(options)

Options:

flag (string): Required. Unique identifier.

placeholder (string): Text shown when the box is empty.

default (string): The initial text in the box.

callback (function): Called every time the text changes. function(newText)

Returns: A textbox object with a .set(text) method.

code
Lua
download
content_copy
expand_less
some_section:textbox({
    name = "Config Name",
    flag = "config_name_textbox",
    placeholder = "Enter config name...",
    callback = function(text)
        print("Textbox changed to:", text)
    end
})
5. Additional Systems
Configuration Management

The library has built-in functions to save and load the state of all widgets.

library:get_config(): Returns a JSON-encoded string of the current state of all flags.

library:load_config(config_json): Parses a JSON string and updates all UI elements to match the saved state.

code
Lua
download
content_copy
expand_less
-- Example: Saving a config
local config_data = library:get_config()
writefile("my_config.cfg", config_data)
notifications.create_notification({name = "Config saved!"})

-- Example: Loading a config
if isfile("my_config.cfg") then
    local config_data = readfile("my_config.cfg")
    library:load_config(config_data)
    notifications.create_notification({name = "Config loaded!"})
end
Notifications

Display temporary pop-up messages.

Function: notifications.create_notification(options)

Options:

name (string): The message to display.

code
Lua
download
content_copy
expand_less
notifications.create_notification({ name = "Welcome to the UI!" })
Watermark

The script automatically creates a watermark showing FPS and ping. You can also create your own.

Function: library:watermark(options)

Options:

name (string): The initial text to display.

Returns: A watermark object with an .update_text(text) method.

Theming

You can dynamically change the UI's theme colors.

Function: library:update_theme(theme_key, color)

theme_key (string): The key of the color to change. The primary accent colors are "1", "2", and "3". Other keys include outline, inline, text, etc.

color (Color3): The new color to apply.

code
Lua
download
content_copy
expand_less
-- Change the primary accent color to green
library:update_theme("1", Color3.new(0, 1, 0))
6. Full Example

Here is a script that ties many of these concepts together.

code
Lua
download
content_copy
expand_less
-- Wait for the library to be loaded if necessary
wait(0.1)

-- 1. Create the main window
local window = library:window({
    name = "My Roblox UI",
    size = UDim2.new(0, 560, 0, 420)
})

-- 2. Create Tabs
local combat_tab = window:tab({ name = "Combat" })
local visuals_tab = window:tab({ name = "Visuals" })
local utility_tab = window:tab({ name = "Utility" })

-- 3. Create Columns and Sections for the Visuals Tab
local esp_column = visuals_tab:column()
local world_column = visuals_tab:column()

local player_esp_section = esp_column:section({ name = "Player ESP" })
local world_esp_section = world_column:section({ name = "World ESP" })

-- 4. Add Widgets to the Sections
local esp_toggle = player_esp_section:toggle({
    name = "Enable ESP",
    flag = "visuals_esp_enabled",
    default = true,
    callback = function(state)
        print("ESP Enabled:", state)
    end,
    folding = true -- This makes it a foldable toggle
})

-- Add elements inside the foldable toggle
esp_toggle:slider({
    name = "Render Distance",
    flag = "visuals_esp_distance",
    min = 100,
    max = 5000,
    default = 1000,
    suffix = " studs"
})

esp_toggle:dropdown({
    name = "Box Style",
    flag = "visuals_esp_boxstyle",
    items = {"2D Box", "3D Box", "Corner Box"},
    default = "2D Box"
})

esp_toggle:colorpicker({
    name = "Visible Color",
    flag = "visuals_esp_color_visible",
    color = Color3.fromRGB(0, 255, 127)
})

-- 5. Add a button to the utility tab
local utility_section = utility_tab:column():section({name = "Actions"})
utility_section:button({
    name = "Save Config",
    callback = function()
        local config_content = library:get_config()
        writefile("my_ui_config.json", config_content)
        notifications.create_notification({name = "Config has been saved!"})
    end
})

utility_section:button({
    name = "Load Config",
    callback = function()
        if isfile("my_ui_config.json") then
            library:load_config(readfile("my_ui_config.json"))
            notifications.create_notification({name = "Config has been loaded!"})
        else
            notifications.create_notification({name = "No config file found!"})
        end
    end
})
