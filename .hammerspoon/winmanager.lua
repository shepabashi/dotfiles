-- global settings
hs.window.animationDuration = 0
offset = {top=0, bottom=0, left=0, right=0, gap=1}

-- mode
-- 0: single app mode
-- 1: original mode
mode = 1

-- applications settings
xApps = {
    'Alfred 3',
    'Finder',
    'Hammerspoon',
    'System Preferences',
    'VirtualBox',
    'VMware Fusion',
}

xTitles = {
    '',
    'Open',
}

-- show
winFilter = hs.window.filter.new(nil, nil, 'debug')
winFilter:setCurrentSpace(true)
winFilter:subscribe(hs.window.filter.windowFocused, function(win, app)
    if mode == 1 then return end
    if not win:isStandard() then return end
    for i=1, #xApps do
        if app == xApps[i] then return end
    end
    for i=1, #xTitles do
        if win:title() == xTitles[i] then return end
    end
    toFull()
end)

function toCenter(win)
    win = win or hs.window.focusedWindow()
    if win == nil then return end
    win:centerOnScreen(nil, true)
end

function toFull(win)
    win = win or hs.window.focusedWindow()
    if win == nil then return end
    local max = hs.screen.mainScreen():frame()
    win:setFrame({
        offset.left,
        offset.top,
        max.w - offset.left - offset.right,
        max.h - offset.top - offset.bottom
    })
    mode = 0
end

function toLeftSide(win)
    win = win or hs.window.focusedWindow()
    if win == nil then return end
    local max = hs.screen.mainScreen():frame()
    win:setFrame({
        offset.left,
        offset.top,
        max.w/2 - offset.left - offset.gap/2,
        max.h - offset.top - offset.bottom
    })
    mode = 1
end

function toRightSide(win)
    win = win or hs.window.focusedWindow()
    if win == nil then return end
    local max = hs.screen.mainScreen():frame()
    win:setFrame({
        max.w/2 + offset.gap/2,
        offset.top,
        max.w/2 - offset.right - offset.gap/2,
        max.h - offset.top - offset.bottom
    })
    mode = 1
end

function disableSingleAppMode()
    mode = 1
end

---- switcher
function getWinInfo()
    local c = hs.window.focusedWindow()
    local cid = c and c:id() or nil
    local rs = {
        windows = {},
        current = c,
        currentID = cid,
    }
    local wins = hs.window.visibleWindows()
    if mode ~= 0 then
        table.sort(wins, function(a, b)
            return a:frame().x < b:frame().x
        end)
    end
    for i=1, #wins do
        local win = wins[i]
        local idx = #rs.windows+1
        if cid == win:id() then
            rs.currentIdx = idx
            rs.windows[idx] = win
        elseif win:isStandard() then
            rs.windows[idx] = win
        end
    end
    return rs
end

function showAlert(str)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    if boxTimer ~= nil then boxTimer:fire() end
    if mode == 0 then return end
    box = hs.drawing.rectangle(hs.geometry.rect(f.x + f.w - 15, f.y + 5, 10, 10))
    box:setFillColor{red = 0.1, green = 0.3, blue = 0.7, alpha = 1.0}
    box:setStrokeWidth(0)
    box:show()
    boxTimer = hs.timer.doAfter(1.0, function()
        box:delete()
        box = nil
    end)
end

hs.hotkey.bind({'alt'}, 'M', function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    hs.alert.show(f.x)
    hs.alert.show(f.y)
    hs.alert.show(f.w)
    hs.alert.show(f.h)
end)

function focusLeftWindow()
    local w = getWinInfo()
    local idx
    if w.currentIdx == nil then idx = 1
    else
        idx = (w.currentIdx-2) % (#w.windows) + 1
    end
    w.windows[idx]:focus()
    showAlert()
end

function focusRightWindow()
    local w = getWinInfo()
    local idx
    if w.currentIdx == nil then idx = 1
    else
        idx =(w.currentIdx) % (#w.windows) + 1
    end
    w.windows[idx]:focus()
    showAlert()
end

function focusApp(appInfo)
    local app = hs.application.find(appInfo)
    if app == nil then
        hs.application.open(appInfo)
        return
    end
    local mainWin = app:mainWindow()
    if mainWin ~= nil and not app:isHidden() then
        app:activate(true)
        return
    end
    local wins = app:allWindows()
    if #wins == 1 then
        local w = wins[1]
        if w:isMinimized() then
            w:unminimize()
        end
        w:focus()
    end
end

-- bind
hs.hotkey.bind({'alt'}, 'A', toFull)
hs.hotkey.bind({'alt'}, 'S', disableSingleAppMode)
hs.hotkey.bind({'alt'}, 'C', toCenter)

hs.hotkey.bind({'ctrl', 'alt'}, 'H', toLeftSide)
hs.hotkey.bind({'ctrl', 'alt'}, 'L', toRightSide)

hs.hotkey.bind({'alt'}, 'H', focusLeftWindow)
hs.hotkey.bind({'alt'}, 'L', focusRightWindow)

--

hs.hotkey.bind({'alt'}, 'E', function() focusApp('com.googlecode.iterm2') end)
hs.hotkey.bind({'alt'}, 'F', function() focusApp('com.vivaldi.Vivaldi') end)
hs.hotkey.bind({'alt'}, 'I', function() focusApp('com.jetbrains.intellij') end)
hs.hotkey.bind({'alt'}, 'O', function() focusApp('com.tinyspeck.slackmacgap') end)
hs.hotkey.bind({'alt'}, 'D', function() focusApp('com.kapeli.dashdoc') end)
