if myHero.charName ~= "Akali" then return end
-- update basarili v2.0 --
-- LOCALLAR --

-- AUTO UPDATE --
_G.AUTOUPDATE = true -- Change to "false" to disable auto updates!

local version = "0.2"
local author = "strixes"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/strixes/BoL/master/Akali.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>STRiX's Akali:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
	local ServerData = GetWebResult(UPDATE_HOST, "/strixes/BoL/master/Akali.Version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("Guncelleme bulundu. "..ServerVersion)
				if _G.AUTOUPDATE then
					AutoupdaterMsg("Indiriliyor, lutfen F9 'a henuz basmayin.")
					DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Guncelleme basarili. ("..version.." => "..ServerVersion.."), Yeni versiyonu aktif etmek icin 2 kere F9'a basin.") end) end, 3)
				else AutoupdaterMsg("Guncelleme bulundu ("..ServerVersion..") Enable AutoUpdate or download manually!")
				end
				else 
					AutoupdaterMsg("Son surumu kullanıyorsunuz. "..ServerVersion.."")
				end
		else
			AutoupdaterMsg("Guncelleme hatasi!")
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

print("<b><font color=\"#6699FF\">Script Durumu:</font></b> <font color=\"#FFFFFF\">Akali script aktif!</font>")
print("<b><font color=\"#6699FF\">" ..myHero.name.. "</font></b> <font color=\"#FFFFFF\">ayip degil mi ak script kullaniyon.</font>")
ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 650)

Config = scriptConfig("Asil vs Akali", "")
Config:addParam("lasthit", "Son Vurus", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
Config:addParam("haras", "Auto Q + E", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
Config:addParam("combo", "Tekleme Qeyf", SCRIPT_PARAM_ONKEYDOWN, false, string.byte(" "))
Config:addParam("autoignite", "Auto Ignite", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("U"))
end

function OnTick()

     AutoFarm()
	 AutoQ()
	 Kombo()
	 AutoIgnite(unit)
	 
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
end
end



function AutoIgnite(unit)
if (Config.autoignite) then
	if ValidTarget(unit, 600) and unit.health <= 50 + (20 * myHero.level) then
		if Igniteready then
			CastSpell(Ignite.slot, unit)
		end
	end
end
end

function OnDraw()

		DrawCircle3D(myHero.x, myHero.y, myHero.z, 650)
		if (myHero.health < 400) then
			DrawText("Uyari: Dusuk HP! Olme ihtimalin yuksek!", 25, 200, 100, 0xFFFF0000)
		end
		if (myHero.mana < 200) then 
			DrawText("Uyari: Dusuk enerji! Kombo icin suanda yeterli enerjin yok!", 25, 200, 130, 0xFFFFFF00)
		end
end
