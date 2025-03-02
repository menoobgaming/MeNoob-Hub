local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

-- Lấy avatar của người chơi từ Roblox API
local AvatarURL = "https://media.discordapp.net/attachments/1218215410709696546/1236542261446185070/Me_Noob_6.png?format=webp&quality=lossless&width=100&height=100"

-- Biến lưu trạng thái mở/tắt UI
local isUIOpen = false
local isDragging = false
local isDraggingWindow = false
local dragStart, startPos
local dragOffset = Vector2.new(0, 0)

-- Load vị trí cũ của icon (nếu có)
local iconPosition = UDim2.fromOffset(50, 50)

-- Tạo bảng UI chính
local Window = Fluent:CreateWindow({
    Title = "MeNoob Hub",
    SubTitle = "By Vacation",
    TabWidth = 160,
    Theme = "Darker",
    Acrylic = false,
    Size = UDim2.fromOffset(500, 320),
    MinimizeKey = Enum.KeyCode.End
})

local Tabs = {
    Status = Window:AddTab({ Title = "Use Info" }),
    AutoFarm = Window:AddTab({ Title = "Auto Hop" }),
    Sp = Window:AddTab({ Title = "Hỗ Trợ" }),
    KillBot = Window:AddTab({ Title = "Kill Bot" }),
    Misc = Window:AddTab({ Title = "Misc" })
}

-- 🏴‍☠️ Kill Bot Tab (Hack tiêu diệt Bot)
Tabs.KillBot:AddButton({
    Title = "🔥 Kích Hoạt Kill Bot",
    Description = "Nhấn để bật hack Kill Bot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))()
    end
})

Tabs.Sp:AddParagraph({
    Title = "Chào mừng!",
    Content = "Nhấn vào icon avatar để bật/tắt bảng script!"
})

Tabs.Sp:AddParagraph({
    Title = "👑 MenoobGaming Hub",
    Content = "Cảm ơn bạn đã sử dụng script!"
})

Tabs.Sp:AddButton({
    Title = "🌍 Tham gia Discord",
    Description = "Kết nối với cộng đồng MenoobGaming",
    Callback = function()
        local discordLink = "https://discord.gg/t4pjwuweUR"
        setclipboard(discordLink)
        game:LaunchURL(discordLink) 
    end
})

Tabs.Sp:AddButton({
    Title = "🎥 Kênh YouTube",
    Description = "Theo dõi để cập nhật video mới",
    Callback = function()
        local youtubeLink = "https://www.youtube.com/@VacationDev"
        setclipboard(youtubeLink)
        game:LaunchURL(youtubeLink) 
    end
})

Tabs.Sp:AddParagraph({
    Title = "💻 Dev By Vacation",
    Content = "Mọi vấn đề liên hệ Discord hoặc YouTube!"
})

-- 📌 Hiển thị thông tin người chơi
local UserInfo = Tabs.Status:AddParagraph({
    Title = "👤 Thông Tin Nhân Vật",
    Content = "━━━━━━━━━━━━━━━━━━━━━\n" ..
        "🔹 **Tên**: " .. game.Players.LocalPlayer.DisplayName .. " (@" .. game.Players.LocalPlayer.Name .. ")\n" ..
        "⭐ **Cấp**: " .. game:GetService("Players").LocalPlayer.Data.Level.Value .. "\n" ..
        "💰 **Tiền**: " .. game:GetService("Players").LocalPlayer.Data.Beli.Value .. "\n" ..
        "💎 **Điểm F**: " .. game:GetService("Players").LocalPlayer.Data.Fragments.Value .. "\n" ..
        "🏴‍☠ **Tiền Truy Nã**: " .. game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value .. "\n" ..
        "❤️ **Máu**: " .. game.Players.LocalPlayer.Character.Humanoid.Health .. "/" .. game.Players.LocalPlayer.Character.Humanoid.MaxHealth .. "\n" ..
        "⚡ **Năng Lượng**: " .. game.Players.LocalPlayer.Character.Energy.Value .. "/" .. game.Players.LocalPlayer.Character.Energy.MaxValue .. "\n" ..
        "🧬 **Tộc**: " .. game:GetService("Players").LocalPlayer.Data.Race.Value .. "\n" ..
        "🍎 **Trái**: " .. game:GetService("Players").LocalPlayer.Data.DevilFruit.Value .. "\n" ..
        "━━━━━━━━━━━━━━━━━━━━━"
})

-- 🕒 Hiển thị thời gian địa phương
local Time = Tabs.Status:AddParagraph({
    Title = "🕒 Thời Gian Hiện Tại",
    Content = ""
})

local function UpdateLocalTime()
    local date = os.date("*t")
    local hour = date.hour % 24
    local ampm = hour < 12 and "AM" or "PM"
    local formattedTime = string.format("%02i:%02i:%02i %s", ((hour - 1) % 12) + 1, date.min, date.sec, ampm)
    local formattedDate = string.format("%02d/%02d/%04d", date.day, date.month, date.year)
    
    -- 🌍 Xác định khu vực của người chơi
    local LocalizationService = game:GetService("LocalizationService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local regionCode = "Unknown"
    
    local success, code = pcall(function()
        return LocalizationService:GetCountryRegionForPlayerAsync(player)
    end)
    
    if success then
        regionCode = code
    end
    
    Time:SetDesc(formattedDate .. " - " .. formattedTime .. " [ " .. regionCode .. " ]")
end

-- ⏳ Cập nhật thời gian liên tục
spawn(function()
    while true do
        UpdateLocalTime()
        game:GetService("RunService").RenderStepped:Wait()
    end
end)

-- 🕐 Hiển thị thời gian trong game
local ServerTime = Tabs.Status:AddParagraph({
    Title = "⏳ Thời Gian Máy Chủ",
    Content = ""
})

local function UpdateServerTime()
    local GameTime = math.floor(workspace.DistributedGameTime + 0.5)
    local Hour = math.floor(GameTime / (60 ^ 2)) % 24
    local Minute = math.floor(GameTime / 60) % 60
    local Second = GameTime % 60
    ServerTime:SetDesc(string.format("🕒 **%02d Giờ - %02d Phút - %02d Giây**", Hour, Minute, Second))
end

-- 🔄 Cập nhật thời gian server liên tục
spawn(function()
    while task.wait() do
        pcall(UpdateServerTime)
    end
end)

-- 🌟 Tab Misc (Tính năng tiện ích)
Tabs.Misc:AddButton({
    Title = "🚀 Mở Khóa FPS",
    Description = "Gỡ bỏ giới hạn FPS để chơi mượt hơn",
    Callback = function()
        setfpscap(500) 
    end
})

Tabs.Misc:AddButton({
    Title = "🔄 Chuyển Server",
    Description = "Nhảy sang một server ngẫu nhiên",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Tabs.Misc:AddButton({
    Title = "♻️ Tải Lại Server",
    Description = "Thoát và vào lại cùng server hiện tại",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

Tabs.Misc:AddButton({
    Title = "🛡 Chống AFK",
    Description = "Ngăn game kick bạn khi không hoạt động",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
})

Tabs.Misc:AddButton({
    Title = "🌙 Chế Độ Ban Đêm",
    Description = "Giảm độ sáng của màn hình game",
    Callback = function()
        game.Lighting.Brightness = 0
        game.Lighting.FogEnd = 200
        game.Lighting.Ambient = Color3.fromRGB(50, 50, 50)
    end
})

-- Avatar 
local AvatarButton = Fluent:CreateDraggableButton({
    Image = AvatarURL,
    Position = iconPosition,
    Size = UDim2.fromOffset(60, 60),
    OnClick = function()
        isUIOpen = not isUIOpen
        if isUIOpen then
            Window:Show()
        else
            Window:Hide()
        end
    end
})

AvatarButton.Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragOffset = input.Position - AvatarButton.Button.AbsolutePosition
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        AvatarButton.Button.Position = UDim2.fromOffset(
            input.Position.X - dragOffset.X,
            input.Position.Y - dragOffset.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
        -- Lưu vị trí icon sau khi di chuyển
        iconPosition = AvatarButton.Button.Position
    end
end)

-- 🖱️ Bắt đầu kéo UI khi bấm vào phần trên cùng của UI
Window.Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingWindow = true
        dragStart = input.Position
        startPos = Window.Frame.Position
    end
end)

-- 📌 Cập nhật vị trí UI khi di chuyển chuột
UserInputService.InputChanged:Connect(function(input)
    if isDraggingWindow and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Window.Frame.Position = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
    end
end)

-- 🛑 Dừng kéo khi nhả chuột
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingWindow = false
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/menoobgaming/script/refs/heads/main/Auto%20Hop?token=GHSAT0AAAAAAC7UYEHTVX4LICCFQVI5ZMISZ6DX47A"))()

-- Tab Auto Hop
Tabs.AutoFarm:AddParagraph({
    Title = "Chọn chế độ Auto Hop",
    Content = "Nhấn vào một trong các chế độ dưới đây để bắt đầu!"
})

Tabs.AutoFarm:AddButton({
    Title = "⚔ Auto Hop Rip Indra",
    Callback = function()
        RipIndra()
    end
})

Tabs.AutoFarm:AddButton({
    Title = "⚔ Auto Hop Low",
    Callback = function()
        Low()
    end
})

