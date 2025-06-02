WALL = {}

-- Utility: Normalize direction vector
local function normalize(dx, dy, dz)
    local length = math.sqrt(dx^2 + dy^2 + dz^2)
    return dx/length, dy/length, dz/length
end

-- Utility: Rotate vector 90° around Y (right-hand direction)
local function getRightVector(dx, dy, dz)
    return dz, 0, -dx
end

-- Utility: Choose block type based on position
local function getBlockForSegment(pos, total, blocks)
    if pos == -total or pos == total then
        return blocks.edge
    elseif math.abs(pos) >= math.floor(total * 0.6) then
        return blocks.middleEdge
    else
        return blocks.middle
    end
end

-- STRAIGHT WALL
function WALL.STRAIGHT(x, y, z, dirx, diry, dirz, length, height, thickness, blocks)
    dirx, diry, dirz = normalize(dirx, diry, dirz)
    local rightX, _, rightZ = getRightVector(dirx, diry, dirz)

    for i = -length, length do
        local blockid = getBlockForSegment(i, length, blocks)
        for t = 0, thickness - 1 do
            local px = x + rightX * i + dirx * t
            local pz = z + rightZ * i + dirz * t
            for h = 0, height - 1 do
                Block:placeBlock(blockid, math.floor(px + 0.5), math.floor(y + h + 0.5), math.floor(pz + 0.5))
            end
        end
    end
end

-- CURVED WALL (Arc)
function WALL.CURVE(x, y, z, dirx, diry, dirz, radius, angleSpan, height, thickness, blocks)
    dirx, diry, dirz = normalize(dirx, diry, dirz)
    local baseAngle = math.atan2(-dirz, dirx)
    local steps = math.floor(angleSpan * 20)

    for i = -steps, steps do
        local t = i / steps
        local angle = baseAngle + t * angleSpan
        local ox, oz = math.cos(angle), -math.sin(angle)
        local blockid = getBlockForSegment(i, steps, blocks)

        for layer = 0, thickness - 1 do
            local px = x + ox * (radius + layer * 0.8)
            local pz = z + oz * (radius + layer * 0.8)
            for h = 0, height - 1 do
                Block:placeBlock(blockid, math.floor(px + 0.5), math.floor(y + h + 0.5), math.floor(pz + 0.5))
            end
        end
    end
end

-- GAPPED WALL (every nth block has a gap)
function WALL.GAPPED(x, y, z, dirx, diry, dirz, length, height, thickness, gapInterval, blocks)
    dirx, diry, dirz = normalize(dirx, diry, dirz)
    local rightX, _, rightZ = getRightVector(dirx, diry, dirz)

    for i = -length, length do
        if (math.abs(i) % gapInterval) ~= 0 then
            local blockid = getBlockForSegment(i, length, blocks)
            for t = 0, thickness - 1 do
                local px = x + rightX * i + dirx * t
                local pz = z + rightZ * i + dirz * t
                for h = 0, height - 1 do
                    Block:placeBlock(blockid, math.floor(px + 0.5), math.floor(y + h + 0.5), math.floor(pz + 0.5))
                end
            end
        end
    end
end

function WALL.STAIR(x, y, z, dirx, diry, dirz, length, platformHeight, blocks, railingBlock)
    dirx, diry, dirz = normalize(dirx, diry, dirz)
    local rightX, _, rightZ = getRightVector(dirx, diry, dirz)

    for i = 0, length do
        local stepX = x + dirx * i
        local stepZ = z + dirz * i
        local stepY = y + i -- stairs rise

        -- Platform step
        Block:placeBlock(blocks.middle, math.floor(stepX + 0.5), math.floor(stepY + 0.5), math.floor(stepZ + 0.5))

        -- Railings (left & right)
        Block:placeBlock(railingBlock, math.floor(stepX + rightX + 0.5), math.floor(stepY + 1.5), math.floor(stepZ + rightZ + 0.5))
        Block:placeBlock(railingBlock, math.floor(stepX - rightX + 0.5), math.floor(stepY + 1.5), math.floor(stepZ - rightZ + 0.5))
    end

    -- Final top platform
    local topX = x + dirx * length
    local topZ = z + dirz * length
    for offset = -1, 1 do
        local px = topX + rightX * offset
        local pz = topZ + rightZ * offset
        Block:placeBlock(blocks.edge, math.floor(px + 0.5), math.floor(y + length + 0.5), math.floor(pz + 0.5))
    end
end

function WALL.CASTLE(x, y, z, dirx, diry, dirz, radius, angleSpan, height, battlementHeight, innerWallHeight, gapInterval, blocks)
    dirx, diry, dirz = normalize(dirx, diry, dirz)
    local baseAngle = math.atan2(-dirz, dirx)
    local doorAngle = baseAngle + math.pi
    local steps = math.floor(angleSpan * 20)

    for i = -steps, steps do
        local t = i / steps
        local angle = baseAngle + t * angleSpan
        local ox, oz = math.cos(angle), -math.sin(angle)

        -- Skip the door region
        local isDoor = math.abs(angle - doorAngle) < (math.pi / steps * 2)
        if not isDoor then
            local blockid = getBlockForSegment(i, steps, blocks)

            for layer = 0, 1 do
                local px = x + ox * (radius + layer * 0.8)
                local pz = z + oz * (radius + layer * 0.8)
                for h = 0, height + battlementHeight - 1 do
                    if h >= height and (math.abs(i) % gapInterval == 0) then
                        -- skip for battlement gap
                    else
                        Block:placeBlock(blockid, math.floor(px + 0.5), math.floor(y + h + 0.5), math.floor(pz + 0.5))
                    end
                end
            end

            -- Inner wall
            local innerPx = x + ox * (radius - 1.5)
            local innerPz = z + oz * (radius - 1.5)
            for h = 0, innerWallHeight - 1 do
                Block:placeBlock(blockid, math.floor(innerPx + 0.5), math.floor(y + h + 0.5), math.floor(innerPz + 0.5))
            end
        end
    end
end
