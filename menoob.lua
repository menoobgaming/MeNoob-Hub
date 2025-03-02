local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

-- Avatar URL
-- local AvatarURL = "https://media.discordapp.net/attachments/1218215410709696546/1236542261446185070/Me_Noob_6.png?format=webp&quality=lossless&width=100&height=100"
local AvatarURL = "rbxassetid://106486998629491" -- Thay ID đúng


-- Biến trạng thái UI
local isUIOpen = false

-- Tạo cửa sổ UI
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


getgenv().hasUsedBoss = {}

getgenv().FindBoss = function(bossName, apiUrl, fixedPlaceId)
    print("🔍 Đang tìm boss:", bossName)

    -- Kiểm tra nếu đã teleport thành công trước đó
    if getgenv().hasUsedBoss[bossName] then
        warn("⚠ Bạn đã teleport thành công đến boss này, không thể nhấn lại!")
        return
    end

    local success, response = pcall(function()
        local httpService = game:GetService("HttpService")
        local result = game:HttpGet(apiUrl)
        return httpService:JSONDecode(result)
    end)

    if not success or type(response) ~= "table" or not response["Job ID"] then
        warn("❌ API lỗi hoặc không tìm thấy server có boss " .. bossName .. "!")
        return
    end

    local jobId = response["Job ID"]
    print("✅ Tìm thấy boss " .. bossName .. "! Job ID:", jobId)

    local placeId = fixedPlaceId or game.PlaceId
    local teleportService = game:GetService("TeleportService")
    local player = game.Players.LocalPlayer

    local teleportSuccess, teleportError = pcall(function()
        teleportService:TeleportToPlaceInstance(placeId, jobId, player)
    end)

    if teleportSuccess then
        print("✅ Đã teleport thành công đến boss " .. bossName)
        getgenv().hasUsedBoss[bossName] = true -- Đánh dấu chỉ khi teleport thành công
    else
        warn("❌ Lỗi teleport:", teleportError)
    end
end

-- Hàm Auto Hop
getgenv().RipIndra = function()
    getgenv().FindBoss("Rip Indra", "http://utopia.pylex.xyz:9068/rip_indra", 7449423635)
end

getgenv().Low = function()
    getgenv().FindBoss("Low", "http://utopia.pylex.xyz:9068/low")
end


-- 🏴‍☠️ Tab Auto Hop
Tabs.AutoFarm:AddParagraph({
    Title = "Chọn chế độ Auto Hop",
    Content = "Nhấn vào một trong các chế độ dưới đây để bắt đầu!"
})

Tabs.AutoFarm:AddButton({
    Title = "⚔ Auto Hop Rip Indra",
    Callback = function()
        print("▶ Bắt đầu Auto Hop Rip Indra...")
        RipIndra()
    end
})

Tabs.AutoFarm:AddButton({
    Title = "⚔ Auto Hop Low",
    Callback = function()
        print("▶ Bắt đầu Auto Hop Low...")
        Low()
    end
})

-- 🏴‍☠️ Tab Kill Bot
Tabs.KillBot:AddButton({
    Title = "🔥 Kích Hoạt Kill Bot",
    Description = "Nhấn để bật hack Kill Bot",
    Callback = function()
        print("🟡 Đang tải script Kill Bot...")

        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/redz9999"))()
        end)

        if success then
            print("✅ Kill Bot đã được kích hoạt!")
        else
            warn("❌ Lỗi khi tải script: " .. tostring(err))
        end
    end
})


-- 🏴‍☠️ Tab Hỗ Trợ
Tabs.Sp:AddParagraph({
    Title = "Chào mừng!",
    Content = "Nhấn vào icon avatar để bật/tắt bảng script!"
})

Tabs.Sp:AddButton({
    Title = "🌍 Tham gia Discord",
    Callback = function()
        setclipboard("https://discord.gg/t4pjwuweUR")
        game:LaunchURL("https://discord.gg/t4pjwuweUR") 
    end
})

Tabs.Sp:AddButton({
    Title = "🎥 Kênh YouTube",
    Callback = function()
        setclipboard("https://www.youtube.com/@VacationDev")
        game:LaunchURL("https://www.youtube.com/@VacationDev") 
    end
})

-- 🚀 Tab Misc
Tabs.Misc:AddButton({
    Title = "🚀 Mở Khóa FPS",
    Callback = function()
        setfpscap(500) 
    end
})

Tabs.Misc:AddButton({
    Title = "🔄 Chuyển Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Tabs.Misc:AddButton({
    Title = "♻️ Tải Lại Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

Tabs.Misc:AddButton({
    Title = "🛡 Chống AFK",
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
    Callback = function()
        game.Lighting.Brightness = 0
        game.Lighting.FogEnd = 200
        game.Lighting.Ambient = Color3.fromRGB(50, 50, 50)
    end
})

-- 🖼 Avatar UI Button
local AvatarButton = Fluent:CreateButton({ -- Sử dụng CreateButton thay vì CreateDraggableButton
    Title = "", -- Không có chữ để giữ nguyên hình ảnh
    Image = AvatarURL,
    Position = UDim2.new(0, 50, 0, 50),
    Size = UDim2.new(0, 60, 0, 60),
    OnClick = function()
        isUIOpen = not isUIOpen
        if isUIOpen then
            print("📂 Mở giao diện")
            Window:Show()
        else
            print("❌ Đóng giao diện")
            Window:Hide()
        end
    end
})

-- Đảm bảo Fluent hiển thị UI
Fluent:SetVisibility(true)
