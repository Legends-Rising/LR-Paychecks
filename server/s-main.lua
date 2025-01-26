local VORPcore = exports.vorp_core:GetCore()

-- Function to send webhook messages
local function sendWebhookMessage(webhookURL, message)
    if webhookURL and webhookURL ~= "" then
        PerformHttpRequest(webhookURL, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                {
                    title = message.title,
                    color = 3447003,  -- Blue color
                    fields = message.fields
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end

-- Function to handle billing based on society type
local function handleBilling(source, billerJob, billAmount)
    if config.society == "Mega" then
        local CompaniesManager = exports['mega_companies']:api()
        CompaniesManager.addMoney(billerJob, billAmount)
        CompaniesManager.updateCompany(billerJob)
    elseif config.society == "Syn" then
        TriggerClientEvent("legends-paychecks:triggerSynSocietyAddCash", source, billAmount, billerJob)
    else
        print("Invalid society type in configuration")
    end
end

RegisterServerEvent("legends-paychecks:paycheck")
AddEventHandler("legends-paychecks:paycheck", function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local job = Character.job
    local grade = Character.jobGrade
    local firstName = Character.firstname or "Unknown"
    local lastName = Character.lastname or "Unknown"
    local characterName = firstName .. " " .. lastName

    for k, v in pairs(config.paycheckJob) do
        if job == v.job then
            for i, j in pairs(v.pay) do
                if grade == j.grade then
                    local paycheck = j.paycheck
                    Character.addCurrency(0, paycheck)
                    TriggerClientEvent("vorp:TipRight", _source, "You have received your paycheck of $"..paycheck, 3000)
                    
                    local webhookMessage = {
                        title = "Salary Paid",
                        fields = {
                            { name = "To", value = characterName, inline = true },
                            { name = "Amount", value = "$" .. paycheck, inline = true }
                        }
                    }
                    sendWebhookMessage(config.webhook, webhookMessage)
                end
            end
        end
    end
end)

RegisterServerEvent("legends-paychecks:requestConfirm")
AddEventHandler("legends-paychecks:requestConfirm", function(billerID, targetPlayerID, amount)
    TriggerClientEvent('legends-paychecks:openConfirmPage', targetPlayerID, billerID, amount)
end)

RegisterServerEvent("legends-paychecks:acceptBill")
AddEventHandler("legends-paychecks:acceptBill", function(billerID, amount)
    local _source = source
    local targetPlayer = VORPcore.getUser(_source)
    local targetCharacter = targetPlayer.getUsedCharacter
    local biller = VORPcore.getUser(billerID)
    local billerCharacter = biller.getUsedCharacter
    local billerJob = billerCharacter.job
    local targetName = targetCharacter.firstname .. " " .. targetCharacter.lastname
    local billerName = billerCharacter.firstname .. " " .. billerCharacter.lastname

    local commission = amount * config.billCommission
    local billAmount = amount - commission

    local currentBalance = targetCharacter.money
    if currentBalance - amount < -100 then
        TriggerClientEvent("vorp:TipRight", billerID, "The player cannot afford the bill. Their balance would go below $-100.", 3000)
        TriggerClientEvent("vorp:TipRight", _source, "You can't afford the bill", 3000)
        return
    end

    targetCharacter.removeCurrency(0, amount)
    billerCharacter.addCurrency(0, commission)

    -- Handle billing based on society type
    if config.society == "Mega" then
        local CompaniesManager = exports['mega_companies']:api()
        local currentAmount = CompaniesManager.getMoney(billerJob)
        CompaniesManager.addMoney(billerJob, billAmount)
        CompaniesManager.updateCompany(billerJob)
        local newAmount = CompaniesManager.getMoney(billerJob)

        local webhookMessage = {
            title = "Billing Info",
            fields = {
                { name = "Player", value = targetName .. " paid $" .. amount, inline = false },
                { name = "Biller", value = billerName .. " earned $" .. commission .. " commission", inline = false },
                { name = "Ledger Update", value = "$" .. billAmount .. " added to ledger for job " .. billerJob, inline = false },
                { name = "Ledger Old", value = "$" .. currentAmount .. " was in the ledger", inline = false },
                { name = "Ledger New Value", value = "$" .. newAmount .. " is now in the ledger", inline = false }
            }
        }
        sendWebhookMessage(config.webhook, webhookMessage)
    elseif config.society == "Syn" then
        -- Trigger client event to handle Syn society add cash
        TriggerClientEvent("legends-paychecks:triggerSynSocietyAddCash", _source, billAmount, billerJob)

        local webhookMessage = {
            title = "Billing Info",
            fields = {
                { name = "Player", value = targetName .. " paid $" .. amount, inline = false },
                { name = "Biller", value = billerName .. " earned $" .. commission .. " commission", inline = false },
                { name = "Ledger Update", value = "$" .. billAmount .. " added to ledger for job " .. billerJob, inline = false }
            }
        }
        sendWebhookMessage(config.webhook, webhookMessage)
    else
        print("Invalid society type in configuration")
    end

    TriggerClientEvent("vorp:TipRight", _source, "You have been billed for $" .. billAmount, 3000)
    TriggerClientEvent("vorp:TipRight", billerID, "You have successfully billed $" .. billAmount, 3000)
end)
