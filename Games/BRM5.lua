local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = PlayerService.LocalPlayer

repeat task.wait() until Workspace:FindFirstChild("Enemies")
local AimbotTarget, SilentAimTarget, Aimbot,
NPCFolder, GroundTip, AircraftTip = nil, nil,
false, Workspace.Enemies, nil, nil

Parvus.Config = Parvus.Utilities.Config:ReadJSON(Parvus.Current, {
    PlayerESP = {
        AllyColor = {0.25,1,0.25,0},
        EnemyColor = {1,0.25,0.25,0},

        TeamColor = false,
        TeamCheck = true,
        Highlight = {
            Enabled = false,
            Transparency = 0.5,
            Outline = {
                Color = {1,1,1,0},
                Transparency = 1
            }
        },
        Box = {
            Enabled = false,
            Outline = true,
            Filled = false,
            Thickness = 1,
            Transparency = 1,
            Info = {
                Enabled = false,
                AutoScale = true,
                Transparency = 1,
                Size = 16
            }
        },
        Other = {
            Head = {
                Enabled = false,
                AutoScale = true,
                Filled = true,
                Radius = 8,
                NumSides = 4,
                Thickness = 1,
                Transparency = 1
            },
            Tracer = {
                Enabled = false,
                Thickness = 1,
                Transparency = 1,
                From = "ScreenBottom",
                To = "Head"
            },
            Arrow = {
                Enabled = false,
                Filled = true,
                Width = 16,
                Height = 16,
                Thickness = 1,
                Transparency = 1,
                DistanceFromCenter = 80,
            }
        }
    },
    NPCESP = {
        EnemyColor = {1,0.25,0.25,0},

        Highlight = {
            Enabled = false,
            Transparency = 0.5,
            Outline = {
                Color = {1,1,1,0},
                Transparency = 1
            }
        },
        Box = {
            Enabled = false,
            Outline = true,
            Filled = false,
            Thickness = 1,
            Transparency = 1,
            Info = {
                Enabled = false,
                AutoScale = true,
                Transparency = 1,
                Text = "Enemy NPC",
                Size = 16
            }
        },
        Other = {
            Head = {
                Enabled = false,
                AutoScale = true,
                Filled = true,
                Radius = 8,
                NumSides = 4,
                Thickness = 1,
                Transparency = 1
            },
            Tracer = {
                Enabled = false,
                Thickness = 1,
                Transparency = 1,
                From = "ScreenBottom",
                To = "Head"
            },
            Arrow = {
                Enabled = false,
                Filled = true,
                Width = 16,
                Height = 16,
                Thickness = 1,
                Transparency = 1,
                DistanceFromCenter = 80,
            }
        }
    },
    AimAssist = {
        TeamCheck = true,
        TargetMode = "NPC",
        SilentAim = {
            Enabled = false,
            WallCheck = false,
            HitChance = 100,
            FieldOfView = 50,
            Priority = {"Head"},
            Circle = {
                Visible = false,
                Transparency = 0.5,
                Color = {0.25,0.25,1,0},
                Thickness = 1,
                NumSides = 100,
                Filled = false
            }
        },
        Aimbot = {
            Enabled = false,
            WallCheck = false,
            Sensitivity = 0.25,
            FieldOfView = 100,
            Priority = {"Head"},
            Circle = {
                Visible = true,
                Transparency = 0.5,
                Color = {1,0.25,0.25,0},
                Thickness = 1,
                NumSides = 100,
                Filled = false
            }
        }
    },
    GameFeatures = {
        EnvEnable = false,
        EnvTime = 12,
        EnvFog = 0.25,

        NoRecoil = false,
        InstantHit = false,
        UnlockFiremodes = false,
        RapidFire = false,
        RapidFireValue = 1000,

        Speedhack = false,
        SpeedhackValue = 32,

        Vehicle = false,
        VehicleSpeed = 60,
        VehicleAcceleration = 1,

        Helicopter = false,
        HelicopterSpeed = 200
    },
    UI = {
        Enabled = true,
        Keybind = "RightShift",
        Color = {0.5,0.25,0.5,0},
        TileSize = 74,
        Background = "Floral",
        BackgroundId = "rbxassetid://5553946656",
        BackgroundColor = {0,0,0,0},
        BackgroundTransparency = 0,
        Cursor = {
            Enabled = true,
            Length = 16,
            Width = 11,

            Crosshair = {
                Enabled = false,
                Color = {1,0.25,0.25,0},
                Size = 4,
                Gap = 2,
            }
        }
    },
    Binds = {
        Aimbot = "MouseButton2",
        SilentAim = "NONE",
        RapidFire = "NONE",
        Speedhack = "NONE",
        Vehicle = "NONE",
        Helicopter = "NONE"
    }
})

Parvus.Utilities.Cursor(Parvus.Config.UI.Cursor)
local Window = Parvus.Utilities.UI:Window({Name = "Parvus Hub — " .. Parvus.Current,Enabled = Parvus.Config.UI.Enabled,Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.UI.Color),Position = UDim2.new(0.2,-248,0.5,-248)}) do
    local AimAssistTab = Window:Tab({Name = "Combat"}) do
        local AimbotSection = AimAssistTab:Section({Name = "Aimbot",Side = "Left"}) do
            AimbotSection:Toggle({Name = "Enabled",Value = Parvus.Config.AimAssist.Aimbot.Enabled,Callback = function(Bool)
                Parvus.Config.AimAssist.Aimbot.Enabled = Bool
            end})
            AimbotSection:Toggle({Name = "Team Check",Side = "Left",Value = Parvus.Config.AimAssist.TeamCheck,Callback = function(Bool)
                Parvus.Config.AimAssist.TeamCheck = Bool
            end}):ToolTip("Affects Aimbot and Silent Aim")
            AimbotSection:Toggle({Name = "Visibility Check",Value = Parvus.Config.AimAssist.Aimbot.WallCheck,Callback = function(Bool)
                Parvus.Config.AimAssist.Aimbot.WallCheck = Bool
            end})
            AimbotSection:Keybind({Name = "Keybind",Key = Parvus.Config.Binds.Aimbot,Mouse = true,Callback = function(Bool,Key)
                Parvus.Config.Binds.Aimbot = Key or "NONE"
                Aimbot = Parvus.Config.AimAssist.Aimbot.Enabled and Bool
            end})
            AimbotSection:Slider({Name = "Smoothness",Min = 0,Max = 100,Value = Parvus.Config.AimAssist.Aimbot.Sensitivity * 100,Unit = "%",Callback = function(Number)
                Parvus.Config.AimAssist.Aimbot.Sensitivity = Number / 100
            end})
            AimbotSection:Slider({Name = "Field of View",Min = 0,Max = 500,Value = Parvus.Config.AimAssist.Aimbot.FieldOfView,Callback = function(Number)
                Parvus.Config.AimAssist.Aimbot.FieldOfView = Number
            end})
            AimbotSection:Dropdown({Name = "Priority",Default = Parvus.Config.AimAssist.Aimbot.Priority,List = {
                {Name = "Head",Mode = "Toggle",Callback = function(Selected)
                    Parvus.Config.AimAssist.Aimbot.Priority = Selected
                end},
                {Name = "HumanoidRootPart",Mode = "Toggle",Callback = function(Selected)
                    Parvus.Config.AimAssist.Aimbot.Priority = Selected
                end}
            }})
            AimbotSection:Dropdown({Name = "Target Mode",Default = {Parvus.Config.AimAssist.TargetMode},List = {
                {Name = "Player",Mode = "Button",Callback = function()
                    Parvus.Config.AimAssist.Aimbot.TargetMode = "Player"
                end},
                {Name = "NPC",Mode = "Button",Callback = function()
                    Parvus.Config.AimAssist.Aimbot.TargetMode = "NPC"
                end}
            }}):ToolTip("Affects Aimbot and Silent Aim")
        end
        local SilentAimSection = AimAssistTab:Section({Name = "Silent Aim",Side = "Right"}) do
            SilentAimSection:Toggle({Name = "Enabled",Value = Parvus.Config.AimAssist.SilentAim.Enabled,Callback = function(Bool)
                Parvus.Config.AimAssist.SilentAim.Enabled = Bool
            end}):Keybind({Key = Parvus.Config.Binds.SilentAim,Mouse = true,Callback = function(Bool,Key)
                Parvus.Config.Binds.SilentAim = Key or "NONE"
            end})
            SilentAimSection:Toggle({Name = "Visibility Check",Value = Parvus.Config.AimAssist.SilentAim.WallCheck,Callback = function(Bool)
                Parvus.Config.AimAssist.SilentAim.WallCheck = Bool
            end})
            SilentAimSection:Slider({Name = "Hit Chance",Min = 0,Max = 100,Value = Parvus.Config.AimAssist.SilentAim.HitChance,Unit = "%",Callback = function(Number)
                Parvus.Config.AimAssist.SilentAim.HitChance = Number
            end})
            SilentAimSection:Slider({Name = "Field of View",Min = 0,Max = 500,Value = Parvus.Config.AimAssist.SilentAim.FieldOfView,Callback = function(Number)
                Parvus.Config.AimAssist.SilentAim.FieldOfView = Number
            end})
            SilentAimSection:Dropdown({Name = "Priority",Default = Parvus.Config.AimAssist.SilentAim.Priority,List = {
                {Name = "Head",Mode = "Toggle",Callback = function(Selected)
                    Parvus.Config.AimAssist.SilentAim.Priority = Selected
                end},
                {Name = "HumanoidRootPart",Mode = "Toggle",Callback = function(Selected)
                    Parvus.Config.AimAssist.SilentAim.Priority = Selected
                end}
            }})
        end
    end
    local VisualsTab = Window:Tab({Name = "Visuals"}) do
        local GlobalSection = VisualsTab:Section({Name = "Global",Side = "Left"}) do
            GlobalSection:Colorpicker({Name = "Ally Color",Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.PlayerESP.AllyColor),Callback = function(Color,Table)
                Parvus.Config.PlayerESP.AllyColor = Table
            end})
            GlobalSection:Colorpicker({Name = "Enemy Color",Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.PlayerESP.EnemyColor),Callback = function(Color,Table)
                Parvus.Config.PlayerESP.EnemyColor = Table
            end})
            GlobalSection:Toggle({Name = "Use Team Color",Value = Parvus.Config.PlayerESP.TeamColor,Callback = function(Bool)
                Parvus.Config.PlayerESP.TeamColor = Bool
            end})
            GlobalSection:Toggle({Name = "Team Check",Value = Parvus.Config.PlayerESP.TeamCheck,Callback = function(Bool)
                Parvus.Config.PlayerESP.TeamCheck = Bool
            end})
        end
        local BoxSection = VisualsTab:Section({Name = "Boxes",Side = "Left"}) do
            BoxSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Box.Enabled,Callback = function(Bool)
                Parvus.Config.PlayerESP.Box.Enabled = Bool
            end})
            BoxSection:Toggle({Name = "Filled",Value = Parvus.Config.PlayerESP.Box.Filled,Callback = function(Bool)
                Parvus.Config.PlayerESP.Box.Filled = Bool
            end})
            BoxSection:Toggle({Name = "Outline",Value = Parvus.Config.PlayerESP.Box.Outline,Callback = function(Bool)
                Parvus.Config.PlayerESP.Box.Outline = Bool
            end})
            BoxSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Box.Thickness,Callback = function(Number)
                Parvus.Config.PlayerESP.Box.Thickness = Number
            end})
            BoxSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Box.Transparency,Callback = function(Number)
                Parvus.Config.PlayerESP.Box.Transparency = Number
            end})
            BoxSection:Divider({Text = "Text / Info"})
            BoxSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Box.Info.Enabled,Callback = function(Bool)
                Parvus.Config.PlayerESP.Box.Info.Enabled = Bool
            end})
            BoxSection:Toggle({Name = "Autoscale",Value = Parvus.Config.PlayerESP.Box.Info.AutoScale,Callback = function(Bool)
                Parvus.Config.PlayerESP.Box.Info.AutoScale = Bool
            end})
            BoxSection:Slider({Name = "Size",Min = 14,Max = 28,Value = Parvus.Config.PlayerESP.Box.Info.Size,Callback = function(Number)
                Parvus.Config.PlayerESP.Box.Info.Size = Number
            end})
            BoxSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Box.Info.Transparency,Callback = function(Number)
                Parvus.Config.PlayerESP.Box.Info.Transparency = Number
            end})
        end
        local TracerSection = VisualsTab:Section({Name = "Tracers",Side = "Left"}) do
            TracerSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Other.Tracer.Enabled,Callback = function(Bool)
                Parvus.Config.PlayerESP.Other.Tracer.Enabled = Bool
            end})
            TracerSection:Dropdown({Name = "Mode",Default = {
                Parvus.Config.PlayerESP.Other.Tracer.From == "ScreenBottom" and "From Bottom" or "From Mouse"
            },List = {
                {Name = "From Bottom",Mode = "Button",Callback = function()
                    Parvus.Config.PlayerESP.Other.Tracer.From = "ScreenBottom"
                end},
                {Name = "From Mouse",Mode = "Button",Callback = function()
                    Parvus.Config.PlayerESP.Other.Tracer.From = "Mouse"
                end}
            }})
            TracerSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Other.Tracer.Thickness,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Tracer.Thickness = Number
            end})
            TracerSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Other.Tracer.Transparency,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Tracer.Transparency = Number
            end})
        end
        local HighlightSection = VisualsTab:Section({Name = "Highlights",Side = "Left"}) do
            HighlightSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Highlight.Enabled,Callback = function(Bool)
                Parvus.Config.PlayerESP.Highlight.Enabled = Bool
            end})
            HighlightSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Highlight.Transparency,Callback = function(Number)
                Parvus.Config.PlayerESP.Highlight.Transparency = Number
            end})
            HighlightSection:Divider({Text = "Outline"})
            HighlightSection:Colorpicker({Name = "Color",Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.PlayerESP.Highlight.Outline.Color),Callback = function(Color,Table)
                Parvus.Config.PlayerESP.Highlight.Outline.Color = Table
            end})
            HighlightSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Highlight.Outline.Transparency,Callback = function(Number)
                Parvus.Config.PlayerESP.Highlight.Outline.Transparency = Number
            end})
        end
        local HeadSection = VisualsTab:Section({Name = "Head Circles",Side = "Right"}) do
            HeadSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Other.Head.Enabled,Callback = function(Bool)
                Parvus.Config.PlayerESP.Other.Head.Enabled = Bool
            end})
            HeadSection:Toggle({Name = "Filled",Value = Parvus.Config.PlayerESP.Other.Head.Filled,Callback = function(Bool)
                Parvus.Config.PlayerESP.Other.Head.Filled = Bool
            end})
            HeadSection:Toggle({Name = "Autoscale",Value = Parvus.Config.PlayerESP.Other.Head.AutoScale,Callback = function(Bool)
                Parvus.Config.PlayerESP.Other.Head.AutoScale = Bool
            end})
            HeadSection:Slider({Name = "Radius",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Other.Head.Radius,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Head.Radius = Number
            end})
            HeadSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = Parvus.Config.PlayerESP.Other.Head.NumSides,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Head.NumSides = Number
            end})
            HeadSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Other.Head.Thickness,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Head.Thickness = Number
            end})
            HeadSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Other.Head.Transparency,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Head.Transparency = Number
            end})
        end
        local AFoVSection = VisualsTab:Section({Name = "Aimbot FoV Circle",Side = "Right"}) do
            AFoVSection:Toggle({Name = "Enabled",Value = Parvus.Config.AimAssist.Aimbot.Circle.Visible,Callback = function(Bool)
                Parvus.Config.AimAssist.Aimbot.Circle.Visible = Bool
            end})
            AFoVSection:Toggle({Name = "Filled",Value = Parvus.Config.AimAssist.Aimbot.Circle.Filled,Callback = function(Bool)
                Parvus.Config.AimAssist.Aimbot.Circle.Filled = Bool
            end})
            AFoVSection:Colorpicker({Name = "Color",Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.AimAssist.Aimbot.Circle.Color),Callback = function(Color,Table)
                Parvus.Config.AimAssist.Aimbot.Circle.Color = Table
            end})
            AFoVSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = Parvus.Config.AimAssist.Aimbot.Circle.NumSides,Callback = function(Number)
                Parvus.Config.AimAssist.Aimbot.Circle.NumSides = Number
            end})
            AFoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.AimAssist.Aimbot.Circle.Thickness,Callback = function(Number)
                Parvus.Config.AimAssist.Aimbot.Circle.Thickness = Number
            end})
            AFoVSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.AimAssist.Aimbot.Circle.Transparency,Callback = function(Number)
                Parvus.Config.AimAssist.Aimbot.Circle.Transparency = Number
            end})
        end
        local SAFoVSection = VisualsTab:Section({Name = "Silent Aim FoV Circle",Side = "Right"}) do
            SAFoVSection:Toggle({Name = "Enabled",Value = Parvus.Config.AimAssist.SilentAim.Circle.Visible,Callback = function(Bool)
                Parvus.Config.AimAssist.SilentAim.Circle.Visible = Bool
            end})
            SAFoVSection:Toggle({Name = "Filled",Value = Parvus.Config.AimAssist.SilentAim.Circle.Filled,Callback = function(Bool)
                Parvus.Config.AimAssist.SilentAim.Circle.Filled = Bool
            end})
            SAFoVSection:Colorpicker({Name = "Color",Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.AimAssist.SilentAim.Circle.Color),Callback = function(Color,Table)
                Parvus.Config.AimAssist.SilentAim.Circle.Color = Table
            end})
            SAFoVSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = Parvus.Config.AimAssist.SilentAim.Circle.NumSides,Callback = function(Number)
                Parvus.Config.AimAssist.SilentAim.Circle.NumSides = Number
            end})
            SAFoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.AimAssist.SilentAim.Circle.Thickness,Callback = function(Number)
                Parvus.Config.AimAssist.SilentAim.Circle.Thickness = Number
            end})
            SAFoVSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.AimAssist.SilentAim.Circle.Transparency,Callback = function(Number)
                Parvus.Config.AimAssist.SilentAim.Circle.Transparency = Number
            end})
        end
        local OoVSection = VisualsTab:Section({Name = "Offscreen Arrows",Side = "Right"}) do
            OoVSection:Toggle({Name = "Enabled",Value = Parvus.Config.PlayerESP.Other.Arrow.Enabled,Callback = function(Bool)
                Parvus.Config.PlayerESP.Other.Arrow.Enabled = Bool
            end})
            OoVSection:Toggle({Name = "Filled",Value = Parvus.Config.PlayerESP.Other.Arrow.Filled,Callback = function(Bool)
                Parvus.Config.PlayerESP.Other.Arrow.Filled = Bool
            end})
            OoVSection:Slider({Name = "Height",Min = 14,Max = 28,Value = Parvus.Config.PlayerESP.Other.Arrow.Height,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Arrow.Height = Number
            end})
            OoVSection:Slider({Name = "Width",Min = 14,Max = 28,Value = Parvus.Config.PlayerESP.Other.Arrow.Width,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Arrow.Width = Number
            end})
            OoVSection:Slider({Name = "Distance From Center",Min = 80,Max = 200,Value = Parvus.Config.PlayerESP.Other.Arrow.DistanceFromCenter,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Arrow.DistanceFromCenter = Number
            end})
            OoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.PlayerESP.Other.Arrow.Thickness,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Arrow.Thickness = Number
            end})
            OoVSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.PlayerESP.Other.Arrow.Transparency,Callback = function(Number)
                Parvus.Config.PlayerESP.Other.Arrow.Transparency = Number
            end})
        end
    end
    local NPCVisualsTab = Window:Tab({Name = "NPC Visuals"}) do
        --local GlobalSection = NPCVisualsTab:Section({Name = "Global",Side = "Left"}) do
        NPCVisualsTab:Colorpicker({Name = "Enemy Color",Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.NPCESP.EnemyColor),Callback = function(Color,Table)
            Parvus.Config.NPCESP.EnemyColor = Table
        end})
        --end
        local BoxSection = NPCVisualsTab:Section({Name = "Boxes",Side = "Left"}) do
            BoxSection:Toggle({Name = "Enabled",Value = Parvus.Config.NPCESP.Box.Enabled,Callback = function(Bool)
                Parvus.Config.NPCESP.Box.Enabled = Bool
            end})
            BoxSection:Toggle({Name = "Filled",Value = Parvus.Config.NPCESP.Box.Filled,Callback = function(Bool)
                Parvus.Config.NPCESP.Box.Filled = Bool
            end})
            BoxSection:Toggle({Name = "Outline",Value = Parvus.Config.NPCESP.Box.Outline,Callback = function(Bool)
                Parvus.Config.NPCESP.Box.Outline = Bool
            end})
            BoxSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.NPCESP.Box.Thickness,Callback = function(Number)
                Parvus.Config.NPCESP.Box.Thickness = Number
            end})
            BoxSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.NPCESP.Box.Transparency,Callback = function(Number)
                Parvus.Config.NPCESP.Box.Transparency = Number
            end})
            BoxSection:Divider({Text = "Text / Info"})
            BoxSection:Toggle({Name = "Enabled",Value = Parvus.Config.NPCESP.Box.Info.Enabled,Callback = function(Bool)
                Parvus.Config.NPCESP.Box.Info.Enabled = Bool
            end})
            BoxSection:Toggle({Name = "Autoscale",Value = Parvus.Config.NPCESP.Box.Info.AutoScale,Callback = function(Bool)
                Parvus.Config.NPCESP.Box.Info.AutoScale = Bool
            end})
            BoxSection:Slider({Name = "Size",Min = 14,Max = 28,Value = Parvus.Config.NPCESP.Box.Info.Size,Callback = function(Number)
                Parvus.Config.NPCESP.Box.Info.Size = Number
            end})
            BoxSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.NPCESP.Box.Info.Transparency,Callback = function(Number)
                Parvus.Config.NPCESP.Box.Info.Transparency = Number
            end})
        end
        local TracerSection = NPCVisualsTab:Section({Name = "Tracers",Side = "Left"}) do
            TracerSection:Toggle({Name = "Enabled",Value = Parvus.Config.NPCESP.Other.Tracer.Enabled,Callback = function(Bool)
                Parvus.Config.NPCESP.Other.Tracer.Enabled = Bool
            end})
            TracerSection:Dropdown({Name = "Mode",Default = {
                Parvus.Config.PlayerESP.Other.Tracer.From == "ScreenBottom" and "From Bottom" or "From Mouse"
            },List = {
                {Name = "From Bottom",Mode = "Button",Callback = function()
                    Parvus.Config.PlayerESP.Other.Tracer.From = "ScreenBottom"
                end},
                {Name = "From Mouse",Mode = "Button",Callback = function()
                    Parvus.Config.PlayerESP.Other.Tracer.From = "Mouse"
                end}
            }})
            TracerSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.NPCESP.Other.Tracer.Thickness,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Tracer.Thickness = Number
            end})
            TracerSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.NPCESP.Other.Tracer.Transparency,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Tracer.Transparency = Number
            end})
        end
        local HighlightSection = NPCVisualsTab:Section({Name = "Highlights",Side = "Left"}) do
            HighlightSection:Toggle({Name = "Enabled",Value = Parvus.Config.NPCESP.Highlight.Enabled,Callback = function(Bool)
                Parvus.Config.NPCESP.Highlight.Enabled = Bool
            end})
            HighlightSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.NPCESP.Highlight.Transparency,Callback = function(Number)
                Parvus.Config.NPCESP.Highlight.Transparency = Number
            end})
            HighlightSection:Divider({Text = "Outline"})
            HighlightSection:Colorpicker({Name = "Color",Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.NPCESP.Highlight.Outline.Color),Callback = function(Color,Table)
                Parvus.Config.NPCESP.Highlight.Outline.Color = Table
            end})
            HighlightSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.NPCESP.Highlight.Outline.Transparency,Callback = function(Number)
                Parvus.Config.NPCESP.Highlight.Outline.Transparency = Number
            end})
        end
        local HeadSection = NPCVisualsTab:Section({Name = "Head Circles",Side = "Right"}) do
            HeadSection:Toggle({Name = "Enabled",Value = Parvus.Config.NPCESP.Other.Head.Enabled,Callback = function(Bool)
                Parvus.Config.NPCESP.Other.Head.Enabled = Bool
            end})
            HeadSection:Toggle({Name = "Filled",Value = Parvus.Config.NPCESP.Other.Head.Filled,Callback = function(Bool)
                Parvus.Config.NPCESP.Other.Head.Filled = Bool
            end})
            HeadSection:Toggle({Name = "Autoscale",Value = Parvus.Config.NPCESP.Other.Head.AutoScale,Callback = function(Bool)
                Parvus.Config.NPCESP.Other.Head.AutoScale = Bool
            end})
            HeadSection:Slider({Name = "Radius",Min = 1,Max = 10,Value = Parvus.Config.NPCESP.Other.Head.Radius,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Head.Radius = Number
            end})
            HeadSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = Parvus.Config.NPCESP.Other.Head.NumSides,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Head.NumSides = Number
            end})
            HeadSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.NPCESP.Other.Head.Thickness,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Head.Thickness = Number
            end})
            HeadSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.NPCESP.Other.Head.Transparency,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Head.Transparency = Number
            end})
        end
        local OoVSection = NPCVisualsTab:Section({Name = "Offscreen Arrows",Side = "Right"}) do
            OoVSection:Toggle({Name = "Enabled",Value = Parvus.Config.NPCESP.Other.Arrow.Enabled,Callback = function(Bool)
                Parvus.Config.NPCESP.Other.Arrow.Enabled = Bool
            end})
            OoVSection:Toggle({Name = "Filled",Value = Parvus.Config.NPCESP.Other.Arrow.Filled,Callback = function(Bool)
                Parvus.Config.NPCESP.Other.Arrow.Filled = Bool
            end})
            OoVSection:Slider({Name = "Height",Min = 14,Max = 28,Value = Parvus.Config.NPCESP.Other.Arrow.Height,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Arrow.Height = Number
            end})
            OoVSection:Slider({Name = "Width",Min = 14,Max = 28,Value = Parvus.Config.NPCESP.Other.Arrow.Width,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Arrow.Width = Number
            end})
            OoVSection:Slider({Name = "Distance From Center",Min = 80,Max = 200,Value = Parvus.Config.NPCESP.Other.Arrow.DistanceFromCenter,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Arrow.DistanceFromCenter = Number
            end})
            OoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = Parvus.Config.NPCESP.Other.Arrow.Thickness,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Arrow.Thickness = Number
            end})
            OoVSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.NPCESP.Other.Arrow.Transparency,Callback = function(Number)
                Parvus.Config.NPCESP.Other.Arrow.Transparency = Number
            end})
        end
    end
    local GameTab = Window:Tab({Name = Parvus.Current}) do
        local EnvSection = GameTab:Section({Name = "Environment"}) do
            EnvSection:Toggle({Name = "Enable",Value = Parvus.Config.GameFeatures.EnvEnable,Callback = function(Bool)
                Parvus.Config.GameFeatures.EnvEnable = Bool
            end})
            EnvSection:Slider({Name = "Clock Time",Min = 0,Max = 24,Value = Parvus.Config.GameFeatures.EnvTime,Callback = function(Number)
                Parvus.Config.GameFeatures.EnvTime = Number
            end})
            EnvSection:Slider({Name = "Fog Density",Min = 0,Max = 1,Precise = 2,Value = Parvus.Config.GameFeatures.EnvFog,Callback = function(Number)
                Parvus.Config.GameFeatures.EnvFog = Number
            end})
        end
        local WeaponSection = GameTab:Section({Name = "Weapon"}) do
            WeaponSection:Toggle({Name = "No Recoil",Value = Parvus.Config.GameFeatures.NoRecoil,Callback = function(Bool)
                Parvus.Config.GameFeatures.NoRecoil = Bool
            end})
            WeaponSection:Toggle({Name = "Instant Hit",Value = Parvus.Config.GameFeatures.InstantHit,Callback = function(Bool)
                Parvus.Config.GameFeatures.InstantHit = Bool
            end}):ToolTip("silent aim works better with it")
            WeaponSection:Toggle({Name = "Unlock Firemodes",Value = Parvus.Config.GameFeatures.UnlockFiremodes,Callback = function(Bool)
                Parvus.Config.GameFeatures.UnlockFiremodes = Bool
            end}):ToolTip("re-equip your weapon to make it work")
            local RapidFireToggle = WeaponSection:Toggle({Name = "Rapid Fire",Value = Parvus.Config.GameFeatures.RapidFire,Callback = function(Bool)
                Parvus.Config.GameFeatures.RapidFire = Bool
            end})
            RapidFireToggle:Keybind({Key = Parvus.Config.Binds.RapidFire,Callback = function(Bool,Key)
                Parvus.Config.Binds.RapidFire = Key or "NONE"
            end})
            RapidFireToggle:ToolTip("re-equip your weapon to disable")
            WeaponSection:Slider({Name = "Round Per Minute",Min = 45,Max = 1000,Value = Parvus.Config.GameFeatures.RapidFireValue,Callback = function(Number)
                Parvus.Config.GameFeatures.RapidFireValue = Number
            end})
        end
        local CharSection = GameTab:Section({Name = "Character"}) do
            CharSection:Toggle({Name = "Speedhack",Value = Parvus.Config.GameFeatures.Speedhack,Callback = function(Bool)
                Parvus.Config.GameFeatures.Speedhack = Bool
            end}):Keybind({Key = Parvus.Config.Binds.Speedhack,Callback = function(Bool,Key)
                Parvus.Config.Binds.Speedhack = Key or "NONE"
            end})
            CharSection:Slider({Name = "Speed",Min = 16,Max = 1000,Value = Parvus.Config.GameFeatures.SpeedhackValue,Callback = function(Number)
                Parvus.Config.GameFeatures.SpeedhackValue = Number
            end})
        end
        local VehSection = GameTab:Section({Name = "Vehicle"}) do
            VehSection:Toggle({Name = "Enable",Value = Parvus.Config.GameFeatures.Vehicle,Callback = function(Bool)
                Parvus.Config.GameFeatures.Vehicle = Bool
            end}):Keybind({Key = Parvus.Config.Binds.Vehicle,Callback = function(Bool,Key)
                Parvus.Config.Binds.Vehicle = Key or "NONE"
            end})
            VehSection:Slider({Name = "Speed",Min = 0,Max = 1000,Value = Parvus.Config.GameFeatures.VehicleSpeed,Callback = function(Number)
                Parvus.Config.GameFeatures.VehicleSpeed = Number
            end})
            VehSection:Slider({Name = "Acceleration",Min = 1,Max = 50,Value = Parvus.Config.GameFeatures.VehicleAcceleration,Callback = function(Number)
                Parvus.Config.GameFeatures.VehicleAcceleration = Number
            end}):ToolTip("lower = faster")
        end
        local HeliSection = GameTab:Section({Name = "Helicopter"}) do
            HeliSection:Toggle({Name = "Enable",Value = Parvus.Config.GameFeatures.Helicopter,Callback = function(Bool)
                Parvus.Config.GameFeatures.Helicopter = Bool
            end}):Keybind({Key = Parvus.Config.Binds.Helicopter,Callback = function(Bool,Key)
                Parvus.Config.Binds.Helicopter = Key or "NONE"
            end})
            HeliSection:Slider({Name = "Speed",Min = 0,Max = 500,Value = Parvus.Config.GameFeatures.HelicopterSpeed,Callback = function(Number)
                Parvus.Config.GameFeatures.HelicopterSpeed = Number
            end})
        end
    end
    local SettingsTab = Window:Tab({Name = "Settings"}) do
        local MenuSection = SettingsTab:Section({Name = "Menu",Side = "Left"}) do
            MenuSection:Toggle({Name = "Enabled",Value = Window.Enabled,Callback = function(Bool) 
                Window:Toggle(Bool)
            end}):Keybind({Key = Parvus.Config.UI.Keybind,Callback = function(Bool,Key)
                Parvus.Config.UI.Keybind = Key or "NONE"
            end})
            MenuSection:Toggle({Name = "Close On Exec",Value = not Parvus.Config.UI.Enabled,Callback = function(Bool) 
                Parvus.Config.UI.Enabled = not Bool
            end})
            MenuSection:Toggle({Name = "Custom Mouse",Value = Parvus.Config.UI.Cursor.Enabled,Callback = function(Bool) 
                Parvus.Config.UI.Cursor.Enabled = Bool
            end})
            MenuSection:Colorpicker({Name = "Color",Color = Window.Color,Callback = function(Color,Table)
                Parvus.Config.UI.Color = Table
                Window:ChangeColor(Color)
            end})
        end
        local CrosshairSection = SettingsTab:Section({Name = "Custom Crosshair",Side = "Left"}) do
            CrosshairSection:Toggle({Name = "Enabled",Value = Parvus.Config.UI.Cursor.Crosshair.Enabled,Callback = function(Bool) 
                Parvus.Config.UI.Cursor.Crosshair.Enabled = Bool
            end})
            CrosshairSection:Colorpicker({Name = "Color",Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.UI.Cursor.Crosshair.Color),Callback = function(Color,Table)
                Parvus.Config.UI.Cursor.Crosshair.Color = Table
            end})
            CrosshairSection:Slider({Name = "Size",Min = 0,Max = 100,Value = Parvus.Config.UI.Cursor.Crosshair.Size,Callback = function(Number)
                Parvus.Config.UI.Cursor.Crosshair.Size = Number
            end})
            CrosshairSection:Slider({Name = "Gap",Min = 0,Max = 100,Value = Parvus.Config.UI.Cursor.Crosshair.Gap,Callback = function(Number)
                Parvus.Config.UI.Cursor.Crosshair.Gap = Number
            end})
        end
        SettingsTab:Button({Name = "Server Hop",Side = "Left",Callback = function()
            local x = {}
            for _, v in ipairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
                if type(v) == "table" and v.id ~= game.JobId then
                    x[#x + 1] = v.id
                end
            end
            if #x > 0 then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
            else
                Parvus.Utilities.UI:Notification("Parvus Hub","Couldn't find a server",5)
            end
        end})
        SettingsTab:Button({Name = "Join Discord Server",Side = "Left",Callback = function()
            local Request = (syn and syn.request) or request
            Request({
                ["Url"] = "http://localhost:6463/rpc?v=1",
                ["Method"] = "POST",
                ["Headers"] = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                ["Body"] = HttpService:JSONEncode({
                    ["cmd"] = "INVITE_BROWSER",
                    ["nonce"] = string.lower(HttpService:GenerateGUID(false)),
                    ["args"] = {
                        ["code"] = "JKywVqjV6m"
                    }
                })
            })
        end}):ToolTip("Join for support, updates and more!")
        local BackgroundSection = SettingsTab:Section({Name = "Background",Side = "Right"}) do
            BackgroundSection:Dropdown({Name = "Image",Default = {Parvus.Config.UI.Background},List = {
                {Name = "Legacy",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://2151741365"
                    Parvus.Config.UI.BackgroundId = "rbxassetid://2151741365"
                end},
                {Name = "Hearts",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073763717"
                    Parvus.Config.UI.BackgroundId = "rbxassetid://6073763717"
                end},
                {Name = "Abstract",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073743871"
                    Parvus.Config.UI.BackgroundId = "rbxassetid://6073743871"
                end},
                {Name = "Hexagon",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073628839"
                    Parvus.Config.UI.BackgroundId = "rbxassetid://6073628839"
                end},
                {Name = "Circles",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071579801"
                    Parvus.Config.UI.BackgroundId = "rbxassetid://6071579801"
                end},
                {Name = "Lace With Flowers",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071575925"
                    Parvus.Config.UI.BackgroundId = "rbxassetid://6071575925"
                end},
                {Name = "Floral",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://5553946656"
                    Parvus.Config.UI.BackgroundId = "rbxassetid://5553946656"
                end}
            }})
            Window.Background.Image = Parvus.Config.UI.BackgroundId
            BackgroundSection:Textbox({Name = "Custom Image",Text = "",Placeholder = "ImageId",Callback = function(String)
                Window.Background.Image = "rbxassetid://" .. String
                Parvus.Config.UI.BackgroundId = "rbxassetid://" .. String
            end})
            Window.Background.ImageColor3 = Parvus.Utilities.Config:TableToColor(Parvus.Config.UI.BackgroundColor)
            BackgroundSection:Colorpicker({Name = "Color",Color = Window.Background.ImageColor3,Callback = function(Color,Table)
                Parvus.Config.UI.BackgroundColor = Table
                Window.Background.ImageColor3 = Color
            end})
            Window.Background.ImageTransparency = Parvus.Config.UI.BackgroundTransparency
            BackgroundSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = Window.Background.ImageTransparency,Callback = function(Number)
                Parvus.Config.UI.BackgroundTransparency = Number
                Window.Background.ImageTransparency = Number
            end})
            Window.Background.TileSize = UDim2.new(0,Parvus.Config.UI.TileSize,0,Parvus.Config.UI.TileSize)
            BackgroundSection:Slider({Name = "Tile Offset",Min = 74, Max = 296,Value = Window.Background.TileSize.X.Offset,Callback = function(Number)
                Parvus.Config.UI.TileSize = Number
                Window.Background.TileSize = UDim2.new(0,Number,0,Number)
            end})
        end
        local CreditsSection = SettingsTab:Section({Name = "Credits",Side = "Right"}) do
            CreditsSection:Label({Text = "Thanks to Jan for this awesome background patterns."})
            CreditsSection:Label({Text = "Thanks to Infinite Yield Team for server hop."})
            CreditsSection:Label({Text = "Thanks to Blissful for Offscreen Arrows."})
            CreditsSection:Label({Text = "Thanks to coasts for his Universal ESP."})
            CreditsSection:Label({Text = "Thanks to el3tric for Bracket V2."})
            CreditsSection:Label({Text = "And thanks to AlexR32#0157 for making this script."})
            CreditsSection:Label({Text = "❤️ ❤️ ❤️ ❤️"})
        end
    end
end

local function TeamCheck(Target)
    if Parvus.Config.AimAssist.TeamCheck then
        return LocalPlayer.Team ~= Target.Team
    end
    return true
end

local function WallCheck(Enabled,Hitbox,Character)
	if not Enabled then return true end
	local Camera = Workspace.CurrentCamera
	return not Camera:GetPartsObscuringTarget({Hitbox.Position},{
        LocalPlayer.Character,
        Character
    })[1]
end

local function GetTarget(Config)
    local Camera = Workspace.CurrentCamera
    local FieldOfView = Config.FieldOfView
    local ClosestTarget = nil

    if Parvus.Config.AimAssist.TargetMode == "NPC" then
        for Index, Target in pairs(NPCFolder:GetChildren()) do
            if not Target:FindFirstChild("Vest") then continue end
            if Target:FindFirstChildOfClass("Humanoid") and Target:FindFirstChildOfClass("Humanoid").Health > 0 then
                for Index, BodyPart in pairs(Config.Priority) do
                    local Hitbox = Target:FindFirstChild(BodyPart)
                    if Hitbox then
                        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
                        local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if OnScreen and FieldOfView > Magnitude and WallCheck(Config.WallCheck,Hitbox,Character) then
                            FieldOfView = Magnitude
                            ClosestTarget = Hitbox
                        end
                    end
                end
            end
        end
    elseif Parvus.Config.AimAssist.TargetMode == "Player" then
        for Index, Target in pairs(PlayerService:GetPlayers()) do
            local Character = Target.Character
            local Health = Character and (Character:FindFirstChildOfClass("Humanoid") and Character:FindFirstChildOfClass("Humanoid").Health > 0)
            if Target ~= LocalPlayer and Health and TeamCheck(Target) then
                for Index, BodyPart in pairs(Config.Priority) do
                    local Hitbox = Character and Character:FindFirstChild(BodyPart)
                    if Hitbox then
                        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
                        local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if OnScreen and FieldOfView > Magnitude and WallCheck(Config.WallCheck,Hitbox,Character) then
                            FieldOfView = Magnitude
                            ClosestTarget = Hitbox
                        end
                    end
                end
            end
        end
    end

    return ClosestTarget
end

local function requireGameModule(Name)
    for Index, Instance in pairs(getloadedmodules()) do
        if Instance.Name == Name then
            return require(Instance)
        end
    end
end

local ControllerClass = requireGameModule("ControllerClass")
local controllerOld
while task.wait() do
    if ControllerClass and ControllerClass.LateUpdate then
        controllerOld = ControllerClass.LateUpdate
        break
    else
        ControllerClass = requireGameModule("ControllerClass")
    end
end
if ControllerClass and controllerOld then
    ControllerClass.LateUpdate = function(...)
        local args = {...}
        if Parvus.Config.GameFeatures.Speedhack then
            args[1].Speed = Parvus.Config.GameFeatures.SpeedhackValue
        end
        return controllerOld(...)
    end
end

local CharacterCamera = requireGameModule("CharacterCamera")
local cameraOld
while task.wait() do
    if CharacterCamera and CharacterCamera.Update then
        cameraOld = CharacterCamera.Update
        break
    else
        CharacterCamera = requireGameModule("CharacterCamera")
    end
end
if CharacterCamera and cameraOld then
    CharacterCamera.Update = function(...)
        local args = {...}
        args[1]._shakes = {}
        args[1]._bob = 0
        if Parvus.Config.GameFeatures.NoRecoil then
            args[1]._recoil.Velocity = Vector3.zero
        end
        return cameraOld(...)
    end
end

local TurretCamera = requireGameModule("TurretCamera")
local turretCamOld
while task.wait() do
    if TurretCamera and TurretCamera.Update then
        turretCamOld = TurretCamera.Update
        break
    else
        TurretCamera = requireGameModule("TurretCamera")
    end
end
if TurretCamera and turretCamOld then
    TurretCamera.Update = function(...)
        local args = {...}
        if Parvus.Config.GameFeatures.NoRecoil then
            args[1]._recoil.Velocity = Vector3.zero
        end
        return turretCamOld(...)
    end
end

local FirearmInventory = requireGameModule("FirearmInventory")
local firearmDischargeOld
local firearmNewOld
while task.wait() do
    if FirearmInventory and FirearmInventory._discharge and FirearmInventory.new then
        firearmDischargeOld = FirearmInventory._discharge
        firearmNewOld = FirearmInventory.new
        break
    else
        FirearmInventory = requireGameModule("FirearmInventory")
    end
end
if FirearmInventory and firearmDischargeOld and firearmNewOld then
    FirearmInventory._discharge = function(...)
        local args = {...}
        if Parvus.Config.GameFeatures.RapidFire then
            args[1]._config.Tune.RPM = Parvus.Config.GameFeatures.RapidFireValue
        end
        if Parvus.Config.GameFeatures.InstantHit then
            args[1]._config.Tune.Velocity = 9e9
        end
        return firearmDischargeOld(...)
    end
    FirearmInventory.new = function(...)
        local args = {...}
        if Parvus.Config.GameFeatures.UnlockFiremodes then
            if not table.find(args[2].Tune.Firemodes,1) then
                table.insert(args[2].Tune.Firemodes,1)
            end
            if not table.find(args[2].Tune.Firemodes,2) then
                table.insert(args[2].Tune.Firemodes,2)
            end
            if not table.find(args[2].Tune.Firemodes,3) then
                table.insert(args[2].Tune.Firemodes,3)
            end
            args[2].Mode = 1
        end
        return firearmNewOld(...)
    end
end

local GroundMovement = requireGameModule("GroundMovement")
local groundOld
while task.wait() do
    if GroundMovement and GroundMovement.Update then
        groundOld = GroundMovement.Update
        break
    else
        GroundMovement = requireGameModule("GroundMovement")
    end
end
if GroundMovement and groundOld then
    GroundMovement.Update = function(...)
        local args = {...}
        if Parvus.Config.GameFeatures.Vehicle then
            args[1]._tune.Speed = Parvus.Config.GameFeatures.VehicleSpeed
            args[1]._tune.Accelerate = Parvus.Config.GameFeatures.VehicleAcceleration
        end
        return groundOld(...)
    end
end

local HelicopterMovement = requireGameModule("HelicopterMovement")
local heliOld
while task.wait() do
    if HelicopterMovement and HelicopterMovement.Update then
        heliOld = HelicopterMovement.Update
        break
    else
        HelicopterMovement = requireGameModule("HelicopterMovement")
    end
end
if HelicopterMovement and heliOld then
    HelicopterMovement.Update = function(...)
        local args = {...}
        if Parvus.Config.GameFeatures.Helicopter then
            args[1]._tune.Speed = Parvus.Config.GameFeatures.HelicopterSpeed
        end
        return heliOld(...)
    end
end

local AircraftMovement = requireGameModule("AircraftMovement")
local aircraftDischargeOld
while task.wait() do
    if AircraftMovement and AircraftMovement._discharge then
        aircraftDischargeOld = AircraftMovement._discharge
        break
    else
        AircraftMovement = requireGameModule("AircraftMovement")
    end
end
if AircraftMovement and aircraftDischargeOld then
    AircraftMovement._discharge = function(...)
        local args = {...}
        if Parvus.Config.GameFeatures.InstantHit then
            args[1]._tune.Velocity = 9e9
        end
        AircraftTip = args[1]._tip
        return aircraftDischargeOld(...)
    end
end

local TurretMovement = requireGameModule("TurretMovement")
local turretOld
while task.wait() do
    if TurretMovement and TurretMovement._discharge then
        turretOld = TurretMovement._discharge
        break
    else
        TurretMovement = requireGameModule("TurretMovement")
    end
end
if TurretMovement and turretOld then
    TurretMovement._discharge = function(...)
        local args = {...}
        if Parvus.Config.GameFeatures.InstantHit then
            args[1]._tune.Velocity = 9e9
        end
        GroundTip = args[1]._tip
        return turretOld(...)
    end
end

local EnvironmentService = requireGameModule("EnvironmentService")
local environmentOld
while task.wait() do
    if EnvironmentService and EnvironmentService.Update then
        environmentOld = EnvironmentService.Update
        break
    else
        EnvironmentService = requireGameModule("EnvironmentService")
    end
end
if EnvironmentService and environmentOld then
    EnvironmentService.Update = function(...)
        local args = {...}
        if Parvus.Config.GameFeatures.EnvEnable then
            args[1]._atmoshperes.Default.Density = Parvus.Config.GameFeatures.EnvFog
            if args[1]._atmoshperes.Desert and args[1]._atmoshperes.Snow then
                args[1]._atmoshperes.Desert.Density = Parvus.Config.GameFeatures.EnvFog
                args[1]._atmoshperes.Snow.Density = Parvus.Config.GameFeatures.EnvFog
            end
        end
        return environmentOld(...)
    end
end

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if Parvus.Config.AimAssist.SilentAim.Enabled and SilentAimTarget then
        if getnamecallmethod() == "Raycast" then
            local Camera = Workspace.CurrentCamera
            local HitChance = math.random(0,100) <= Parvus.Config.AimAssist.SilentAim.HitChance
            if args[1] == Camera.CFrame.Position and HitChance then
                args[2] = SilentAimTarget.Position - Camera.CFrame.Position
            elseif AircraftTip and args[1] == AircraftTip.WorldCFrame.Position and HitChance then
                args[2] = SilentAimTarget.Position - AircraftTip.WorldCFrame.Position
            elseif GroundTip and args[1] == GroundTip.WorldCFrame.Position and HitChance then
                args[2] = SilentAimTarget.Position - GroundTip.WorldCFrame.Position
            end
        end
    end
    return __namecall(self, unpack(args))
end)

local AimbotCircle = Drawing.new("Circle")
local SilentAimCircle = Drawing.new("Circle")
AimbotCircle.ZIndex = 3
SilentAimCircle.ZIndex = 3
RunService.Heartbeat:Connect(function()
    AimbotCircle.Visible = Parvus.Config.AimAssist.Aimbot.Circle.Visible
    if AimbotCircle.Visible then
        AimbotCircle.Transparency = Parvus.Config.AimAssist.Aimbot.Circle.Transparency
        AimbotCircle.Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.AimAssist.Aimbot.Circle.Color)
        AimbotCircle.Thickness = Parvus.Config.AimAssist.Aimbot.Circle.Thickness
        AimbotCircle.NumSides = Parvus.Config.AimAssist.Aimbot.Circle.NumSides
        AimbotCircle.Radius = Parvus.Config.AimAssist.Aimbot.FieldOfView
        AimbotCircle.Filled = Parvus.Config.AimAssist.Aimbot.Circle.Filled
        AimbotCircle.Position = UserInputService:GetMouseLocation()
    end
    SilentAimCircle.Visible = Parvus.Config.AimAssist.SilentAim.Circle.Visible
    if SilentAimCircle.Visible then
        SilentAimCircle.Transparency = Parvus.Config.AimAssist.SilentAim.Circle.Transparency
        SilentAimCircle.Color = Parvus.Utilities.Config:TableToColor(Parvus.Config.AimAssist.SilentAim.Circle.Color)
        SilentAimCircle.Thickness = Parvus.Config.AimAssist.SilentAim.Circle.Thickness
        SilentAimCircle.NumSides = Parvus.Config.AimAssist.SilentAim.Circle.NumSides
        SilentAimCircle.Radius = Parvus.Config.AimAssist.SilentAim.FieldOfView
        SilentAimCircle.Filled = Parvus.Config.AimAssist.SilentAim.Circle.Filled
        SilentAimCircle.Position = UserInputService:GetMouseLocation()
    end
    Parvus.Config.PlayerESP.Other.Tracer.To = AimbotTarget or SilentAimTarget or "Head"
    if Parvus.Config.AimAssist.SilentAim.Enabled then
        SilentAimTarget = GetTarget(Parvus.Config.AimAssist.SilentAim)
    else
        SilentAimTarget = nil
    end
    if Aimbot then
        AimbotTarget = GetTarget(Parvus.Config.AimAssist.Aimbot)
        if AimbotTarget then
            local Camera = Workspace.CurrentCamera
            local Mouse = UserInputService:GetMouseLocation()
            local TargetOnScreen = Camera:WorldToViewportPoint(AimbotTarget.Position)
            mousemoverel((TargetOnScreen.X - Mouse.X) * Parvus.Config.AimAssist.Aimbot.Sensitivity, (TargetOnScreen.Y - Mouse.Y) * Parvus.Config.AimAssist.Aimbot.Sensitivity)
        end
    end
    if Parvus.Config.GameFeatures.EnvEnable then
        Lighting.ClockTime = Parvus.Config.GameFeatures.EnvTime
    end
end)

for Index, NPC in pairs(NPCFolder:GetChildren()) do
    if NPC:WaitForChild("Vest",0.5) then
        Parvus.Utilities.ESP:Add("NPC", NPC, Parvus.Config.NPCESP)
    end
end
NPCFolder.ChildAdded:Connect(function(NPC)
    if NPC:WaitForChild("Vest",0.5) then
        Parvus.Utilities.ESP:Add("NPC", NPC, Parvus.Config.NPCESP)
    end
end)
NPCFolder.ChildRemoved:Connect(function(NPC)
    Parvus.Utilities.ESP:Remove(NPC)
end)

for Index, Player in pairs(PlayerService:GetPlayers()) do
    if Player ~= LocalPlayer then
        Parvus.Utilities.ESP:Add("Player", Player, Parvus.Config.PlayerESP)
    end
end
PlayerService.PlayerAdded:Connect(function(Player)
    Parvus.Utilities.ESP:Add("Player", Player, Parvus.Config.PlayerESP)
end)
PlayerService.PlayerRemoving:Connect(function(Player)
    if Player == LocalPlayer then Parvus.Utilities.Config:WriteJSON(Parvus.Current,Parvus.Config) end
    Parvus.Utilities.ESP:Remove(Player)
end)
