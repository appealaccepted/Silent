local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function()
   pcall(function()
       for i,v in pairs(game.Players:GetChildren()) do
           if v.Name ~= game.Players.LocalPlayer.Name then
               --local hrp = v.Character.HumanoidRootPart
               old_vel = v.Character.HumanoidRootPart.Velocity
               local Y = -0
               v.Character.HumanoidRootPart.Velocity = Vector3.new(old_vel.X, Y, old_vel.Z)    
               v.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(old_vel.X, Y, old_vel.Z)  
           end
       end
   end)
end)
