--- File Name : game_api.lua

--- DateTime: 2022/8/25 15:13
--- Description: 

game_api = {}
game_api.functions = {}

setmetatable(game_api,{
    __index = function(tb,key)
        --节省lua调用py的性能,将调用过的方法保存在lua层,下次调用不需要再调py层
        if tb.functions[key] == nil then
            tb.functions[key] = gameapi[key]
        end
        return tb.functions[key]
    end
})
