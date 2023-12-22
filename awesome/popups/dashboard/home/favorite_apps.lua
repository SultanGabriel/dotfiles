--Standard Modules
local awful          = require("awful")
local wibox          = require("wibox")
local gears          = require("gears")
local beautiful      = require("beautiful")
local dpi            = beautiful.xresources.apply_dpi

--Custom Modules
local color          = require("popups.color")
local user           = require("popups.user_profile")
local icon_path      = user.icon_theme_path

-----------------------
--Header text----------
-----------------------

local create_textbox = function(font, text, fg_color)
    local textbox = wibox.widget {
        markup = '<span color="' ..
            fg_color .. '" font="' .. font .. '">' .. text .. '</span>',
        widget = wibox.widget.textbox,
    }
    return textbox
end

local header         = create_textbox("Ubuntu nerd font bold 12",
    "¯¯̿̿¯̿̿'̿̿̿̿̿̿̿'̿̿'̿̿̿̿̿'̿̿̿)͇̿̿)̿̿̿̿ '̿̿̿̿̿̿\\̵͇̿̿\\=(•̪̀●́)=o/̵͇̿̿/'̿̿ ̿ ̿̿", color.magenta)

local create_button  = function(icon, launch_app, mleft, mright, mtop, mbottom)
    local button = wibox.widget {
        {
            {
                widget = wibox.widget.imagebox,
                image = os.getenv("HOME") .. icon_path .. icon,
                resize = true,
                opacity = 1,
            },
            left   = dpi(mleft),
            right  = dpi(mright),
            top    = dpi(mtop),
            bottom = dpi(mbottom),
            widget = wibox.container.margin
        },
        bg = color.background_dark,
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background,
        forced_height = dpi(64),
        forced_width = dpi(64),
    }

    --Open app on click
    button:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            awful.spawn.with_shell(launch_app)
        end
    end)


    --Hover highlight effects
    button:connect_signal("mouse::enter", function()
        button.bg = color.background_lighter
    end)

    button:connect_signal("mouse::leave", function()
        button.bg = color.background_dark
    end)

    button:connect_signal("button::press", function()
        button.bg = color.background_morelight
    end)

    button:connect_signal("button::release", function()
        button.bg = color.background_lighter
    end)

    return button
end

local container      = wibox.widget {
    header,
    spacing = dpi(0),
    layout = wibox.layout.fixed.vertical,
    forced_height = dpi(540)
}

local apps           = {
    firefox = create_button('firefox.svg', 'firefox', 1, 1, 3, 3),
    vokoscreenNG = create_button('vokoscreenNG.svg', 'vokoscreenNG', 3, 3, 3, 3),
    discord = create_button('discord.svg', "flatpak run com.discordapp.Discord", 1, 1, 1, 1),
    gimp = create_button('gimp.svg', 'gimp', 1, 1, 3, 3),
    kitty = create_button('kitty.svg', 'kitty', 1, 1, 3, 3),
    only_office = create_button('onlyoffice-desktopeditors.svg', 'flatpak run org.onlyoffice.desktopeditors', 2, 2, 3, 3),
    telegram = create_button('telegram.svg', 'telegram-desktop', 1, 1, 1, 1),
    wezterm = create_button('terminal.svg', 'wezterm', 2, 2, 3, 3),
    alacritty = create_button('terminal.svg', 'alacritty', 2, 2, 3, 3),
    unity = create_button('unityhub.svg', 'unityhub', 1, 1, 1, 1),
    keepassxc = create_button('keepassxc.svg', 'keepassxc', 1, 1, 2, 2),
    gpick = create_button('gpick.svg', 'gpick', 4, 0, 4, 4),
    vscode = create_button('visual-studio-code.svg', 'code', 1, 1, 1, 1),
    androidStudio = create_button('androidstudio.svg', 'alacritty', 1, 1, 1, 1),
}


-- local final_widget = wibox.widget {
--     { { header,
--         apps.firefox,
--         apps.discord,
--         apps.gimp,
--         apps.alacritty,
--         apps.unity,
--         apps.vscode,

--         widget = wibox.container.margin,
--         top = dpi(2),
--         bottom = dpi(2),
--         left = dpi(2),
--         right = dpi(2), }, widget = wibox.container.background,
--         bg = color.background_lighter,
--     },

-- }

local app_container = {
    create_button('firefox.svg', 'firefox', 1, 1, 3, 3),
    create_button('vokoscreenNG.svg', 'vokoscreenNG', 3, 3, 3, 3),
    create_button('discord.svg', "flatpak run com.discordapp.Discord", 1, 1, 1, 1),
    create_button('gimp.svg', 'gimp', 1, 1, 3, 3),
    create_button('kitty.svg', 'kitty', 1, 1, 3, 3),
    create_button('onlyoffice-desktopeditors.svg', 'flatpak run org.onlyoffice.desktopeditors', 2, 2, 3, 3),
    create_button('telegram.svg', 'telegram-desktop', 1, 1, 1, 1),
    create_button('terminal.svg', 'alacritty', 2, 2, 3, 3),
    create_button('unityhub.svg', 'unityhub', 1, 1, 1, 1),
    create_button('keepassxc.svg', 'keepassxc', 1, 1, 2, 2),
    create_button('gpick.svg', 'gpick', 4, 0, 4, 4),
    create_button('visual-studio-code.svg', 'code', 1, 1, 1, 1),
    create_button('androidstudio.svg', 'alacritty', 1, 1, 1, 1),

    forced_width = 450,
    layout = wibox.layout.flex.vertical,
    spacing = dpi(5),
    -- forced_height = dpi(250)
}

local final_widget = wibox.widget {
    header,
    app_container,
    layout = wibox.layout.fixed.vertical,
}
--        widget = wibox.container.background,
        --bg = color.background_lighter,


return final_widget
