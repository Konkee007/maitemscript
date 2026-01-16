wait(5) -- Safety first naja
if game.PlaceId ~= 1730877806 and game.PlaceId ~= 3978370137 then return end
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function SendNotification(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

SendNotification("Maitem Service", "Initializing...", 3)


local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
SendNotification("Maitem Service", "Character Loaded", 3)

LocalPlayer:WaitForChild("PlayerGui")
SendNotification("Maitem Service", "PlayerGui Loaded", 3)

--- Settings ---
sendwebhook = getgenv().Config.SendWebhook
auto_relog = getgenv().Config.AutoRelog
auto_check_dead = getgenv().Config.AutoCheckDead
auto_redeem_all_code = getgenv().Config.AutoRedeemAllCodes
auto_join_vip_server = getgenv().Config.AutoJoinVipServer
vip = getgenv().Config.VipServerCode
target_fps = getgenv().Config.TargetFps
black_screen = getgenv().Config.BlackScreen
load_script = getgenv().Config.LoadScript
kaitun = getgenv().Config.Kaitun
---------------


SendNotification("Maitem Service", "Config Loaded", 3)

wait(3)
if game.PlaceId == 1730877806 then
    if kaitun then 
        local ID = getgenv().Config.ID[LocalPlayer.Name]
        SendNotification("Maitem Service [Kaitun]","("..LocalPlayer.Name .. ") Joining VIP Server: " .. ID.VipServerCode, 3)
        task.spawn(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("reserved"):InvokeServer(ID.VipServerCode)
        end)
    
        wait(3)
        local success, errmsg = pcall(function()
            SendNotification("Maitem Service", "Joined VIP Server", 3)
            game:GetService("Players").LocalPlayer.PlayerGui.chooseType.Frame.RemoteEvent:FireServer(true)
        end)
        if errmsg then
            LocalPlayer:Kick("[Kicked by Maitem Service [Kaitun]] Unable to join this VIP server ("..ID.VipServerCode.."). This may be due to an invalid VIP server code. Please try again or change the code in the config and try again.")
        end
    end
    if auto_join_vip_server then
        if not kaitun then
            SendNotification("Maitem Service", "Joining VIP Server: " .. vip, 3)
            task.spawn(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("reserved"):InvokeServer(vip)
            end)
        
            wait(3)
            local success, errmsg = pcall(function()
                SendNotification("Maitem Service", "Joined VIP Server", 3)
                game:GetService("Players").LocalPlayer.PlayerGui.chooseType.Frame.RemoteEvent:FireServer(true)
            end)
            if errmsg then
                LocalPlayer:Kick("[Kicked by Maitem Service] Unable to join this VIP server ("..vip.."). This may be due to an invalid VIP server code. Please try again or change the code in the config and try again.")
            end
        end
    end
end

if game.PlaceId == 3978370137 then
    task.spawn(function()
        if auto_redeem_all_code then
            SendNotification("Maitem Service", "Redeeming All Codes...", 3)
            local Codes = {
                "HAPPYNEWYEARS2026_1",
                "HAPPYNEWYEARS2026_2"
            }

            for _, code in pairs(Codes) do
                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RedeemCode"):InvokeServer(code)
                wait(1)
            end

            SendNotification("Maitem Service", "All Codes Redeemed", 3)
        end
    end)

    task.spawn(function()
        if auto_check_dead then
            SendNotification("Maitem Service","AutoCheckDead has Enabled", 3)
            while task.wait(1) do 
                 if LocalPlayer.Character.Humanoid.Health <= 1 then
                    if auto_relog == false then 
                       SendNotification("Maitem Service",LocalPlayer.Name.." has dead. Rejoining ", 1) 
                    end
                    task.wait(2)
                    SendNotification("Maitem Service","Rejoined", 1) 
                    game:GetService("TeleportService"):Teleport(1730877806,LocalPlayer)
                 end
            end
        end
    end)

    task.spawn(function()
        if type(auto_relog) == "number" then 
            SendNotification("Maitem Service","AutoRelog has Enabled", 10)
            SendNotification("Maitem Service","AutoRelog will rejoin you once "..auto_relog.." minutes have passed.", 10)
            local totalTime = auto_relog * 60
            local startTime = os.clock()
            local relogging = false
            while task.wait(1) do 
                 if os.clock() - startTime >= totalTime then
                    if relogging == false then 
                        relogging = true
                        SendNotification("Maitem Service",auto_relog.." minutes elapsed. Relogging...", 3)
                        task.wait(1)
                        if load_script then 
                            LocalPlayer:Kick("[Kicked by Maitem Service] In order to Relogging. (Working with Feral Auto Rejoin)")
                        else
                            game:GetService("ReplicatedStorage").Events.KnockedOut:FireServer("self")
                        end
                    end
                end
            end
        end
    end)

    --[[
    task.spawn(function()
        if type(sendwebhook) == "string" then 
            SendNotification("Maitem Service","SendWebhook has Enabled", 20)
            local Time_Minute = 10
            
            while task.wait(Time_Minute * 60) do 
                if not kaitun then 
                    task.spawn(function()
                        local webhookUrl = sendwebhook
                        local PlayerLevel = game:GetService("ReplicatedStorage"):WaitForChild("Stats"..game:GetService("Players").LocalPlayer.Name).Stats.Level.Value
                        local PlayerMoney = game:GetService("ReplicatedStorage"):WaitForChild("Stats"..game:GetService("Players").LocalPlayer.Name).Stats.Peli.Value
                        Legbait_CleanValue = 0
                        local success,errmsg = pcall(function()
                            if game:GetService("Players").LocalPlayer.PlayerGui.FishingBaitGui then
                                if game:GetService("Players").LocalPlayer.PlayerGui.FishingBaitGui.Main.List["Legendary Fish Bait"] then
                                    local rawValue = game:GetService("Players").LocalPlayer.PlayerGui.FishingBaitGui.Main.List["Legendary Fish Bait"].ItemCount.Text
                                    local cleanValue = string.sub(rawValue,2)
                                    Legbait_CleanValue = cleanValue
                                end
                            end
                        end)
                    
                        if errmsg then
                            local tool = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Merchants Banana Rod") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Fishing Rod")
                            if tool then
                                game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(tool)
                                if game:GetService("Players").LocalPlayer.PlayerGui.FishingBaitGui.Main.List["Legendary Fish Bait"] then
                                    local rawValue = game:GetService("Players").LocalPlayer.PlayerGui.FishingBaitGui.Main.List["Legendary Fish Bait"].ItemCount.Text
                                    local cleanValue = string.sub(rawValue,2)
                                    Legbait_CleanValue = cleanValue
                                else
                                    Legbait_CleanValue = "Cannot be specified"
                                end
                            else
                                Legbait_CleanValue = "Cannot be specified"
                            end
                        end
                    
                    
                        local data = {
                            username = game:GetService("Players").LocalPlayer.Name,
                            content = nil,
                            embeds = {
                                {
                                description = "⬆️ **Level :** ```"..PlayerLevel.."```\n💰 **Peli : **```"..PlayerMoney.."```\n🐟 **Legendary Fish Bait :** ```"..Legbait_CleanValue.."```",
                                color = 14370059,
                                timestamp = DateTime.now():ToIsoDate(),
                                }
                            },
                        }
                        local newData = game:GetService("HttpService"):JSONEncode(data)
                        local headers = {["content-type"] = "application/json"}
                        request = http_request or request or HttpPost
                        local sendWebhook = {Url = webhookUrl, Body = newData, Method = "POST", Headers = headers}
                        request(sendWebhook)
                    end)
                else
                    task.spawn(function()
                        local webhookUrl = sendwebhook
                        local PlayerLevel = game:GetService("ReplicatedStorage"):WaitForChild("Stats"..game:GetService("Players").LocalPlayer.Name).Stats.Level.Value
                        local PlayerMoney = game:GetService("ReplicatedStorage"):WaitForChild("Stats"..game:GetService("Players").LocalPlayer.Name).Stats.Peli.Value
                        local data = {
                            username = game:GetService("Players").LocalPlayer.Name.." (Kaitun)",
                            content = nil,
                            embeds = {
                                {
                                description = "⬆️ **Level :** ```"..PlayerLevel.."```\n💰 **Peli : **```"..PlayerMoney.."```",
                                color = 14370059,
                                timestamp = DateTime.now():ToIsoDate(),
                                }
                            },
                        }
                        local newData = game:GetService("HttpService"):JSONEncode(data)
                        local headers = {["content-type"] = "application/json"}
                        request = http_request or request or HttpPost
                        local sendWebhook = {Url = webhookUrl, Body = newData, Method = "POST", Headers = headers}
                        request(sendWebhook)
                    end)
                end
            end
        end
    end)

    task.spawn(function()
        if load_script then 
            SendNotification("Maitem Service", "Loading ___ Script...", 3)
            script_key="";
            loadstring(game:HttpGet(""))()
        end
    end)
    --]]

    task.spawn(function()
        SendNotification("Maitem Service", "Locking FPS to " .. target_fps, 3)
        local frameStart = os.clock()

        RunService.PreSimulation:Connect(function()
            while os.clock() - frameStart < 1 / target_fps do

            end
            frameStart = os.clock()
        end)
    end)

    if kaitun then 
        local ID = getgenv().Config.ID[LocalPlayer.Name]
        if ID.BlackScreen then
            task.spawn(function()
                SendNotification("Maitem Service [Kaitun]","("..LocalPlayer.Name..") Enabling Black Screen...", 3)
                local success, errmsg = pcall(function()
                    local blackFrame = Instance.new("Frame")
                    blackFrame.Parent = LocalPlayer.PlayerGui.HUD
                    blackFrame.Size = UDim2.new(1, 0, 1, 0)
                    blackFrame.Position = UDim2.new(0, 0, 0, 0)
                    blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                    blackFrame.ZIndex = -1
                    local PlayerImage = Instance.new("ImageButton")
                    PlayerImage.Parent = blackFrame
                    PlayerImage.AnchorPoint = Vector2.new(0.5, 0.5)
                    PlayerImage.BackgroundTransparency = 1
                    PlayerImage.Position = UDim2.new(0.5,0,0.45,0)
                    PlayerImage.Size = UDim2.new(0.35,0,0.35,0)
                    PlayerImage.SizeConstraint = Enum.SizeConstraint.RelativeYY
                    PlayerImage.Image = game:GetService("Players"):GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
                    local Stroke = Instance.new("UIStroke")
                    Stroke.Parent = PlayerImage
                    Stroke.Color = Color3.fromRGB(255, 255, 255)
                    Stroke.Thickness = 5
                    local UICorner = Instance.new("UICorner")
                    UICorner.Parent = PlayerImage
                    UICorner.CornerRadius = UDim.new(50,0)
                    local PlayerName = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    PlayerName.Shadow:Destroy()
                    PlayerName.Parent = blackFrame
                    PlayerName.Position = UDim2.new(0.35,0,0.675,0)
                    PlayerName.Size = UDim2.new(0.3,0,0.05,0)
                    PlayerName.TextXAlignment = Enum.TextXAlignment.Center
                    PlayerName.Text = LocalPlayer.Name.." ("..LocalPlayer.DisplayName..")"
                    local ModeStatus = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    ModeStatus.Shadow:Destroy()
                    ModeStatus.Parent = blackFrame
                    ModeStatus.Position = UDim2.new(0.35,0,0.175,0)
                    ModeStatus.Size = UDim2.new(0.3,0,0.05,0)
                    ModeStatus.TextXAlignment = Enum.TextXAlignment.Center
                    ModeStatus.Text = "Currently using Black Screen Mode"
                    local Cr = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    Cr.Shadow:Destroy()
                    Cr.Parent = blackFrame
                    Cr.Position = UDim2.new(0.35,0,0.075,0)
                    Cr.Size = UDim2.new(0.3,0,0.1,0)
                    Cr.TextXAlignment = Enum.TextXAlignment.Center
                    Cr.Text = "Maitem Service"
                    local Peli = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    Peli.Shadow:Destroy()
                    Peli.Parent = blackFrame
                    Peli.Position = UDim2.new(0.35,0,0.775,0)
                    Peli.Size = UDim2.new(0.3,0,0.05,0)
                    Peli.TextXAlignment = Enum.TextXAlignment.Center
                    Peli.TextColor3 = Color3.fromRGB(255, 255, 126)
                    local Lvl = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    Lvl.Shadow:Destroy()
                    Lvl.Parent = blackFrame
                    Lvl.Position = UDim2.new(0.35,0,0.825,0)
                    Lvl.Size = UDim2.new(0.3,0,0.05,0)
                    Lvl.TextXAlignment = Enum.TextXAlignment.Center
                    task.spawn(function()
                        while true do
                            wait(1)
                            Peli.Text = "Peli "..game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Peli.TextLabel.Text
                            Lvl.Text = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level.Text
                        end
                    end)
                    LocalPlayer.PlayerGui.HUD.Main.Peli.Visible = false
                    LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Visible = false
                    LocalPlayer.PlayerGui.HUD.Main.Bars.Health.Visible = false
                    LocalPlayer.PlayerGui.HUD.Main.Bars.Stamina.Visible = false
                    LocalPlayer.PlayerGui.QuestTracker.Enabled = false
                    LocalPlayer.PlayerGui.Compass.Enabled = false
                    LocalPlayer.PlayerGui.HUD.DisplayOrder = 1499
                    LocalPlayer.PlayerGui.HUD.Main.Buttons.Visible = false
                    SendNotification("Maitem Service [Kaitun]","("..LocalPlayer.Name..") Enabled Black Screen", 3)
                end)
                if errmsg then
                    print(errmsg)
                    SendNotification("Maitem Service [Kaitun]","("..LocalPlayer.Name..") Error occurred cannot enable black screen", 5)
                end
            end)
        end
    end

    if black_screen then
        if not kaitun then 
            task.spawn(function()
                SendNotification("Maitem Service", "Enabling Black Screen...", 3)
                local success, errmsg = pcall(function()
                    local blackFrame = Instance.new("Frame")
                    blackFrame.Parent = LocalPlayer.PlayerGui.HUD
                    blackFrame.Size = UDim2.new(1, 0, 1, 0)
                    blackFrame.Position = UDim2.new(0, 0, 0, 0)
                    blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                    blackFrame.ZIndex = -1
                    local PlayerImage = Instance.new("ImageButton")
                    PlayerImage.Parent = blackFrame
                    PlayerImage.AnchorPoint = Vector2.new(0.5, 0.5)
                    PlayerImage.BackgroundTransparency = 1
                    PlayerImage.Position = UDim2.new(0.5,0,0.45,0)
                    PlayerImage.Size = UDim2.new(0.35,0,0.35,0)
                    PlayerImage.SizeConstraint = Enum.SizeConstraint.RelativeYY
                    PlayerImage.Image = game:GetService("Players"):GetUserThumbnailAsync(LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
                    local Stroke = Instance.new("UIStroke")
                    Stroke.Parent = PlayerImage
                    Stroke.Color = Color3.fromRGB(255, 255, 255)
                    Stroke.Thickness = 5
                    local UICorner = Instance.new("UICorner")
                    UICorner.Parent = PlayerImage
                    UICorner.CornerRadius = UDim.new(50,0)
                    local PlayerName = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    PlayerName.Shadow:Destroy()
                    PlayerName.Parent = blackFrame
                    PlayerName.Position = UDim2.new(0.35,0,0.675,0)
                    PlayerName.Size = UDim2.new(0.3,0,0.05,0)
                    PlayerName.TextXAlignment = Enum.TextXAlignment.Center
                    PlayerName.Text = LocalPlayer.Name.." ("..LocalPlayer.DisplayName..")"
                    local ModeStatus = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    ModeStatus.Shadow:Destroy()
                    ModeStatus.Parent = blackFrame
                    ModeStatus.Position = UDim2.new(0.35,0,0.175,0)
                    ModeStatus.Size = UDim2.new(0.3,0,0.05,0)
                    ModeStatus.TextXAlignment = Enum.TextXAlignment.Center
                    ModeStatus.Text = "Currently using Black Screen Mode"
                    local Cr = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    Cr.Shadow:Destroy()
                    Cr.Parent = blackFrame
                    Cr.Position = UDim2.new(0.35,0,0.075,0)
                    Cr.Size = UDim2.new(0.3,0,0.1,0)
                    Cr.TextXAlignment = Enum.TextXAlignment.Center
                    Cr.Text = "Maitem Service"
                    local Peli = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    Peli.Shadow:Destroy()
                    Peli.Parent = blackFrame
                    Peli.Position = UDim2.new(0.35,0,0.775,0)
                    Peli.Size = UDim2.new(0.3,0,0.05,0)
                    Peli.TextXAlignment = Enum.TextXAlignment.Center
                    Peli.TextColor3 = Color3.fromRGB(255, 255, 126)
                    local Lvl = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level:Clone()
                    Lvl.Shadow:Destroy()
                    Lvl.Parent = blackFrame
                    Lvl.Position = UDim2.new(0.35,0,0.825,0)
                    Lvl.Size = UDim2.new(0.3,0,0.05,0)
                    Lvl.TextXAlignment = Enum.TextXAlignment.Center
                    task.spawn(function()
                        while true do
                            wait(1)
                            Peli.Text = "Peli "..game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Peli.TextLabel.Text
                            Lvl.Text = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Detail.Level.Text
                        end
                    end)
                    LocalPlayer.PlayerGui.HUD.Main.Peli.Visible = false
                    LocalPlayer.PlayerGui.HUD.Main.Bars.Experience.Visible = false
                    LocalPlayer.PlayerGui.HUD.Main.Bars.Health.Visible = false
                    LocalPlayer.PlayerGui.HUD.Main.Bars.Stamina.Visible = false
                    LocalPlayer.PlayerGui.QuestTracker.Enabled = false
                    LocalPlayer.PlayerGui.Compass.Enabled = false
                    LocalPlayer.PlayerGui.HUD.DisplayOrder = 1499
                    LocalPlayer.PlayerGui.HUD.Main.Buttons.Visible = false
                    SendNotification("Maitem Service", "Enabled Black Screen", 3)
                end)
                if errmsg then
                    print(errmsg)
                    SendNotification("Maitem Service", "Error occurred cannot enable black screen", 5)
                end
            end)
        end
    end
end





