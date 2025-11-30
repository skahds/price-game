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

function RichText.parse(format)
  local parsed = {}
  local cursor = 1
  local len = #format

  while cursor <= len do
    local open_brace_pos = format:find("{", cursor, true)

    if open_brace_pos then
      -- Found an opening brace, check for preceding plain text
      if open_brace_pos > cursor then
        table.insert(parsed, format:sub(cursor, open_brace_pos - 1))
      end

      -- Find the closing brace for the tag
      local close_brace_pos = format:find("}", open_brace_pos + 1, true)
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
      -- Updated pattern to capture any non-space, non-brace characters as value
      for k, v in tag_content:gmatch("(%w+)=([^%s}]+)") do
        -- Try to convert to number, otherwise keep as string
        local num = tonumber(v)
        if num then
          args[k] = num
        else
          args[k] = v
        end
      end
      table.insert(parsed, args)

      cursor = close_brace_pos + 1 -- Move cursor past the closing brace
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

function RichText:setText(format, ...)
    local finalString = string.format(format, ...)
    self.format = RichText.parse(finalString)
    self:update()
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

function RichText:getWidth()
  return self.width
end

function RichText:getHeight()
  return self.height
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
          length = #effectOrStr,
          x = x,
          h = self.font:getHeight(),
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
        self.width = x
        self.height = self.font:getHeight(char)
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