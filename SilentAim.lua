_G.FOV =  (  45  )

_G.Prediction =  (  .16  )

_G.AimKey =  (  "z"  )

while wait(0) do
local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function()
   pcall(function()
       for i,v in pairs(game.Players:GetChildren()) do
           if v.Name ~= game.Players.LocalPlayer.Name then
               local hrp = v.Character.HumanoidRootPart
               hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)    
               hrp.AssemblyLinearVelocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)  
           end
       end
   end)
end)
end

local SilentAim = true
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local Mouse = LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera
hookmetamethod = hookmetamethod
Drawing = Drawing

local FOV_CIRCLE = Drawing.new("Circle")
FOV_CIRCLE.Visible = false
FOV_CIRCLE.Filled = false
FOV_CIRCLE.Thickness = 0
FOV_CIRCLE.Transparency = 1
FOV_CIRCLE.Color = Color3.new(0, 1, 0)
FOV_CIRCLE.Radius = _G.FOV
FOV_CIRCLE.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

Options = {
    Torso = "HumanoidRootPart";
    Head = "Head";
    UpperTorso = "UpperTorso";
}

print(Options) -- testing

local function MoveFovCircle()
    pcall(function()
        local DoIt = true
        spawn(function()
            while DoIt do task.wait()
                FOV_CIRCLE.Position = Vector2.new(Mouse.X, (Mouse.Y + 36))
            end
        end)
    end)
end coroutine.wrap(MoveFovCircle)()

Mouse.KeyDown:Connect(function(KeyPressed)
    if KeyPressed == (_G.AimKey:lower()) then
        if SilentAim == false then
            FOV_CIRCLE.Color = Color3.new(0, 1, 0)
            SilentAim = true
        elseif SilentAim == true then
            FOV_CIRCLE.Color = Color3.new(1, 0, 0)
            SilentAim = false
        end
    end
end)

local oldIndex = nil 
oldIndex = hookmetamethod(game, "__index", function(self, Index)
    if self == Mouse and (Index == "Hit") then 
        local Distance = 9e9
        local Targete = nil
        if SilentAim then

            for _, v in pairs(Players:GetPlayers()) do 
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 then
                    local Enemy = v.Character	
                    local CastingFrom = CFrame.new(Camera.CFrame.Position, Enemy[Options.Torso].CFrame.Position) * CFrame.new(0, 0, -4)
                    local RayCast = Ray.new(CastingFrom.Position, CastingFrom.LookVector * 9000)
                    local World, ToSpace = workspace:FindPartOnRayWithIgnoreList(RayCast, {LocalPlayer.Character:FindFirstChild("Head")})
                    local RootWorld = (Enemy[Options.Torso].CFrame.Position - ToSpace).magnitude
                    if RootWorld < 4 then
                        local RootPartPosition, Visible = Camera:WorldToScreenPoint(Enemy[Options.Torso].Position)
                        if Visible then
                            local Real_Magnitude = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(RootPartPosition.X, RootPartPosition.Y)).Magnitude
                            if Real_Magnitude < Distance and Real_Magnitude < FOV_CIRCLE.Radius then
                                Distance = Real_Magnitude
                                Targete = Enemy
                            end
                        end
                    end
                end
            end
        end

        if Targete ~= nil and Targete[Options.Head] and Targete:FindFirstChild("Humanoid").Health > 0 then
            if SilentAim then
                local ShootThis = Targete[Options.Torso] or Targete[Options.Head] or Targete[Options.LeftFoot] or Targete[Options.LeftLowerLeg] or Targete[Options.UpperTorso]
                local Predicted_Position = ShootThis.CFrame + (ShootThis.Velocity * _G.Prediction + Vector3.new(0,-0,0)) --  (-1) = Less blatant
                return ((Index == "Hit" and Predicted_Position))
            end
        end

    end
    return oldIndex(self, Index)
end)
