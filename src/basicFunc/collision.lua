function main.normalizeRect(x, y, w, h)
  local nx, ny, nw, nh = x, y, w, h
  if nw < 0 then
    nx = x + w
    nw = -w
  end
  if nh < 0 then
    ny = y + h
    nh = -h
  end
  return nx, ny, nw, nh
end

function main.AABB_check(t1, t2)
  local x1,y1,x2,y2,w1,h1,w2,h2=t1.x,t1.y,t2.x,t2.y,t1.width or 0,t1.height or 0,t2.width or 0,t2.height or 0
  local sx1, sy1, sx2, sy2 = t1.sx or 1, t1.sy or 1, t2.sx or 1, t2.sy or 1
  w1, h1, w2, h2 = w1 * sx1, h1*sy1, w2*sx2, h2*sy2
  local ox1, oy1, ox2, oy2 = t1.ox or 0, t1.oy or 0, t2.ox or 0, t2.oy or 0
  ox1, oy1, ox2, oy2 = ox1*sx1, oy1*sy1, ox2*sx2, oy2*sy2
  
  x1, y1 = x1 - ox1, y1 - oy1
  x2, y2 = x2 - ox2, y2 - oy2

  local nx1, ny1, nw1, nh1 = main.normalizeRect(x1, y1, w1, h1)
  local nx2, ny2, nw2, nh2 = main.normalizeRect(x2, y2, w2, h2)
  
  if nx1 < nx2 + nw2 and
    nx1 + nw1 > nx2 and
    ny1 < ny2 + nh2 and
    ny1 + nh1 > ny2 then
      return true
  end

  return false
end

function main.CC_check(cir1, cir2, r1, r2)
  local dist = utils.distanceBetween(cir1.x, cir2.x, cir1.y, cir2.y)
  return r1+r2 > dist
end