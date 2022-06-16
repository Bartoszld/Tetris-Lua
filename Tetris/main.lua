function love.load() 
love.graphics.setBackgroundColor(.57,.55,.76)

gridXCount = 10
gridYCount = 20

inert = {}
    for y = 1, gridYCount do
        inert[y] = {}
        for x = 1 , gridXCount do
            inert[y][x] = ' '
        end
    end 

blocksFields = 
{
    {
        {
            {' ', ' ', ' ', ' '},
            {'a', 'a', 'a', 'a'},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'a', ' ', ' '},
            {' ', 'a', ' ', ' '},
            {' ', 'a', ' ', ' '},
            {' ', 'a', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 'b', 'b', ' '},
            {' ', 'b', 'b', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'c', 'c', 'c', ' '},
            {' ', ' ', 'c', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'c', ' ', ' '},
            {' ', 'c', ' ', ' '},
            {'c', 'c', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'c', ' ', ' ', ' '},
            {'c', 'c', 'c', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'c', 'c', ' '},
            {' ', 'c', ' ', ' '},
            {' ', 'c', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'d', 'd', 'd', ' '},
            {'d', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'd', ' ', ' '},
            {' ', 'd', ' ', ' '},
            {' ', 'd', 'd', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', ' ', 'd', ' '},
            {'d', 'd', 'd', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'d', 'd', ' ', ' '},
            {' ', 'd', ' ', ' '},
            {' ', 'd', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {   {
            {' ', ' ', ' ', ' '},
            {'e', 'e', 'e', ' '},
            {' ', 'e', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'e', ' ', ' '},
            {' ', 'e', 'e', ' '},
            {' ', 'e', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'e', ' ', ' '},
            {'e', 'e', 'e', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'e', ' ', ' '},
            {'e', 'e', ' ', ' '},
            {' ', 'e', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {   {
            {' ', ' ', ' ', ' '},
            {' ', 'f', 'f', ' '},
            {'f', 'f', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'f', ' ', ' ', ' '},
            {'f', 'f', ' ', ' '},
            {' ', 'f', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'g', 'g', ' ', ' '},
            {' ', 'g', 'g', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'g', ' ', ' '},
            {'g', 'g', ' ', ' '},
            {'g', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
    },
}

    blockXCount = 4
    blockYCount = 4

    timer = 0
    timerLimit = 0.5

    function canBlockMove (testX, testY, testRotation)
        for y = 1, blockYCount do
            for x = 1, blockXCount do
                local testBlockX = testX + x
                local testBlcokY = testY + y

                if blocksFields[blockType][testRotation][y][x] ~= ' '
                and (testBlockX < 1 
                or testBlockX > gridXCount
                or testBlcokY > gridYCount
                or inert[testBlcokY][testBlockX] ~= ' ') 
                then
                    return false
                end
            end
        end

        return true
    end

    function newSequence()
        sequence = {}
        for blockTypeIndex = 1, #blocksFields do
            local postion = love.math.random(#sequence + 1)
            table.insert(
                sequence,
                postion,
                blockTypeIndex)
        end
    end

    newSequence()

    function newBlock()
        blockType = table.remove(sequence)
        blockRotation = 1

        blockX = 3
        blockY = 0
        if #sequence == 0 then
            newSequence()
        end
    end

    newBlock()
end

function love.keypressed(key)
    if key == 'up' then
        local testRotation = blockRotation + 1
        if testRotation > #blocksFields[blockType] then
            testRotation = 1
        end

        if canBlockMove(blockX, blockY, testRotation) then
            blockRotation = testRotation
        end
        
    elseif key == 'down' then
         local testRotation = blockRotation - 1
        if testRotation < 1 then
            testRotation = #blocksFields[blockType]
        end

        if canBlockMove(blockX, blockY, testRotation) then
            blockRotation = testRotation
        end    

    elseif key == 'right' then
        local testX = blockX +1
        if canBlockMove(blockX, blockY, blockRotation) then
            blockX = testX
        end

    elseif key == 'left' then
        local testX = blockX -1
        if canBlockMove(blockX, blockY, blockRotation) then
             blockX = testX
        end

    elseif key == 'space' then
        while canBlockMove(blockX, blockY +1, blockRotation) do
            blockY = blockY + 1
            timer = timerLimit
        end
    end
end

function love.update(dt)

    timer = timer + dt

    if timer >= timerLimit then
        timer = 0
        local testY = blockY + 1
        if canBlockMove(blockX, testY, blockRotation) then
            blockY = testY
        else
            for y = 1, blockYCount do
                for x = 1, blockXCount do
                    local piece = blocksFields[blockType][blockRotation][y][x]
                    if piece ~= ' ' then
                        inert[blockY + y][blockX + x] = piece
                    end
                end
            end 

            for y = 1, gridYCount do
                local complete = true
                for x = 1, gridXCount do
                    if inert[y][x] == ' ' then
                        complete = false
                        break
                    end
                end

                if complete then
                    for removeY = y, 2, -1 do
                        for removeX = 1, gridXCount do
                            inert[removeY][removeX] = inert [removeY - 1][removeX]
                        end
                    end

                    for removeX = 1, gridXCount do
                        inert[1][removeX] = ' '
                    end
                end
            end

            newBlock()

            if not canBlockMove(blockX, blockY, blockRotation) then
                love.load()
            end
        end
    end

end

function love.draw()

        local function drawBlock(block, x, y)
            local colors = {
                [' '] = {0.8, 0.8, 0.8},
                a = {1 , 0, 0},
                b = {0, 1, 0},
                c = {0, 0, 1},
                d = {1, 1, 0},
                e = {1, 0, 1},
                f = {0, 1, 1},
                g = {1, 1, 1},
                p = {0.8, 0.8, 0.8},
            }
            local color = colors[block]
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
                'fill',
                (x-1) * blockSize,
                (y-1) * blockSize,
                blockDrawSize,
                blockDrawSize
            )
        end
            
    local offsetX = 5
    local offsetY = 5

    for y = 1, gridYCount do
        for x = 1, gridXCount do
            drawBlock(inert[y][x], x + offsetX, y + offsetY)
        end  
    end           

    for y = 1, blockYCount do
        for x = 1, blockXCount do
            local block = blocksFields[blockType][blockRotation][y][x]
            if block ~= ' ' then
                drawBlock(block, x + blockX + offsetX, y + blockY + offsetY)
            end
        end
    end

    for y = 1, blockYCount do
        for x = 1, blockXCount do
            local piece = blocksFields[sequence[#sequence]][1][y][x]
            if piece ~= ' ' then
                drawBlock('p', x + 8, y + 1)
            end
        end
    end
end



