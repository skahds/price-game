return {
  -- basic settings:
  name = 'ChartWeaver', -- name of the game for your executable
  developer = 'Skahd', -- dev name used in metadata of the file
  output = 'build', -- output location for your game, defaults to $SAVE_DIRECTORY
  icon = 'icon.png',
  version = '0.1', -- 'version' of your game, used to name the folder in output
  love = '12.0', -- version of LÖVE to use, must match github releases
  ignore = {'build', 'ignoreme.txt', 'resources', 'msys-2.0.dll', 'msys-stdc++-6.dll', 'msys-gcc_s-seh-1.dll', 'steam_appid.txt'}, -- folders/files to ignore in your project
  -- icon = 'resources/icon.png', -- 256x256px PNG icon for game, will be converted for you
  
  -- optional settings:
  use32bit = false, -- set true to build windows 32-bit as well as 64-bit
  identifier = 'com.love.supergame', -- macos team identifier, defaults to game.developer.name
  libs = { -- files to place in output directly rather than fuse
    windows = {'resources/luasteam.dll', 'resources/msys-2.0.dll', 'resources/msys-gcc_s-seh-1.dll', 'resources/msys-stdc++-6.dll', 'steam_api64.dll', 'resources/steam_api64.lib', 'resources/steam_api.dll'},
    -- all = {}
  },
  hooks = { -- hooks to run commands via os.execute before or after building
    before_build = 'resources/preprocess.sh',
    after_build = 'resources/postprocess.sh'
  },
  platforms = {'windows', "linux"} -- set if you only want to build for a specific platform
  
}