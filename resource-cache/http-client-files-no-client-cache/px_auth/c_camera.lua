--[[
    @author: psychol.
    @mail: nezymr69@gmail.com
    @project: Pixel (MTA)
]]

blur=exports.blur

CAM={}

CAM.alpha=200


CAM.render=function(pos)
    setCameraMatrix(1214.1243,827.6893,57.3035,1214.7180,828.4227,56.9724)
end

-- cameras

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);

    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;

    return x+dx, y+dy;
end