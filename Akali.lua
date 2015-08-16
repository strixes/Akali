if myHero.charName ~= "Akali" then return end

-- LOCALLAR --

-- AUTO UPDATE --
_G.AUTOUPDATE = false -- Change to "false" to disable auto updates!

local version = "0.2"
local author = "STRIXES"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Kn0wM3/BoLScripts/master/Akali Elo Shower.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>Akali Elo Shower:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
	local ServerData = GetWebResult(UPDATE_HOST, "/Kn0wM3/BoLScripts/master/Akali%20Elo%20Shower.Version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available "..ServerVersion)
				if _G.AUTOUPDATE then
					AutoupdaterMsg("Updating, please don't press F9")
					DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
				else AutoupdaterMsg("New Version found ("..ServerVersion..") Enable AutoUpdate or download manually!")
				end
				else 
					AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
				end
		else
			AutoupdaterMsg("Error downloading version info")
	end
end
-- UPDATE SON --


local ts
local Q = {name = "Mark of the Assassin", range = 600, ready = function() return myHero:CanUseSpell(_Q) == READY end}
local W = {name = "Twillight Shroud", ready = function() return myHero:CanUseSpell(_W) == READY end}
local E = {name = "Crescent Slash", range = 325, ready = function() return myHero:CanUseSpell(_E) == READY end}
local R = {name = "Shadow Dance", range = 700, ready = function() return myHero:CanUseSpell(_R) == READY end}
-- SON --

function OnLoad()

print("<b><font color=\"#6699FF\">Script Durumu:</font></b> <font color=\"#FFFFFF\">Calisiyor baby.</font>")
print("<b><font color=\"#6699FF\">" ..myHero.name.. "</font></b> <font color=\"#FFFFFF\">ayip degil mi ak script aciyon.</font>")
ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 650)

Config = scriptConfig("Asil vs Akali", "")
Config:addParam("lasthit", "Son Vurus", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
Config:addParam("haras", "Auto Q + E", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
Config:addParam("combo", "Tekleme Qeyf", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
end

function OnTick()
     AutoFarm()
	 AutoQ()
	 Kombo()
	 
	 --
	 -- Get the current time to use it in time based calculations
    
	--
end

for i, enemy in ipairs(GetEnemyHeroes()) do
    enemy.barData = {PercentageOffset = {x = 0, y = 0} }
end

function moveToCursor()
	if GetDistance(mousePos) > 1 then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()* (300 + GetLatency())
		myHero:MoveTo(moveToPos.x, moveToPos.z)
	end 
end

function AutoFarm()

	enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
	if (Config.lasthit) then
	
		enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil then
				if ValidTarget(minion, Q.range) and (myHero:CanUseSpell(_Q) == READY) and GetDistance(minion) > myHero.range and getDmg("Q", minion, myHero) >= minion.health then
					CastSpell(_Q, minion)
				end
				if ValidTarget(minion, E.range) and (myHero:CanUseSpell(_E) == READY) and getDmg("E", minion, myHero) >= minion.health then 
					CastSpell(_E)
				end 
				
				if ValidTarget(minion) and not (myHero:CanUseSpell(_E) == READY) and getDmg("AD", minion, myHero) >= minion.health then 
					 myHero:Attack(minion)
				end
			end
		end
	end
end

	
function AutoQ()

if (Config.haras) then
    for _, enemy in ipairs(GetEnemyHeroes()) do 
        if enemy ~= nil and ValidTarget(enemy, Q.range) then
            if GetDistance(enemy) <= Q.range and (myHero:CanUseSpell(_Q) == READY) then
                    CastSpell(_Q, enemy)
                end
					if ValidTarget(enemy) and GetDistance(enemy) <= myHero.range and not (myHero:CanUseSpell(_Q) == READY) then 
					 myHero:Attack(enemy)
					end
					if GetDistance(enemy) <= E.range and (myHero:CanUseSpell(_E) == READY) then
					CastSpell(_E)
					else		
					moveToCursor() 
					end
            end
        end
    end
end

function Kombo()

if (Config.combo) then
    for _, enemy in ipairs(GetEnemyHeroes()) do 
        if enemy ~= nil and ValidTarget(enemy, Q.range) then
            if GetDistance(enemy) <= Q.range and (myHero:CanUseSpell(_Q) == READY) then
                    CastSpell(_Q, enemy)
            end
			if GetDistance(enemy) <= R.range and (myHero:CanUseSpell(_R) == READY) then
                    CastSpell(_R, enemy)
            end
			if GetDistance(enemy) <= myHero.range and not (myHero:CanUseSpell(_R) == READY) then
                    myHero:Attack(enemy)
            end
			if GetDistance(enemy) <= E.range and (myHero:CanUseSpell(_E) == READY) then
                    CastSpell(_E)
            end
			if GetDistance(enemy) <= myHero.range and (myHero:CanUseSpell(_W) == READY) and (myHero.health < 1000) then
                    CastSpell(_W, myHero.x, myHero.z)
            end
            end
        end
		else		
					moveToCursor() 
					end
    
	
end
end


function AutoIgnite(unit)
	if ValidTarget(unit, 600) and unit.health <= 50 + (20 * myHero.level) then
		if Igniteready then
			CastSpell(Ignite.slot, unit)
		end
	end
end

function OnDraw()

		DrawCircle3D(myHero.x, myHero.y, myHero.z, 650)
		if (myHero.health < 200) then
			DrawText("Warning: LOW HP! Drink a Health Potion!", 18, 100, 100, 0xFFFF0000)
		end
		if (myHero.mana < 150) then 
			DrawText("Warning: LOW MP! Drink a Mana Potion!", 18, 100, 120, 0xFFFFFF00)
		end
end
