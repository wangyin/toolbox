--- === UnsplashRandom ===
---
--- Automatically sets a random Unsplash image as your wallpaper daily.
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/UnsplashRandom.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/UnsplashRandom.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "UnsplashRandom"
obj.version = "1.0"
obj.author = "Gautam Krishna R <r.gautamkrishna@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local function curl_callback(exitCode, stdOut, stdErr)
    if exitCode == 0 then
        obj.task = nil
        local allScreen = hs.screen.allScreens()
        for _, screen in ipairs(allScreen) do
          screen:desktopImageURL("file://" .. obj.localpath)
        end
    else
        print(stdOut, stdErr)
    end
end

local function unsplashRequest()
    if obj.task then
        obj.task:terminate()
        obj.task = nil
    end
    obj.localpath = os.getenv("HOME") .. "/.Trash/".. hs.hash.SHA1(hs.timer.absoluteTime()) .. ".jpg"
    -- local w = 0
    -- local h = 0
    -- local scale = 1
    -- for _, screen in ipairs(hs.screen.allScreens()) do
    --   if screen:currentMode().w * screen:currentMode().scale > w * scale then
    --     w = screen:currentMode().w
    --     h = screen:currentMode().h
    --     scale = screen:currentMode().scale
    --   end
    -- end
    -- local width = string.format("%0.f", w * scale)
    -- local height = string.format("0.f", h * scale)
    -- local image_url = "https://source.unsplash.com/random/" .. width .. "x" .. height
    local image_url = "https://source.unsplash.com/random/3648x2736/?wallpaper,landscape"
    obj.task = hs.task.new("/usr/bin/curl", curl_callback, {"-L", image_url, "-o", obj.localpath})
    obj.task:start()
end

function obj:init()
    if obj.timer == nil then
        obj.timer = hs.timer.doEvery(3*60*60, function() unsplashRequest() end)
        obj.timer:setNextTrigger(5)
    else
        obj.timer:start()
    end
end

return obj
