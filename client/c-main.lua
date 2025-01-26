local FeatherMenu = exports['feather-menu'].initiate()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(config.timer * 60000)
        TriggerServerEvent("legends-paychecks:paycheck")
    end
end)

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local billableamount = 0
local playerID = ''

local function openBillingMenu()
    local BillingMenu = FeatherMenu:RegisterMenu('billing:menu', {
        top = '30%',
        left = '30%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '800px',
        style = {},
        contentslot = {
            style = {
                ['height'] = '300px',
                ['min-height'] = '300px'
            }
        },
        draggable = true,
        canclose = true
    })

    local BillingPage = BillingMenu:RegisterPage('billing:page')
    local ConfirmPage = BillingMenu:RegisterPage('confirm:page')

    -- Add header
    BillingPage:RegisterElement('header', {
        value = 'Billing System',
        slot = 'header',
        style = {}
    })

    -- Add player ID input
    BillingPage:RegisterElement('input', {
        label = 'Player ID',
        placeholder = 'Enter Player ID',
        style = {}
    }, function(data)
        playerID = data.value
    end)

    -- Add bill amount input
    BillingPage:RegisterElement('input', {
        label = 'Bill Amount',
        placeholder = 'Enter Bill Amount',
        style = {}
    }, function(data)
        billableamount = data.value
    end)

    -- Add checkbox for confirmation
    BillingPage:RegisterElement('checkbox', {
        label = 'I confirm the details are correct',
        start = false
    }, function(data)
    end)

    -- Add bill button
    BillingPage:RegisterElement('button', {
        label = 'Bill',
        style = {},
        slot = 'footer'
    }, function()
        local billerID = GetPlayerServerId(PlayerId())
        -- Trigger server event with billing details
        TriggerServerEvent('legends-paychecks:requestConfirm', billerID, playerID, billableamount)
        BillingMenu:Close()
        print('Biller ID: ' .. billerID .. " | Player ID: " .. playerID .. " | Bill amount: " .. billableamount)
    end)

    ConfirmPage:RegisterElement('header', {
        value = 'Confirm Billing Details',
        slot = 'header',
        style = {}
    })

    -- Display player ID
    playerIDDisplay = ConfirmPage:RegisterElement('textdisplay', {
        value = "The player ID is ",
        style = {}
    })

    -- Display bill amount
    billAmountDisplay = ConfirmPage:RegisterElement('textdisplay', {
        value = "The Total amount is ",
        style = {}
    })

    -- Add confirm button
    ConfirmPage:RegisterElement('button', {
        label = 'Confirm',
        style = {}
    }, function()
        local billerID = GetPlayerServerId(PlayerId())
        -- Trigger server event with billing details
        TriggerServerEvent('legends-paychecks:acceptBill', billerID, playerID, billableamount)
        BillingMenu:Close()
    end)

    BillingMenu:Open({
        startupPage = BillingPage
    })
end

RegisterCommand(config.billCommand, function()
    local playerJob = LocalPlayer.state.Character.Job
    if playerJob and table.contains(config.billJob, playerJob) then
        openBillingMenu()
    else
        TriggerEvent('vorp:TipRight', "You are not authorized to use this command.", 3000)
    end
end)

RegisterNetEvent('legends-paychecks:openConfirmPage')
AddEventHandler('legends-paychecks:openConfirmPage', function(billerID, amount)
    local ConfirmMenu = FeatherMenu:RegisterMenu('confirm:menu', {
        top = '30%',
        left = '30%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '800px',
        style = {},
        contentslot = {
            style = {
                ['height'] = '300px',
                ['min-height'] = '300px'
            }
        },
        draggable = true,
        canclose = true
    })

    local ConfirmPage = ConfirmMenu:RegisterPage('confirm:page')

    ConfirmPage:RegisterElement('header', {
        value = 'Confirm Billing Details',
        slot = 'header',
        style = {}
    })

    ConfirmPage:RegisterElement('textdisplay', {
        value = "You have been billed $" .. amount,
        style = {}
    })

    ConfirmPage:RegisterElement('button', {
        label = 'Confirm',
        style = {}
    }, function()
        TriggerServerEvent('legends-paychecks:acceptBill', billerID, amount)
        ConfirmMenu:Close()
    end)

    ConfirmMenu:Open({
        startupPage = ConfirmPage
    })
end)

RegisterNetEvent('legends-paychecks:triggerSynSocietyAddCash')
AddEventHandler('legends-paychecks:triggerSynSocietyAddCash', function(billAmount, billerJob)
    TriggerServerEvent("syn_society:addcash", billAmount, billerJob)
end)

