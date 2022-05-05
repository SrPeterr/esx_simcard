# esx_simcard
FiveM Script - Usable Simcard

**Forum:** https://forum.cfx.re/t/release-esx-usable-simcard/4847008

**Discord Support:** https://discord.gg/5hHSBRHvJE

## Description
* Usable Simcard Item
* Changes the Phonenumber

If you are using Chezza Phone, have a look at the Phone Guides at https://chezza.dev and search for **Updating Phonenumber**!

## Config
```lua
Config = {}
----------------------------------------------------------------
Config.Locale = 'de'
Config.VersionChecker = true
Config.Debug = true
----------------------------------------------------------------
-- You can choose between 'ESX' and 'QBCore'
Config.Framework = 'ESX' -- 'ESX' or 'QBCore'
-- Chezza Phone v2 // GcPhone // D-Phone
Config.Phone = 'chezza' -- 'chezza', 'gcphone' or 'dphone'
----------------------------------------------------------------
Config.needPhone = true -- Player has to have a phone in inventory
Config.phoneItem = 'phone' -- This should be your phone item
Config.usableItem = 'simcard' -- Add this to your items table in database
Config.removeItem = true -- Set to false if you dont want the item to be deleted after use
Config.StartingDigit = "094" -- the starting digits for phone number // Number would be 094XXXXXX
----------------------------------------------------------------
Config.Database = {
    numberDB = 'phones', -- Table for phonenumbers // Chezza Phone: 'phones' // default: 'users'
    numberTB = 'phone_number',
    identifierTB = 'identifier'
}
----------------------------------------------------------------
-- Change the Event in this function to the Event that changes the Number in your Phone.
-- If you are using Chezza Phone, have a look at the Phone Guides at https://chezza.dev and search for 'Updating Phonenumber'

-- !!! This function is serverside !!!
function updateNumber(src, newNumber)
    if Config.Phone:match('chezza') then -- Chezza Phone V2
        TriggerEvent('phone:changeNumber', src, newNumber)
        TriggerClientEvent('phone:notify', src, { 
            app = 'settings', 
            title = Translation[Config.Locale]['phoneHeading'], 
            content = Translation[Config.Locale]['phoneText']
        })
    elseif Config.Phone:match('gcphone') then -- GcPhone
        TriggerEvent('gcPhone:allUpdate')

        if Config.Framework:match('ESX') then -- ESX Framework
            TriggerClientEvent('esx:showNotification', src, Translation[Config.Locale]['updateNumber'] .. newNumber .. Translation[Config.Locale]['updateNumber2'])
        elseif Config.Framework:match('QBCore') then -- QBCore Framework
            TriggerClientEvent('QBCore:Notify', source, Translation[Config.Locale]['updateNumber'] .. newNumber .. Translation[Config.Locale]['updateNumber2'], 'error', 5000)
        end
    elseif Config.Phone:match('dphone') then -- D-Phone
        TriggerClientEvent("d-phone:client:changenumber", src, newNumber)

        if Config.Framework:match('ESX') then -- ESX Framework
            TriggerClientEvent('esx:showNotification', src, Translation[Config.Locale]['updateNumber'] .. newNumber .. Translation[Config.Locale]['updateNumber2'])
        elseif Config.Framework:match('QBCore') then -- QBCore Framework
            TriggerClientEvent('QBCore:Notify', source, Translation[Config.Locale]['updateNumber'] .. newNumber .. Translation[Config.Locale]['updateNumber2'], 'error', 5000)
        end
    end
end
```

## Requirements
* ESX 1.2 *(v1-final)* // Legacy
* QBCore
* mysql-async // oxmysql

### Optional
* Chezza Phone (https://forum.cfx.re/t/paid-release-chezzas-phone-v2/4769379)

## License
**GNU General Public License v3.0**
