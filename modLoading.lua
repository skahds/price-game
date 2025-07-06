system.sprites = {}

-- this is made by chatgipity, im not smart enough to use love.filesystem

local function requireFolder(folder)
  -- Get the list of items (files and folders) in the folder
  local items = love.filesystem.getDirectoryItems(folder)

  for _, item in ipairs(items) do
    -- if item:sub(1, 1) ~= "_" then

    local fullPath = folder .. "/" .. item
    local info = love.filesystem.getInfo(fullPath)

    if info.type == "file" and item:match("%.lua$") then
      -- Strip ".lua" and replace "/" with "." for proper require syntax
      local requirePath = fullPath:gsub("%.lua$", ""):gsub("/", ".")
      require(requirePath)
      print("[" .. os.date() .."]: Loaded file " .. requirePath)
    elseif info.type == "file" and item:match("%.png$") then
      -- Extract the file name without the extension
      local fileName = item:gsub("%.png$", "")
      -- Store the sprite with the file name as the key
      system.sprites[fileName] = love.graphics.newImage(fullPath)
      print("[" .. os.date() .."]: Loaded image " .. fileName)
    elseif info.type == "directory" then
      -- Recursively require files in subfolders
      requireFolder(fullPath)
    end
    -- end
  end
end

-- Call the function for the folder you want to load files from
requireFolder("src/basicFunc")
requireFolder("src/flux")
requireFolder("src/RichText")
requireFolder("src/camera")
requireFolder("src/renderer")
requireFolder("src/main")
requireFolder("src/ui")
requireFolder("src/game")
requireFolder("src/card")
requireFolder("src/content")
requireFolder("src/juice")