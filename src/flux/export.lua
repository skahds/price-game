local flux = require("src.flux.flux")

system.updateStorage("flux", flux)

system.on("@update", function ()
  flux.update(system.getStorage("dt"))
end)