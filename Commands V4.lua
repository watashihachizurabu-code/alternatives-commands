local pass
G = G or {}
G.pas = function()
	if pass then return pass end
	for _, obj in next, getgc(true) do
		if typeof(obj) == "table" and rawget(obj, "RootPartFollow") ~= nil then
			local item = rawget(obj, "Pass")
			if typeof(item) == "Instance" then
				pass = item
				break
			end
		end
	end
	return pass
end
_G.Pass = G.pas()

print(_G.Pass)

local Pass = _G.Pass

local Player = game.Players.LocalPlayer
local Character = Player.Character
--local Victim = Player.Backpack.Main.LockOnScript.LockOn.Value or workspace.Live.alternative130 --workspace.Live.H3LLTARGET

local GeneralChannel : TextChannel = game.TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")

function RefreshWhitelist()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/watashihachizurabu-code/alternatives-commands/refs/heads/main/whitelist.lua"))()

	for i,v in pairs(_G.Whitelist) do
		print(i, v)
	end
end

function SplitCommand(Command : string)
	return string.split(Command, " ")
end

function GetVictimFromString(V1)
	local Victim = nil

	local VictimName = SplitCommand(V1)[2]

	if VictimName == nil then
		print("no name found")
	else
		print(VictimName)
		for i,v in pairs(workspace.Live:GetChildren()) do
			if v:IsA("Model") and string.match(string.lower(v.Name), VictimName) ~= nil then
				Victim = v
				break
			end
		end
	end

	if Victim == nil then
		print("Victim nil, setting to lock on")
		print(Player.Backpack.Main.LockOnScript.LockOn.Value)
		Victim = Player.Backpack.Main.LockOnScript.LockOn.Value
	end

	if Victim == nil then
		print("Setting victim to self")
		Victim = Player.Character
	end

	return Victim
end

function RecreateBP() : BodyPosition
	Character = Player.Character

	if Character == nil or Character:IsDescendantOf(workspace) ~= true then
		return
	end

	if Character.PrimaryPart:FindFirstChild("ScriptStuff") then
		return Character.PrimaryPart.ScriptStuff
	else
		for i,v in pairs(Character.PrimaryPart:GetChildren()) do
			if v:IsA("BodyMover") then
				v:Destroy()
			end
		end
	end

	local BP = Instance.new("BodyPosition")
	BP.Name = "ScriptStuff"
	BP.MaxForce = Vector3.new(1,1,1) * 100000
	BP.P = 20000
	BP.D = 900
	BP.Parent = Character.PrimaryPart

	return BP

end

RefreshWhitelist()

local Whitelist = _G.Whitelist

local Prefixes = {
	["alternative130"] = "`",
	["inkanzia"] = "-",
	["iiqouli"] = "-",
	["Perimares2"] = "*",
	["ChiefInquisitor"] = "*"
}

local Prefix = Prefixes[Player.Name] or Prefixes[Player.UserId]

local I = 0
local Inc = 5
local Off = 5

local UseRays = true

local LerpSpeed = .2
local ForceMulti = 1

local Orbits = {}

local Riding = false
local Sitting = false

local rayparams = RaycastParams.new()
rayparams.FilterType = Enum.RaycastFilterType.Include
rayparams.FilterDescendantsInstances = {workspace.Map}

local Anim = Instance.new("Animation")
Anim.AnimationId = "rbxassetid://3786809782" --"rbxassetid://3786720640" --"rbxassetid://3816111224"

local Anim2 = Instance.new("Animation")
Anim2.AnimationId = "rbxassetid://7507481748"

local Track1 = nil
local Track2 = nil

local BP = nil
local ChatCon = nil
local ClickCon = nil

local talkdeb = true

Commands = {

	["commands"] = {
		["Level"] = 1,
		["Function"] = function(Executor, V1, Space1)
			if talkdeb then
				talkdeb = false

				local St = "/v "

				local tab = {}

				for i,v in pairs(Commands) do
					tab[#tab + 1] = i.." " --.."("..v["Level"]..") "
				end

				task.wait(2)

				local lasti = 0

				pcall(function()
					for i = 1, #tab,4 do
						local St = St
						for a = i,i+3 do
							St = St..tab[a]
						end

						print(St)

						task.spawn(function()
							GeneralChannel:SendAsync(St)
						end)

						task.wait(3.7)

						if tab[i + 1] == nil then
							break
						end
					end
				end)

				talkdeb = true
			end
		end,
	},

	["refreshwhitelist"] = {
		["Level"] = 5,
		["Function"] = RefreshWhitelist
	},

	['refreshall'] = {
		["Level"] = 5,
		["Function"] = function(Executor, V1, Space1)
			if Executor.Name == "alternative130" then
				print("refreshing")
				ChatCon:Disconnect()
				ClickCon:Disconnect()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/watashihachizurabu-code/alternatives-commands/refs/heads/main/Commands%20V4.lua"))()
			end
		end,
	},

	['disconnectall'] = {
		["Level"] = 5,
		["Function"] = function(Executor, V1, Space1)
			if Executor.Name == "alternative130" then
				print("disconnectall")
				ChatCon:Disconnect()
				ClickCon:Disconnect()
			end
		end,
	},

	['disconnect'] = {
		["Level"] = 5,
		["Function"] = function(Executor, V1, Space1)
			if Executor.Name == Player.Name then
				print("Disconnecting")
				ChatCon:Disconnect()
				ClickCon:Disconnect()
			end
		end,
	},

	["crash"] = {
		["Level"] = 5,
		["Function"] = function(Executor, V1, Space1)
			local Victim = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			if Victim == Player.Character and V1:sub(Space1 + 1) == "all" then
				print("all")
				return
			end

			local Typ = Character:FindFirstChild("Type")

			if Typ == nil then
				print("no type???")
				return
			end

			print(Typ, Typ.Value)

			if Typ.Value == "Betty" then
				for i = 1,4 do
					task.spawn(function()
						for i = 1,3000 do
							task.spawn(function()
								local tab = {
									[1] = _G.Pass,
									[2] = "Move1",
									[3] = "Hit",
									[4] = {
										Hitted = Victim.Data.PerfectBlocking	
									},
									[5] = CFrame.new(0,1000,0)
								}

								game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

								local tab = {
									[1] = _G.Pass,
									[2] = "Move1",
									[3] = "Hit",
									[4] = {
										Hitted = Victim.Data.Blocking
									},
									[5] = CFrame.new(0, tonumber("inf"), 0)

								}

								game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)							

								local tab = {
									[1] = _G.Pass,
									[2] = "Move1",
									[3] = "Hit",
									[4] = {
										Hitted = Victim.Data.PerfectBlocking
									},
									[5] = Victim.PrimaryPart.CFrame
								}

								game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)
							end)
							task.wait()
						end
					end)
					task.wait()	
				end
				return
			end

			if Typ.Value == "DeltaSans" then
				print("Fired delta")

				for i = 1,1000 do
					task.spawn(function()
						local tab = {
							[1] = _G.Pass,
							[2] = "Bones1",
							[3] = "AirDodge",
							[4] = Victim.Torso
						}



						game.ReplicatedStorage.Remotes.DeltaSansMoves:InvokeServer(tab)
					end)
					task.wait(.08)
				end
				return
			end

		end
	},

	["void"] = {
		["Level"] = 5,
		["Function"] = function(Executor, V1, Space1)
			local Victim = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			if Victim == Player.Character and V1:sub(Space1 + 1) == "all" then
				print("all")
				return
			end

			local Typ = Character:FindFirstChild("Type")

			if Typ == nil then
				return
			end

			if Victim == Player.Character then
				return 
			end

			if Typ.Value == "Betty" then
				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Spawn",

				}

				local Proj = nil

				task.spawn(function()
					print("FiredSlash", _G.Pass)
					game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)
				end)

				local Start = tick()

				repeat
					Proj = Character.Attacks:FindFirstChild("BettyHandProjectile")
					task.wait()
				until Proj ~= nil or tick() - Start > 3

				if Proj ~= nil then
					for i = 1,1000 do
						task.spawn(function()

							if Victim:IsDescendantOf(workspace) == false then
								return
							end

							local tab = {
								[1] = _G.Pass,
								[2] = "Move1",
								[3] = "Hit",
								[4] = {
									Hitted = Victim.Data.Stamina	
								},

							}

							--print("FiredDamage", _G.Pass)
							game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

							local tab = {
								[1] = _G.Pass,
								[2] = "Move1",
								[3] = "Hit",
								[4] = {
									Hitted = Victim.Data.Blocking
								},
								[5] = Victim.PrimaryPart.CFrame
							}

							--print("FiredDamage", _G.Pass)
							game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

							--local tab = {
							--	[1] = _G.Pass,
							--	[2] = "Move1",
							--	[3] = "Hit",
							--	[4] = Proj,
							--	[5] = Victim.PrimaryPart.CFrame
							--}

							----print("FiredDamage", _G.Pass)
							--game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)
						end)
					end
				end
				return
			end

			if Typ.Value == "DeltaSans" then
				print("Fired delta")

				for i = 1,1000 do
					task.spawn(function()
						local tab = {
							[1] = _G.Pass,
							[2] = "Bones1",
							[3] = "AirDodge",
							[4] = Victim.Torso
						}



						game.ReplicatedStorage.Remotes.DeltaSansMoves:InvokeServer(tab)
					end)
					task.wait(.015)
				end
				return
			end
		end
	},

	["kill"] = {
		["Level"] = 1,
		["Function"] = function(Executor, V1, Space1)
			local Victim = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			if Victim == Player.Character and V1:sub(Space1 + 1) == "all" then
				print("all")
				return
			end

			local Typ = Character:FindFirstChild("Type")

			if Typ == nil then
				return
			end

			if Typ.Value == "Betty" then
				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Spawn",

				}

				local Proj = nil

				task.spawn(function()
					print("FiredSlash", _G.Pass)
					game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)
				end)

				local Start = tick()

				repeat
					Proj = Character.Attacks:FindFirstChild("BettyHandProjectile")
					task.wait()
				until Proj ~= nil or tick() - Start > 3

				if Proj ~= nil then
					for i = 1,1000 do

						if Victim:IsDescendantOf(workspace) == false or Victim.Humanoid.Health <= 0 then
							return
						end

						task.spawn(function()

							if Victim:IsDescendantOf(workspace) == false or Victim.Humanoid.Health <= 0 then
								return
							end

							local tab = {
								[1] = _G.Pass,
								[2] = "Move1",
								[3] = "Hit",
								[4] = {
									Hitted = Victim.Data.Stamina	
								},
								[5] = Victim.PrimaryPart.CFrame
							}

							--print("FiredDamage", _G.Pass)
							game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

							local tab = {
								[1] = _G.Pass,
								[2] = "Move1",
								[3] = "Hit",
								[4] = Proj,
								[5] = Victim.PrimaryPart.CFrame
							}

							--print("FiredDamage", _G.Pass)
							game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)
						end)
						task.wait(.1)
					end
				end
				return
			end

		end
	},

	["poison"] = {
		["Level"] = 1,
		["Function"] = function(Executor, V1, Space1)
			local Victim, NameEnd = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			if Victim == Player.Character and V1:sub(Space1 + 1) == "all" then
				print("all")
				return
			end

			local Typ = Character:FindFirstChild("Type")

			if Typ == nil then
				return
			end

			local Start, End = string.find(V1, Victim.Name)

			local Amount = 1
			local UseHitbox = false

			for i,v in pairs(SplitCommand(V1)) do
				print(v)
				if tonumber(v) ~= nil then
					Amount = tonumber(v)
				end

				if string.lower(v) == "true" then
					UseHitbox = true
				end
			end

			if Typ.Value == "Betty" then
				for i = 1,Amount do
					if Character == nil or Character:IsDescendantOf(workspace) == false or Victim:IsDescendantOf(workspace) == false or Victim == nil or Victim.Humanoid.Health <= 0 then
						break
					end

					task.spawn(function()

						if Character == nil or Character:IsDescendantOf(workspace) == false or Victim:IsDescendantOf(workspace) == false or Victim == nil or Victim.Humanoid.Health <= 0 then
							return
						end

						local tab = {
							[1] = _G.Pass,
							[2] = "Move1",
							[3] = "Hit",
							[4] = {
								Hitted = Victim.Data.Poison	
							},
							[5] = if UseHitbox then Victim.PrimaryPart.CFrame else CFrame.new(0,10000000000,0)
						}

						--print("FiredDamage", _G.Pass)
						game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

					end)
					task.wait(.1)
				end
				return
			end

		end
	},

	["sit"] = {
		["Level"] = 1,
		["Function"] = function(Executor, V1, Space1)
			local Victim = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			if Executor ~= Player.Character then
				return
			end

			Sitting = not Sitting

			if Track2 ~= nil then
				Track2:Stop()
			end

			if Sitting == true then
				Track2 = Character:WaitForChild("Humanoid"):LoadAnimation(Anim2)
				Track2:Play()

				Riding = false
				Orbits = {}

				while true do
					task.wait()

					--local Victim : Model = Player.Backpack.Main.LockOnScript.LockOn.Value
					local Character : Model = Executor

					if Character == nil or Victim == nil or Sitting ~= true then
						Orbits[Executor.Name] = false
						break
					end

					Character.PrimaryPart.CFrame = Victim.Head.CFrame * CFrame.new(0,2,.1)

					I += Inc
				end
			end
		end
	},

	["ride"] = {
		["Level"] = 1,
		["Function"] = function(Executor, V1, Space1)
			local Victim = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			if Executor ~= Player.Character then
				return
			end

			Riding = not Riding

			if Track1 ~= nil then
				Track1:Stop()
			end

			if Riding == true then

				Orbits = {}
				Sitting = false

				Track1 = Character:WaitForChild("Humanoid"):LoadAnimation(Anim)
				Track1:Play()

				local BP = RecreateBP()

				if BP == nil then
					return
				end

				while true do
					task.wait()

					--local Victim : Model = Player.Backpack.Main.LockOnScript.LockOn.Value
					local Character : Model = Executor

					if Character == nil or Victim == nil or Riding ~= true or BP.Parent ~= Character.PrimaryPart then
						Orbits[Executor.Name] = false
						break
					end

					local CF = Victim.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(I),0)

					local GoalPos = CF.Position + CF.LookVector * Off

					local CF = ((CFrame.new(Victim.Torso.Position + Vector3.new(0,2.5,0)) * Victim.PrimaryPart.CFrame.Rotation) * CFrame.new(0,1.5,5))

					--Character:PivotTo(CFrame.lookAt(GoalPos, CF.Position))
					BP.Position = BP.Position:Lerp(CF.Position, LerpSpeed)

					I += Inc
				end
			else
				for i,v in pairs(Character.PrimaryPart:GetChildren()) do
					if v:IsA("BodyMover") then
						v:Destroy()
					end
				end
			end
		end,

	},
	["orbit"] = {
		["Level"] = 1,
		["Function"] = function(Executor, V1, Space1)
			local Victim = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			if Executor ~= Player.Character then
				return
			end

			Orbits[Executor.Name] = if Orbits[Executor.Name] ~= nil then not Orbits[Executor.Name] else true

			if Orbits[Executor.Name] == true then

				Sitting = false
				Riding = false

				local BP = RecreateBP()

				if BP == nil then
					return
				end

				while true do
					task.wait()

					--local Victim : Model = Player.Backpack.Main.LockOnScript.LockOn.Value
					local Character : Model = Executor

					if Character == nil or Victim == nil or Orbits[Executor.Name] ~= true or BP.Parent ~= Character.PrimaryPart then
						Orbits[Executor.Name] = false
						break
					end

					local CF = Victim.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(I),0)

					local GoalPos = CF.Position + CF.LookVector * Off

					if UseRays then
						local Ray = workspace:Raycast(GoalPos + Vector3.new(0,15,0), Vector3.new(0,-100,0), rayparams)

						if Ray ~= nil then
							GoalPos = Ray.Position + Vector3.new(0,4,0)
						end
					end

					--Character:PivotTo(CFrame.lookAt(GoalPos, CF.Position))

					BP.Position = BP.Position:Lerp(CFrame.lookAt(GoalPos, CF.Position).Position, LerpSpeed)

					I += Inc
				end
			else
				for i,v in pairs(Character.PrimaryPart:GetChildren()) do
					if v:IsA("BodyMover") then
						v:Destroy()
					end
				end
			end
		end
	},



	["togglepb"] = {
		["Level"] = 2,
		["Function"] = function(Executor, V1, Space1)
			local Victim : Model = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			if Victim:HasTag("AutoPB") then
				print("Removed tag")
				Victim:RemoveTag("AutoPB")
				return
			else
				print("Added tag")
				Victim:AddTag("AutoPB")
			end

			while true do

				if Victim:IsDescendantOf(workspace.Live) == false then
					print("not part of workspace")
					break
				end

				if Victim:HasTag("AutoPB") == false then
					print("autopb not enabled for this person")
					break
				end

				print("Setting "..Victim.Name)

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = Victim.Data.PerfectBlocking
					},
					[5] = CFrame.new(0, tonumber("inf"), 0)

				}

				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = Victim.Data.Blocking
					},
					[5] = CFrame.new(0, tonumber("inf"), 0)

				}

				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

				task.wait(.05)
			end
		end
	},

	["Attack0"] = {
		["Level"] = 1,
		["Function"] = function(Executor, V1, Space1)
			local Victim : Model = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			while Victim:IsDescendantOf(workspace.Live) do

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = Victim.Data.Attack
					},
					[5] = CFrame.new(0, tonumber("inf"), 0)

				}


				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

			end
		end
	},

	["Defense0"] = {
		["Level"] = 1,
		["Function"] = function(Executor, V1, Space1)
			local Victim : Model = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			while Victim:IsDescendantOf(workspace.Live) do

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = Victim.Data.Defense
					},
					[5] = CFrame.new(0, tonumber("inf"), 0)

				}


				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

			end
		end
	},

	["loophate"] = {
		["Level"] = 3,
		["Function"] = function(Executor, V1, Space1)
			local Victim : Model = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			if Victim:FindFirstChild("Hate") == nil then
				return
			end

			while Victim:IsDescendantOf(workspace.Live) do

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = Victim.Hate
					},
					[5] = CFrame.new(0, tonumber("inf"), 0)

				}


				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

			end
		end
	},

	["breakMana"] = {
		["Level"] = 3,
		["Function"] = function(Executor, V1, Space1)
			local Victim : Model = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			local ttorso = Victim:FindFirstChild("Torso")
			local tdata = Victim:FindFirstChild("Data")

			if ttorso == nil or tdata == nil then
				print("no data?????")
				return
			end

			local Typ = Character:FindFirstChild("Type")

			if Typ == nil then
				print("no type???")
				return
			end

			if Typ.Value == "Betty" then

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = tdata.Stamina
					},
					[5] = CFrame.new(0, tonumber("inf"), 0)

				}

				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = tdata.MaxStamina
					},
					[5] = Victim.PrimaryPart.CFrame

				}

				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

				return
			end

		end
	},

	["break"] = {
		["Level"] = 1,
		["Function"] = function(Executor, V1, Space1)
			local Victim : Model = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			local ttorso = Victim:FindFirstChild("Torso")
			local tdata = Victim:FindFirstChild("Data")

			if ttorso == nil or tdata == nil then
				print("no data?????")
				return
			end

			local Typ = Character:FindFirstChild("Type")

			if Typ == nil then
				print("no type???")
				return
			end

			local Amount = 1
			local UseHitbox = false

			for i,v in pairs(SplitCommand(V1)) do
				print(v)
				if tonumber(v) ~= nil then
					Amount = tonumber(v)
				end

				if string.lower(v) == "true" then
					UseHitbox = true
				end
			end

			if Typ.Value == "Betty" then

				for i = 1,Amount do
					if Amount > 1 then
						task.spawn(function()
							local tab = {
								[1] = _G.Pass,
								[2] = "Move1",
								[3] = "Hit",
								[4] = {
									Hitted = tdata.Stamina
								},
								[5] = CFrame.new(0, tonumber("inf"), 0)

							}

							game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

							local tab = {
								[1] = _G.Pass,
								[2] = "Move1",
								[3] = "Hit",
								[4] = {
									Hitted = tdata.Blocking
								},
								[5] = Victim.PrimaryPart.CFrame

							}

							game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)
						end)
					else
						local tab = {
							[1] = _G.Pass,
							[2] = "Move1",
							[3] = "Hit",
							[4] = {
								Hitted = tdata.Stamina
							},
							[5] = CFrame.new(0, tonumber("inf"), 0)

						}

						game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)
					end
				end

				return
			end

			if Typ.Value == "XSans" then
				for i = 1,1200 do

					if Victim.Data.Stamina.Value <= 0 then
						break
					end

					task.spawn(function()

						if Victim.Data.Stamina.Value <= 0 then
							return
						end

						local tab = {
							[1] = _G.Pass,
							[2] = "SummonBones",
							[3] = "AirDodge",
							[4] = Victim.Torso
						}



						game.ReplicatedStorage.Remotes.XSansMoves:InvokeServer(tab)
					end)
					task.wait(.07)
				end
				return
			end

			if Typ.Value == "DeltaSans" then
				for i = 1,1200 do

					if Victim.Data.Stamina.Value <= 0 then
						break
					end

					task.spawn(function()

						if Victim.Data.Stamina.Value <= 0 then
							return
						end

						local tab = {
							[1] = _G.Pass,
							[2] = "Bones1",
							[3] = "AirDodge",
							[4] = Victim.Torso
						}



						game.ReplicatedStorage.Remotes.DeltaSansMoves:InvokeServer(tab)
					end)
					task.wait(.07)
				end
				return
			end

			if Typ.Value == "Chara" then
				local tab = {
					[1] = _G.Pass,
					[2] = "KnifeProjectile",
					[3] = "Spawn",
					[4] = {
						Hitted = tdata.Stamina
					},
				}
				print("Fired")
				game.ReplicatedStorage.Remotes.GTChara.CharaMoves:InvokeServer(tab)
				return
			end
		end
	},

	["inflvl"] = {
		["Level"] = 3,
		["Function"] = function(Executor, V1, Space1)
			local Victim : Model = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			local ttorso = Victim:FindFirstChild("Torso")
			local tdata = Victim:FindFirstChild("Data")

			if ttorso == nil or tdata == nil then
				return
			end

			while Victim:IsDescendantOf(workspace.Live) do

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = tdata.Lv
					},
					[5] = CFrame.new(0, tonumber("inf"), 0)

				}

				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = tdata.MaxExp
					},
					[5] = CFrame.new(0, tonumber("inf"), 0)

				}

				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)
				task.wait(.05)
			end
		end
	},

	["nosoulcap"] = {
		["Level"] = 3,
		["Function"] = function(Executor, V1, Space1)
			local Victim = GetVictimFromString(V1, Space1)

			if Victim == nil then
				print("no victim")
				return
			else
				print("Victim = : "..Victim.Name)
			end

			while Victim:IsDescendantOf(workspace.Live) do

				local tab = {
					[1] = _G.Pass,
					[2] = "Move1",
					[3] = "Hit",
					[4] = {
						Hitted = Victim.SoulsTaken
					},
					[5] = CFrame.new(0, tonumber("inf"), 0)

				}


				game.ReplicatedStorage.Remotes.BettyMoves:InvokeServer(tab)
				task.wait(.05)
			end
		end
	}

}

print("Commands Started")

ChatCon = game.ReplicatedStorage.Remotes.Effects.OnClientEvent:Connect(function(tab)
	local Function = tab[1]

	Character = Player.Character

	if Character == nil then
		return
	end

	if Function == "Chatted" then
		local Character, V1, Color = tab[2], tab[3], tab[4]

		local Removed = false

		if V1:sub(1,2) == "/v" then
			Removed = true
			V1 = V1:sub(4)
		end

		print(Whitelist[Character.Name])

		if (V1:sub(1,1) == Prefix or string.match(string.lower(V1), "refreshwhitelist") or string.match(string.lower(V1), "refreshall") or string.match(string.lower(V1), "disconnectall")) and Whitelist[Character.Name] ~= nil then
			local Space1 = V1:find(" ")
			local Length = string.len(V1)

			local Command : string = V1:sub(2, if Space1 then Space1 - 1 else Length)

			if Commands[Command] ~= nil then
				print("Found Command: "..Command)
			else
				print("Command '"..Command.."' does not exist")
				return
			end

			if Commands[Command].Level > Whitelist[Character.Name] then
				GeneralChannel:SendAsync("/v Insufficient level ("..Character.Name..") Expected = "..Commands[Command].Level.." but Current = "..Whitelist[Character.Name])
				return
			end

			Commands[Command].Function(Character, V1, Space1 or Length)

			return	
		end

	end
end)

local UIS = game:GetService("UserInputService")

local AutoPB = false

ClickCon = UIS.InputBegan:Connect(function(Input, GameP)
	if GameP then
		return
	end

	Character = Player.Character

	if Input.KeyCode == Enum.KeyCode.Z then
		local Victim = Player.Backpack.Main.LockOnScript.LockOn.Value

		if Victim ~= nil then
			Commands["break"].Function(Player.Character, "*break "..Victim.Name, 6)
		end
	end

	if Input.KeyCode == Enum.KeyCode.Quote then
		local Victim = Player.Backpack.Main.LockOnScript.LockOn.Value

		if Victim ~= nil then
			Commands["void"].Function(Player.Character, "*void "..Victim.Name, 6)
		end
	end

	if Input.KeyCode == Enum.KeyCode.Delete then
		local Victim = Player.Backpack.Main.LockOnScript.LockOn.Value

		if Victim ~= nil then
			Commands["crash"].Function(Player.Character, "*crash "..Victim.Name, 6)
		end
	end

	if Input.KeyCode == Enum.KeyCode.KeypadFour then
		UseRays = not UseRays
		print("Toggled Orbit rays to "..UseRays)
	end

	if Input.KeyCode == Enum.KeyCode.KeypadPlus then
		print("Added")
		LerpSpeed += .05
		print(LerpSpeed)
	end

	if Input.KeyCode == Enum.KeyCode.KeypadMinus then
		print("subtracted")
		LerpSpeed -= .05
		print(LerpSpeed)
	end

	if Input.KeyCode == Enum.KeyCode.Plus or Input.KeyCode == Enum.KeyCode.Equals then
		print("Added")
		ForceMulti = math.clamp(ForceMulti + .1, 0, 1)

		if Character.PrimaryPart:FindFirstChild("ScriptStuff") then
			Character.PrimaryPart.ScriptStuff.MaxForce = (Vector3.new(1,1,1) * 100000) * ForceMulti
		end

		print(ForceMulti)
	end

	if Input.KeyCode == Enum.KeyCode.Minus then
		print("subtracted")
		ForceMulti = math.clamp(ForceMulti - .1, 0, 1)

		if Character.PrimaryPart:FindFirstChild("ScriptStuff") then
			Character.PrimaryPart.ScriptStuff.MaxForce = (Vector3.new(1,1,1) * 100000) * ForceMulti
		end

		print(ForceMulti)
	end
end)
