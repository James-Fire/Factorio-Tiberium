if not mods["Krastorio2"] then
    return
end
--hide my crimes from the player
--krastorio2 generates some protype stuff for crushing and the "Welcome to the jungle" tech
if mods["Krastorio2"] then
    if settings.startup["tiberium-on"].value == "nauvis" then
        for prototypes in pairs(data.raw) do
            for _, name in ipairs({"tiberium-tiber-rock", "kr-crush-tiberium-tiber-rock"}) do
                if prototypes[name] then
                    prototypes[name].hidden_in_factoriopedia = true
                    prototypes[name].hidden = true
                end
            end
        end
    end
end