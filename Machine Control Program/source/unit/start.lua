unit.hideWidget()

--[[
	split a string on a delimiter
	By jericho
]]
function strSplit(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

--[[
	check if a table contains an element
	By Jericho
]]
function hasValue(tab, val)
    for _,v in ipairs(tab) do
        if v == val then
            return true
        end
    end
    return false
end



function removeQualityInName(name)
    if not name then return '' end
    return name:lower():gsub('basic ', ''):gsub('uncommon ', ''):gsub('advanced ', ''):gsub('rare ', ''):gsub('exotic ', '')
end

databank = nil
industries = {}
for slot_name, slot in pairs(unit) do
    if
        type(slot) == "table"
        and type(slot.export) == "table"
        and slot.getClass
    then
        slot_type = slot.getClass():lower()
        if slot_type == 'databankunit' then
            databank = slot
        end
        if (slot_type:find("industry")) then
            table.insert(industries, slot)
        end
    end
end
if databank ~= nil then
    for _,slot in pairs(industries) do
        local slot_id = slot.getLocalId()
        if databank.hasKey(tostring(slot_id)) == 1 then
            local command = databank.getStringValue(slot_id)
            if command ~= nil and command ~= "" then
                if command:lower() == "start" then
                    slot.start()
                elseif command:lower():find("maintain") then
                    local splitted = strSplit(command, "_")
                    local quantity = tonumber(splitted[2])
                    slot.startAndMaintain(quantity)
                elseif command:lower():find("batch") then
                    local splitted = strSplit(command, "_")
                    local quantity = tonumber(splitted[2])
                    slot.batchStart(quantity)
                elseif command:lower() == "stop" then
                    slot.hardStop(0)
                elseif command:lower() == "soft_stop" then
                    slot.softStop()
                end
                databank.setStringValue(id, "")
            end
        end
    end
end
unit.exit()
