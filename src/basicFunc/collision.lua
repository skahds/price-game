function main.AABB_check(t1, t2)
  local x1,y1,x2,y2,w1,h1,w2,h2=t1.x,t1.y,t2.x,t2.y,t1.width or 0,t1.height or 0,t2.width or 0,t2.height or 0
  
  if x1 < x2 + w2 and
    x1 + w1 > x2 and
    y1 < y2 + h2 and
    y1 + h1 > y2 then
      return true
  end

end

function main.CC_check(cir1, cir2, r1, r2)
  local dist = utils.distanceBetween(cir1.x, cir2.x, cir1.y, cir2.y)
  return r1+r2 > dist
end