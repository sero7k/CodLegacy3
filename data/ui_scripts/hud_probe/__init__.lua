-- hud_probe: research aid for the Legacy HUD port. In a match it writes the HUD's
-- widget tree and a few data-model values to hud_probe.txt (and the console log),
-- so the real child ids and fields can be read instead of guessed.
-- Remove this folder when the port is done.

local lines = {}

local function emit(text)
  lines[#lines + 1] = tostring(text)
  pcall(print, "[hud_probe] " .. tostring(text))
end

local function flush()
  pcall(function()
    FileIO.WriteFile("hud_probe.txt", table.concat(lines, "\n") .. "\n", false)
  end)
end

local function describe(el)
  local parts = { tostring(el.id or "?") }
  pcall(function()
    if el.getText then
      local t = el:getText()
      if t and t ~= "" then
        parts[#parts + 1] = "text=" .. tostring(t)
      end
    end
  end)
  pcall(function()
    if el.getLocalRect then
      local l, t, r, b = el:getLocalRect()
      parts[#parts + 1] = string.format("rect=%s,%s,%s,%s", tostring(l), tostring(t), tostring(r), tostring(b))
    end
  end)
  pcall(function()
    if el.getAlpha then
      parts[#parts + 1] = "a=" .. tostring(el:getAlpha())
    end
  end)
  return table.concat(parts, " ")
end

local function walk(el, depth, count)
  if not el or depth > 7 or count.n > 1500 then
    return
  end
  count.n = count.n + 1
  emit(string.rep("  ", depth) .. describe(el))
  local ok, child = pcall(function()
    return el.getFirstChild and el:getFirstChild() or nil
  end)
  while ok and child do
    walk(child, depth + 1, count)
    ok, child = pcall(function()
      return child:getNextSibling()
    end)
  end
end

local function fields(menu)
  local names = {}
  for key, value in pairs(menu) do
    if type(key) == "string" and type(value) == "table" and value.id then
      names[#names + 1] = key .. "=" .. tostring(value.id)
    end
  end
  table.sort(names)
  emit("menu fields holding widgets: " .. table.concat(names, ", "))
end

local MODEL_PATHS = {
  "currentWeapon.ammoInClip", "currentWeapon.ammoStock", "currentWeapon.ammoInClip2",
  "currentWeapon.weaponName", "currentWeapon.weapon", "currentWeapon.equippedWeaponName",
  "currentWeapon.viewmodelWeaponName", "currentWeapon.hudNum",
  "hudItems.playerScore", "hudItems.team1.roundsWon", "hudItems.team2.roundsWon",
  "hudItems.armorPercent", "gameScore.playerScore", "gameScore.axisScore", "gameScore.alliesScore",
  "factions.team1.name", "factions.team2.name", "hudItems.timeRemaining", "hudItems.gameTimer",
  "playerAbilities.playerGadget0.isReady", "hudItems.kills", "hudItems.deaths",
}

local function models(controller)
  pcall(function()
    local root = Engine.GetModelForController(controller)
    for _, path in ipairs(MODEL_PATHS) do
      local ok, value = pcall(function()
        local model = Engine.GetModel(root, path)
        if not model then
          return "<no model>"
        end
        return tostring(Engine.GetModelValue(model))
      end)
      emit("model " .. path .. " = " .. (ok and value or "<error>"))
    end
  end)
end

local function dump(menu, controller, label)
  emit("=== " .. label .. " ===")
  pcall(fields, menu)
  pcall(walk, menu, 0, { n = 0 })
  pcall(models, controller)
  flush()
end

local original = LUI.createMenu and LUI.createMenu.T7Hud_MP
if not original then
  emit("T7Hud_MP not present; nothing to probe")
  flush()
  return
end

LUI.createMenu.T7Hud_MP = function(controller)
  local menu = original(controller)
  pcall(function()
    dump(menu, controller, "T7Hud_MP built")
    local timer = LUI.UITimer.newElementTimer(6000, true, function()
      pcall(dump, menu, controller, "T7Hud_MP after 6s")
    end)
    menu:addElement(timer)
  end)
  return menu
end
