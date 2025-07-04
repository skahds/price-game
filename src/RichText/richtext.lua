-- this is made by iamcheeseman https://github.com/IAmCheeseman/love-rich-text/blob/main/richtext.lua

--[[
  The MIT License (MIT)

  Copyright (c) 2024 iamcheeseman

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
]]

local RichText = {}
RichText.__index = RichText

local effects = {}

function RichText.addEffect(name, fn)
  if effects[name] then
    error("Effect '" .. name .. "' already exists.")
  end

  effects[name] = fn
end

--THIS PART IS MODIFIED, THE ORIGINAL PARSE IS NOT AS SUCH
function RichText.parse(format)
  local tformat = {}
  local last_pos = 1 -- Keep track of the last position processed

  for text_segment, match_tag in format:gmatch("([^{]*)({.-})") do
    -- Add the text segment before the tag
    if text_segment and text_segment ~= "" then
      table.insert(tformat, text_segment)
    end

    -- Process the tag
    if match_tag then
      local inner = match_tag:sub(2, -2) -- Remove { and }
      local args = {}
      local name = inner:match("^[/%a]+") -- Extract effect name (e.g., "shake" or "/shake")

      if not name then
        -- Handle cases like {} or {  } or {invalid=arg} without a name
        error("Invalid rich text tag: " .. match_tag .. ". Tags must start with an effect name.")
      end

      args[1] = name -- The effect name is the first argument
      for k, v in inner:gmatch("(%w-)=([%w%.%-]+)") do
        -- Check if 'v' looks like a number
        if not v:match("^-?%d*%.?%d*$") then
          error("Invalid effect arg '" .. k .. "'. Only numbers (integers or decimals, positive/negative) are supported for values: " .. match_tag)
        end
        args[k] = tonumber(v)
      end
      table.insert(tformat, args)
    end
    -- Update last_pos to reflect the end of the current match
    -- This is a bit tricky with gmatch, as it iterates on its own.
    -- A simpler way is to check the remainder after the loop.
  end

  -- After the loop, check if there's any remaining text that wasn't part of a tag match
  -- This captures pure text strings or text after the last tag.
  local remaining_text = format:match("([^{]*)$") -- Match any non-'{' characters at the end
  if remaining_text and remaining_text ~= "" then
    -- Also, ensure we don't double-add if the string ended with a tag
    -- A more robust approach might be to use string.find to get positions.
    -- However, for the simple case of a string with no tags, this works.

    -- Let's re-think this `gmatch` approach. It's built for finding pairs.
    -- A more robust parsing loop would be better.

    -- Here's a simpler and more robust `parse` function that handles all cases:
    local parsed = {}
    local cursor = 1
    local len = #format

  while cursor <= len do
      local open_brace_pos, close_brace_pos = format:find("{", cursor, true)

      if open_brace_pos then
        -- Found an opening brace, check for preceding plain text
        if open_brace_pos > cursor then
          table.insert(parsed, format:sub(cursor, open_brace_pos - 1))
        end

        -- Find the closing brace for the tag
        close_brace_pos = format:find("}", open_brace_pos + 1, true)
        if not close_brace_pos then
          error("Unclosed rich text tag starting at position " .. open_brace_pos)
        end

        local tag_content = format:sub(open_brace_pos + 1, close_brace_pos - 1)
        local args = {}
        local name = tag_content:match("^[/%a]+")

        if not name then
          error("Invalid rich text tag: {" .. tag_content .. "}. Tags must start with an effect name (e.g., {color}, {/color}).")
        end

        args[1] = name
        for k, v in tag_content:gmatch("(%w-)=([%w%.%-]+)") do
          if not v:match("^-?%d*%.?%d*$") then
            error("Invalid effect arg '" .. k .. "' (value: '" .. v .. "') in tag {" .. tag_content .. "}. Only numbers (integers or decimals, positive/negative) are supported for values.")
          end
          args[k] = tonumber(v)
        end
        table.insert(parsed, args)

        cursor = close_brace_pos + 1 -- Move cursor past the tag
      else
        -- No more opening braces, the rest is plain text
        if cursor <= len then
          table.insert(parsed, format:sub(cursor))
        end
        break -- Done parsing
      end
    end

    return parsed
  end
end

function RichText.new(font, format)
  local instance = setmetatable({}, RichText)

  instance.font = font
  if type(format) == "table" then
    instance.format = format
  elseif type(format) == "string" then
    instance.format = RichText.parse(format)
  end
  instance.text = love.graphics.newTextBatch(font)
  instance:update()

  return instance
end

function RichText:setColor(r, g, b, a)
  self.color = {r, g, b, a}
end

function RichText:getColor()
  return unpack(self.color)
end

function RichText:setPosition(x, y)
  self.charx = x
  self.chary = y
end

function RichText:getPosition()
  return self.charx, self.chary
end

function RichText:setScale(x, y)
  self.scalex = x
  self.scaley = y
end

function RichText:getScale()
  return self.scalex, self.scaley
end

function RichText:setSkew(x, y)
  self.skewx = x
  self.skewy = y
end

function RichText:getSkew()
  return self.skewx, self.skewy
end

function RichText:setRotation(rotation)
  self.rotation = rotation
end

function RichText:getRotation()
  return self.rotation
end

function RichText:update()
  self.text:clear()

  local currentEffects = {}

  local x = 0

  self.rawText = ""

  for _, effectOrStr in ipairs(self.format) do
    if type(effectOrStr) == "string" then
      self.rawText = self.rawText .. effectOrStr
      for i=1, #effectOrStr do
        local char = effectOrStr:sub(i, i)
        self.charx = 0
        self.chary = 0
        self.scalex = 1
        self.scaley = 1
        self.skewx = 0
        self.skewy = 0
        self.rotation = 0
        self.color = {1, 1, 1, 1}

        local info = {
          char = char,
          index = i,
          length = #effectOrStr
        }
        for _, effect in pairs(currentEffects) do
          effect.fn(self, effect.args, info)
        end

        self.text:add(
          {self.color, char},
          x + self.charx, self.chary,
          self.rotation,
          self.scalex, self.scaley,
          0, 0, self.skewx, self.skewy)
        x = x + self.font:getWidth(char) * self.scalex
      end
    elseif type(effectOrStr) == "table" then
      local effectName = effectOrStr[1]
      if effectName:sub(1, 1) == "/" then
        effectName = effectName:sub(2, -1)

        if not currentEffects[effectName] then
          error("Effect '" .. effectName .. "' does not have a matching opening tag.")
        end

        currentEffects[effectName] = nil
      else
        if not effects[effectName] then
          error("Effect '" .. effectName .. "' does not exist.")
        end

        currentEffects[effectName] = {
          fn = effects[effectName],
          args = effectOrStr,
        }
      end
    end
  end
end

function RichText:draw(...)
  love.graphics.draw(self.text, ...)
end

return RichText