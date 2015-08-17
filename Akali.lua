if myHero.charName ~= "Akali" then return end

_G.AUTOUPDATE = false -- Change to "false" to disable auto updates!

local version = "0.3"
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

local QRKill, ERKill, IRKill, SAC, Sx = false
local Q = {name = "Mark of the Assassin", range = 600, ready = function() return myHero:CanUseSpell(_Q) == READY end}
local W = {name = "Twillight Shroud", ready = function() return myHero:CanUseSpell(_W) == READY end}
local E = {name = "Crescent Slash", range = 325, ready = function() return myHero:CanUseSpell(_E) == READY end}
local R = {name = "Shadow Dance", range = 700, ready = function() return myHero:CanUseSpell(_R) == READY end}

local GapCloserList = {
	{charName = "Aatrox", spellName = "AatroxQ", name = "Q"},
	{charName = "Akali", spellName = "AkaliShadowDance", name = "R"},
	{charName = "Alistar", spellName = "Headbutt", name = "W"},
	{charName = "Amumu", spellName = "BandageToss", name = "Q"},
	{charName = "Fiora", spellName = "FioraQ", name = "Q"},
	{charName = "Diana", spellName = "DianaTeleport", name = "W"},
	{charName = "Elise", spellName = "EliseSpiderQCast", name = "W"},
	{charName = "FiddleSticks", spellName = "Crowstorm", name = "R"},
	{charName = "Fizz", spellName = "FizzPiercingStrike", name = "Q"},
	{charName = "Gragas", spellName = "GragasE", name = "E"},
	{charName = "Hecarim", spellName = "HecarimUlt", name = "R"},
	{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", name = "E"},
	{charName = "Irelia", spellName = "IreliaGatotsu", name = "Q"},
	{charName = "Jax", spellName = "JaxLeapStrike", name = "Q"},
	{charName = "Katarina", spellName = "ShadowStep", name = "E"},
	{charName = "Kassadin", spellName = "RiftWalk", name = "R"},
	{charName = "Khazix", spellName = "KhazixE", name = "E"},
	{charName = "Khazix", spellName = "khazixelong", name = "Evolved E"},
	{charName = "LeBlanc", spellName = "LeblancSlide", name = "W"},
	{charName = "LeBlanc", spellName = "LeblancSlideM", name = "UltW"},
	{charName = "LeeSin", spellName = "BlindMonkQTwo", name = "Q"},
	{charName = "Leona", spellName = "LeonaZenithBlade", name = "E"},
	{charName = "Malphite", spellName = "UFSlash", name = "R"},
	{charName = "Nautilus", spellName = "NautilusAnchorDrag", name = "Q"},
	{charName = "Pantheon", spellName = "Pantheon_LeapBash", name = "R"},
	{charName = "Poppy", spellName = "PoppyHeroicCharge", name = "W"},
	{charName = "Renekton", spellName = "RenektonSliceAndDice", name = "E"},
	{charName = "Riven", spellName = "RivenTriCleave", name = "E"},
	{charName = "Sejuani", spellName = "SejuaniArcticAssault", name = "E"},
	{charName = "Shen", spellName = "ShenShadowDash", name = "E"},
	{charName = "Tristana", spellName = "RocketJump", name = "W"},
	{charName = "Tryndamere", spellName = "slashCast", name = "E"},
	{charName = "Vi", spellName = "ViQ", name = "Q"},
	{charName = "MonkeyKing", spellName = "MonkeyKingNimbus", name = "Q"},
	{charName = "XinZhao", spellName = "XenZhaoSweep", name = "Q"},
	{charName = "Yasuo", spellName = "YasuoDashWrapper", name = "E"},
}

function OnLoad()
	PriorityOnLoad()
	
	if _G.Reborn_Loaded ~= nil then
		SAC = true
	else 
		Sx = true
		require "SxOrbWalk"
	end
	CustomOnLoad()
end

function CustomOnLoad()
	AddMsgCallback(CustomOnWndMsg)
	AddDrawCallback(CustomOnDraw)		
	AddProcessSpellCallback(CustomOnProcessSpell)
	AddTickCallback(CustomOnTick)
	Variables()
	Menu()
end

function CustomOnTick()
	Checks()
	
	if myHero.dead then return end
	
	ComboKey = Config.keys.combo
	HarassKey = Config.keys.harass
	AutoHarassKey = Config.keys.harass2
	FarmKey = Config.keys.farmCS
	ClearKey = Config.keys.clearCS
	
	if ComboKey then Combo(Target) end
	if HarassKey or AutoHarassKey then Harass(Target) end
	if Config.harass.q.autoQ then AutoQ() end
	if Config.farm.q.autoQ then FarmQ() end
	if Config.harass.e.autoE then AutoE() end
	if Config.farm.e.autoE then FarmE() end
	if Config.ks.ks then KillSteal() end
	if FarmKey or Config.keys.farmCS2 and not ComboKey and not HarassKey and not AutoHarassKey then LastHitMode() end
	if ClearKeyS or Config.keys.clearCS2 and not ComboKey and not HarassKey and not AutoHarassKey then end
	if ClearKey or Config.keys.clearCS2 and not ComboKey and not HarassKey and not AutoHarassKey then end
	if Config.misc.zhonyas.zhonyas then Zhonyas() end
end

function CountEnemyHeroInRange(range)
	local enemyInRange = 0
		for i = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(i)
				if ValidTarget(hero,range) then
			enemyInRange = enemyInRange + 1
			end
		end
	return enemyInRange
end

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if Config.combo.useItems then
			UseItems(unit)
		end
		if Config.combo.r.useR and R.ready then
			if Config.combo.w.useW and W.ready then
			DelayAction(function() CastSpell(_W, myHero.x, myHero.z) end, 0.5)
			end
		end
		if Config.combo.r.useR and Config.combo.w.useW and W.ready and R.ready then
			CastSpell(_R, unit)
			DelayAction(function() CastSpell(_W, myHero.x, myHero.z) end, 0.5)
		else 
			CastSpell(_R, unit)
		end
		if Config.combo.q.useQ then
			CastSpell(_Q, unit)
			myHero:Attack(unit)
		end
		if Config.combo.e.useE and not Q.ready then
			CastSpell(_E)
		end
	end
end

function Harass(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if Config.harass.q.useQ then 
			CastSpell(_Q, unit)
		end
		if Config.harass.e.useE and not Q.ready then
			CastSpell(_E, unit)
		end
	end
end

function LastHitMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil then
				if ValidTarget(minion, Q.range) and Config.farm.q.farmQ and Q.ready and GetDistance(minion) > myHero.range and getDmg("Q", minion, myHero) >= minion.health then
					CastSpell(_Q, minion)
				end
				if ValidTarget(minion, E.range) and Config.farm.e.farmE and E.ready and getDmg("E", minion, myHero) >= minion.health then 
					CastSpell(_E)
			end
		end
	end
end

function LaneClearMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil and ValidTarget(minion, Q.range) then
				if Q.ready and Config.farm.q.clearQ then
					if getDmg("Q", minion, myHero) >= minion.health then
						CastSpell(_Q, minion)
					else 
						CastSpell(_Q, minion)
					end
				end
				if ValidTarget(minion, E.range) and E.ready and Config.farm.e.clearE then
					if getDmg("E", minion, myHero) >= minion.health then
						CastSpell(_E, minion)
					else
						CastSpell(_E)
				end
			end
		end
	end
end

function KillStealR(unit)
	if ((myHero.health/myHero.maxHealth)*100) <= Config.ks.KSRHP then
		if QRKill then
			if unit ~= nil and GetDistance(unit) < (R.range+Q.range) and GetDistance(unit) > R.range then
				local champ= GetHero() or GetMinion()
				if champ ~= nil and GetDistance(champ, unit) < Q.range then
					CastSpell(_R, champ)
					DelayAction(function() CastSpell(_Q, unit) end, 0.5)
				end
			end
		elseif ERKill then
			if unit ~= nil and GetDistance(unit) < (R.range+E.range) and GetDistance(unit) > R.range then
				local champ = GetHero() or GetMinion()
				if champ ~= nil and GetDistance(champ, unit) < Q.range then
					CastSpell(_R, champ)
					DelayAction(function() CastSpell(_E, unit) end, 0.5)
				end
			end
		elseif IRKill then
			if unit ~= nil and GetDistance(unit) (R.range+Ignite.range) and GetDistance(unit) > R.range then
				local champ = GetHero() or GetMinion()
				if champ ~= nil and GetDistance(champ, unit) > Q.range then
					CastSpell(_R, champ)
					DelayAction(function() CastSpell(Ignite.slot, unit) end, 0.5)
				end
			end
		end
	end
end

function KillSteal()
	for _, enemy in ipairs(GetEnemyHeroes()) do	
			local iDmg = (50 + (20 * myHero.level))
			local qDmg = getDmg("Q", enemy, myHero)
			local eDmg = getDmg("E", enemy, myHero)
			local rDmg = getDmg("R", enemy, myHero)
		if enemy ~= nil and ValidTarget(enemy, R.range) then
			if enemy.health <= qDmg and ValidTarget(enemy, Q.range) and Q.ready then
				CastSpell(_Q, enemy)
			elseif enemy.health <= (qDmg + eDmg) and ValidTarget(enemy, E.range) and Q.ready and E.ready then
				CastSpell(_Q, enemy)
				CastSpell(_E, enemy)
			elseif enemy.health <= (qDmg + rDmg) and ValidTarget(enemy, R.range) and Q.ready and R.ready and Config.ks.useR then
				CastSpell(_R, enemy)
				CastSpell(_Q, enemy)
			elseif enemy.health <= (qDmg + rDmg) and ValidTarget(enemy, R.range+Q.range) and GetDistance(enemy) > R.range and Q.ready and R.ready and Config.ks.useR and Config.ks.useR2 then
				KillStealR(enemy)
				QRKill = true
				ERKill = false
				IRKill = false
			elseif enemy.health <= (eDmg+rDmg) and ValidTarget(enemy, R.range+E.range) and GetDistance(enemy) > R.range and E.ready and R.ready and Config.ks.useR and Config.ks.useR2 then
				KillStealR(enemy)
				QRKill = false
				ERKill = true
				IRKill = false
			elseif enemy.health <= (iDmg+rDmg) and ValidTarget(enemy, R.range+Ignite.range) and GetDistance(enemy) > R.range and Igniteready and R.ready and Config.ks.useR and Config.ks.useR2 then
				KillStealR(enemy)
				QRKill = false
				ERKill = false
				IRKill = true
			elseif enemy.health <= (qDmg + iDmg) and ValidTarget(enemy, Q.range) and Q.ready and Igniteready then
				CastSpell(_Q, enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= eDmg and ValidTarget(enemy, E.range) and E.ready then
				CastSpell(_E, enemy)
			elseif enemy.health <= (eDmg + rDmg) and ValidTarget(enemy, R.range) and R.ready and E.ready and Config.ks.useR then
				CastSpell(_R, enemy)
				CastSpell(_E, enemy)
			elseif enemy.health <= (eDmg + iDmg) and ValidTarget(enemy, E.range) and E.ready and Igniteready then
				CastSpell(_E, enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= rDmg and ValidTarget(enemy, R.range) and R.ready and Config.ks.useR then
				CastSpell(_R, enemy)
			elseif enemy.health <= (rDmg + iDmg) and ValidTarget(enemy, R.range) and R.ready and Igniteready and Config.ks.useR then
				CastSpell(_R, enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (qDmg + eDmg + rDmg + iDmg) and ValidTarget(enemy, R.range) and Q.ready and E.ready and R.ready and Config.ks.useR then
				CastSpell(_R, enemy)
				CastSpell(_Q, enemy)
				CastSpell(_E, enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (qDmg + eDmg + rDmg) and ValidTarget(enemy, R.range) and Q.ready and E.ready and R.ready and Config.ks.useR then
				CastSpell(_R, enemy)
				CastSpell(_E, enemy)
				CastSpell(_Q, enemy)
			end
			if Config.ks.autoignite then AutoIgnite(enemy) end
		end
	end
end

function DmgCalc()
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
			if enemy ~= nil and ValidTarget(enemy) then
			local hp = enemy.health
			local iDmg = (50 + (20 * myHero.level))
			local qDmg = getDmg("Q", enemy, myHero)
			local eDmg = getDmg("E", enemy, myHero)
			local rDmg = getDmg("R", enemy, myHero)
			if hp > (qDmg+eDmg+iDmg) then
				killstring[enemy.networkID] = "Harass Him!!!"
			elseif hp < qDmg then
				killstring[enemy.networkID] = "Q Kill!"
			elseif hp < eDmg then
				killstring[enemy.networkID] = "E Kill!"
			elseif hp < rDmg then
				killstring[enemy.networkID] = "R Kill!"
            elseif hp < (iDmg) then
                killstring[enemy.networkID] = "Ignite Kill!"
			elseif hp < (qDmg+iDmg) then
				killstring[enemy.networkID] = "Q+Ignite Kill!"
			elseif hp < (eDmg+iDmg) then
				killstring[enemy.networkID] = "E+Ignite Kill!"
			elseif hp < (rDmg+iDmg) then
				killstring[enemy.networkID] = "R+Ignite Kill!"
			elseif hp < (qDmg+eDmg) then
                killstring[enemy.networkID] = "Q+E Kill!"
			elseif hp < (qDmg+rDmg) then
				killstring[enemy.networkID] = "Q+R Kill!"
			elseif hp < (eDmg+rDmg) then
				killstring[enemy.networkID] = "E+R Kill!"
			elseif hp < (qDmg+eDmg+rDmg) then
				killstring[enemy.networkID] = "Q+E+R Kill!"
			elseif hp < (qDmg+eDmg+iDmg) then
                killstring[enemy.networkID] = "Q+E+Ignite Kill!"
			elseif hp < (qDmg+eDmg+rDmg+iDmg) then
				killstring[enemy.networkID] = "Q+E+R+Ignite Kill!"
			end
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

function Zhonyas()
	local zSlot = GetInventorySlotItem(3157)
		if zSlot ~= nil and myHero:CanUseSpell(zSlot) == READY then
			local zRange = Config.misc.zhonyas.zRange
			local zAmount = Config.misc.zhonyas.zAmount
			local health = myHero.health
			local maxHealth = myHero.maxHealth
				if ((health/maxHealth)*100) <= Config.misc.zhonyas.zhonyasHP and CountEnemyHeroInRange(zRange) >= zAmount then
			CastSpell(zSlot)
		end
	end
end

function Checks()
	Q.ready = (myHero:CanUseSpell(_Q) == READY)
	W.ready = (myHero:CanUseSpell(_W) == READY)
	E.ready = (myHero:CanUseSpell(_E) == READY)
	R.ready = (myHero:CanUseSpell(_R) == READY)
	
	Igniteready = (Ignite.slot ~= nil and myHero:CanUseSpell(Ignite.slot) == READY)
	
	Target = GetCustomTarget()
	TargetSelector:update()
	
	if Sx then
		SxOrb:ForceTarget(Target)
	end
	
	
end

function Menu()

	Config = scriptConfig("STRiX's Akali", "Akali1") 
	Config:addSubMenu("Combo Settings", "combo")
		Config.combo:addParam("combomode", "Combo Mode", SCRIPT_PARAM_LIST, 1, {"RQWE", "QRWE"})
		Config.combo:addParam("useItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("focus", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addSubMenu("Q Settings", "q")
			Config.combo.q:addParam("useQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addSubMenu("W Settings", "w")
			Config.combo.w:addParam("useW", "Use W after ult", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addSubMenu("E Settings", "e")
			Config.combo.e:addParam("useE", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addSubMenu("R Settings", "r")
			Config.combo.r:addParam("useR", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
			
			
		
	Config:addSubMenu("Harass Settings", "harass")
		Config.harass:addSubMenu("Q Settings", "q")
			Config.harass.q:addParam("useQ", "Use Q to Harass", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addSubMenu("E Settings", "e")
			Config.harass.e:addParam("useE", "Use E to Harass", SCRIPT_PARAM_ONOFF, true)
	Config:addSubMenu("Farm/Clear Settings", "farm")
		Config.farm:addSubMenu("Q Settings", "q")
			Config.farm.q:addParam("farmQ", "Use Q to Farm", SCRIPT_PARAM_ONOFF, true)
			Config.farm.q:addParam("clearQ", "Use Q to LaneClear", SCRIPT_PARAM_ONOFF, true)
			
			
		Config.farm:addSubMenu("E Settings", "e")
			Config.farm.e:addParam("farmE", "Use E to Farm", SCRIPT_PARAM_ONOFF, true)
			Config.farm.e:addParam("clearE", "Use E to LaneClear", SCRIPT_PARAM_ONOFF, true)

	Config:addSubMenu("Killsteal Settings", "ks")
		Config.ks:addParam("ks", "Use KS", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("useR", "Use R to KS", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("useR2", "Use R on Minions/Enemies to KS", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("KSRHP", "Min. HP %", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
		Config.ks:addParam("autoignite", "Auto Ignite to KS", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("Draw Setttings - yakinda", "draw")
		Config.draw:addParam("mdraw", "Disable all Drawings", SCRIPT_PARAM_ONOFF, false)
		Config.draw:addParam("drawDD", "Draw Dmg Text", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawHP", "Draw Damage on HPBar", SCRIPT_PARAM_ONOFF, true)
        Config.draw:addParam("Target2", "Draw Circle around Target", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("text", "Draw Current Target", SCRIPT_PARAM_ONOFF, true)
        Config.draw:addParam("myHero", "Draw AA Range", SCRIPT_PARAM_ONOFF, false)
        
		Config.draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
		
		Config.draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
		
		Config.draw:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
		
		
			
			
	Config:addSubMenu("Misc Settings", "misc")
	Config.misc:addSubMenu("GapCloser Spells", "ES2")
		for i, enemy in ipairs(GetEnemyHeroes()) do
			for _, champ in pairs(GapCloserList) do
				if enemy.charName == champ.charName then
					Config.misc.ES2:addParam(champ.spellName, "GapCloser "..champ.charName.." "..champ.name, SCRIPT_PARAM_ONOFF, true)
				end
			end
		end
		
	Config.misc:addParam("UG", "Auto W on enemy GapCloser (W)", SCRIPT_PARAM_ONOFF, true)
	Config.misc:addSubMenu("W Settings", "w")
		Config.misc.w:addParam("autoW", "Use Auto W", SCRIPT_PARAM_ONOFF, false)
		Config.misc.w:addParam("wCount", "Auto W Enemies", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
		Config.misc.w:addParam("wRange", "Auto W Range", SCRIPT_PARAM_SLICE, 300, 0, 1200, 0)
		Config.misc.w:addParam("wHealth", "Auto W Health", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
		Config.misc.w:addParam("wCount2", "Auto LifeSafe W Enemies", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
	Config.misc:addSubMenu("Zhonyas", "zhonyas")
		Config.misc.zhonyas:addParam("zhonyas", "Auto Zhonyas", SCRIPT_PARAM_ONOFF, true)
		Config.misc.zhonyas:addParam("zhonyasHP", "Use Zhonyas at % health", SCRIPT_PARAM_SLICE, 20, 0, 100 , 0)
		Config.misc.zhonyas:addParam("zRange", "Zhonyas Range", SCRIPT_PARAM_SLICE, 500, 0, 800, 0)
		Config.misc.zhonyas:addParam("zAmount", "Use Zhonyas atx Enemies", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
		
	Config:addSubMenu("Key Settings", "keys")
	Config.keys:addParam("combo", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Config.keys:addParam("haras", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	Config.keys:addParam("lasthit", "Farm Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	Config.keys:addParam("laneclear", "Clear Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("M"))
	
	
	Config:addSubMenu(" Orbwalker", "Orbwalking")
	if Sx then
		SxOrb:LoadToMenu(Config.Orbwalking)
	elseif SAC then
		Config.Orbwalking:addParam("qqq", "SAC Detected and Loaded!", SCRIPT_PARAM_INFO,"")
	end
	
	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, R.range, DAMAGE_MAGIC, true)
	TargetSelector.name = "Akali"
	Config:addTS(TargetSelector)
	
	Config:addParam("info", "Version:", SCRIPT_PARAM_INFO, ""..version.."")
	Config:addParam("info2", "Author:", SCRIPT_PARAM_INFO, ""..author.."")
	
	Config.keys:permaShow("combo")
	Config.keys:permaShow("haras")
	Config.keys:permaShow("lasthit")
	Config.keys:permaShow("laneclear")
end

function Variables()
	
	Ignite = { name = "summonerdot", range = 600, slot = nil }
	enemyMinions = minionManager(MINION_ENEMY, Q.range, myHero, MINION_SORT_MAXHEALTH_DEC)
	
	if myHero:GetSpellData(SUMMONER_1).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_1  
	elseif myHero:GetSpellData(SUMMONER_2).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_2  
	end
	
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2	
	
	local ts
	
	if Sx then
		SxOrb = SxOrbWalk()
	end
	
	killstring = {}
	

	priorityTable = {
			AP = {
				"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
				"Kassadin", "Ezreal", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
				"Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"
			},
			
			Support = {
				"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"
			},
			
			Tank = {
				"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear",
				"Warwick", "Yorick", "Zac"
			},
			
			AD_Carry = {
				"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
				"Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"
			},
			
			Bruiser = {
				"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy",
				"Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"
			}
	}

	Items = {
		BRK = { id = 3153, range = 450, reqTarget = true, slot = nil },
		BWC = { id = 3144, range = 400, reqTarget = true, slot = nil },
		DFG = { id = 3128, range = 750, reqTarget = true, slot = nil },
		HGB = { id = 3146, range = 400, reqTarget = true, slot = nil },
		RSH = { id = 3074, range = 350, reqTarget = false, slot = nil },
		STD = { id = 3131, range = 350, reqTarget = false, slot = nil },
		TMT = { id = 3077, range = 350, reqTarget = false, slot = nil },
		YGB = { id = 3142, range = 350, reqTarget = false, slot = nil },
		BFT = { id = 3188, range = 750, reqTarget = true, slot = nil },
		RND = { id = 3143, range = 275, reqTarget = false, slot = nil }
	}
	
end

function SetPriority(table, hero, priority)
	for i=1, #table, 1 do
		if hero.charName:find(table[i]) ~= nil then
			TS_SetHeroPriority(priority, hero.charName)
		end
	end
end
 
function arrangePrioritys()
		for i, enemy in ipairs(GetEnemyHeroes()) do
		SetPriority(priorityTable.AD_Carry, enemy, 1)
		SetPriority(priorityTable.AP,	   enemy, 2)
		SetPriority(priorityTable.Support,  enemy, 3)
		SetPriority(priorityTable.Bruiser,  enemy, 4)
		SetPriority(priorityTable.Tank,	 enemy, 5)
		end
end

function arrangePrioritysTT()
        for i, enemy in ipairs(GetEnemyHeroes()) do
		SetPriority(priorityTable.AD_Carry, enemy, 1)
		SetPriority(priorityTable.AP,       enemy, 1)
		SetPriority(priorityTable.Support,  enemy, 2)
		SetPriority(priorityTable.Bruiser,  enemy, 2)
		SetPriority(priorityTable.Tank,     enemy, 3)
        end
end

function PriorityOnLoad()
	if heroManager.iCount < 10 or ( heroManager.iCount < 6) then
		print("<b><font color=\"#6699FF\">STRiX's Akali</font></b> <font color=\"#FFFFFF\">Ayip degil mi ak script kullaniyon.</font>")
	elseif heroManager.iCount == 6 then
		arrangePrioritysTT()
    else
		arrangePrioritys()
	end
end

for i, enemy in ipairs(GetEnemyHeroes()) do
    enemy.barData = {PercentageOffset = {x = 0, y = 0} }
end

function GetEnemyHPBarPos(enemy)

    if not enemy.barData then
        return
    end

    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)
    local barPosPercentageOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)

    local BarPosOffsetX = 169
    local BarPosOffsetY = 47
    local CorrectionX = 16
    local CorrectionY = 4

    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 

    local StartPos = Point(barPos.x, barPos.y)
    local EndPos = Point(barPos.x + 103, barPos.y)

    return Point(StartPos.x, StartPos.y), Point(EndPos.x, EndPos.y)

end

function DrawIndicator(enemy)
	local Qdmg, Edmg, Rdmg, AAdmg = getDmg("Q", enemy, myHero), getDmg("E", enemy, myHero), getDmg("R", enemy, myHero), getDmg("AD", enemy, myHero)
	
	Qdmg = ((Q.ready and Qdmg) or 0)
	Edmg = ((E.ready and Edmg) or 0)
	Rdmg = ((R.ready and Rdmg) or 0)
	AAdmg = ((AAdmg) or 0)

    local damage = Qdmg + Edmg + Rdmg + AAdmg

    local SPos, EPos = GetEnemyHPBarPos(enemy)

    if not SPos then return end

    local barwidth = EPos.x - SPos.x
    local Position = SPos.x + math.max(0, (enemy.health - damage) / enemy.maxHealth) * barwidth

	DrawText("|", 16, math.floor(Position), math.floor(SPos.y + 8), ARGB(255,0,255,0))
    DrawText("HP: "..math.floor(enemy.health - damage), 12, math.floor(SPos.x + 25), math.floor(SPos.y - 15), (enemy.health - damage) > 0 and ARGB(255, 0, 255, 0) or  ARGB(255, 255, 0, 0))
end 

function UseItems(unit)
	if unit ~= nil then
		for _, item in pairs(Items) do
			item.slot = GetInventorySlotItem(item.id)
			if item.slot ~= nil then
				if item.reqTarget and GetDistance(unit) < item.range then
					CastSpell(item.slot, unit)
				elseif not item.reqTarget then
					if (GetDistance(unit) - getHitBoxRadius(myHero) - getHitBoxRadius(unit)) < 50 then
						CastSpell(item.slot)
					end
				end
			end
		end
	end
end

function getHitBoxRadius(target)
	return GetDistance(target.minBBox, target.maxBBox)/2
end

function TrueRange()
    return myHero.range + GetDistance(myHero, myHero.minBBox)
end

function GetHero()
	for i = 1, heroManager.iCount, 1 do
		local unit = heroManager:getHero(i)
		if not unit.dead and ValidTarget(unit) and ValidTarget(unit, E.range) and unit ~= myHero then 
			return unit
		end
	end
end

function GetMinion()
	enemyMinions:update()
	for i, minion in pairs(enemyMinions.objects) do
		if minion ~= nil and not minion.dead and GetDistance(minion) <= E.range then
			return minion
		end
	end
end

function GetCustomTarget()
 	TargetSelector:update() 
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1500) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
	return TargetSelector.target
end

function CustomOnWndMsg(Msg, Key)
	if Msg == WM_LBUTTONDOWN then
		local minD = 0
		local Target = nil
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) then
				if GetDistance(unit, mousePos) <= minD or Target == nil then
					minD = GetDistance(unit, mousePos)
					Target = unit
				end
			end
		end

		if Target and minD < 115 then
			if SelectedTarget and Target.charName == SelectedTarget.charName then
				SelectedTarget = nil
			else
				SelectedTarget = Target
			end
		end
	end
end

function OnDraw()


		if (myHero.health < 400) then
			DrawText("Uyari: Dusuk HP! Olme ihtimalin yuksek!", 20, 150, 100, 0xFFFF0000)
		end
		if (myHero.mana < 120) and (myHero.level <= 12) and not (myHero.dead) then 
			DrawText("Uyari: Dusuk enerji! Kombo icin suanda yeterli enerjin yok!", 20, 150, 130, 0xFFFFFF00)
		end
		if (myHero.mana < 100) and (myHero.level >= 13) and not (myHero.dead) then 
			DrawText("Uyari: Dusuk enerji! Kombo icin suanda yeterli enerjin yok!", 20, 150, 130, 0xFFFFFF00)
		end
		if (myHero.dead) then
			DrawText("WASTED", 50, 750, 170, 0xFFFF0000)
		end
		
		
			DmgCalc()
			for _, enemy in ipairs(GetEnemyHeroes()) do
				if ValidTarget(enemy, 100000) and killstring[enemy.networkID] ~= nil then
					local pos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
					DrawText(killstring[enemy.networkID], 20, pos.x - 35, pos.y - 40, 0xFFFFFF00)
				end
			end
end
