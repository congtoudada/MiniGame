--- File Name : game_api.lua

--- DateTime: 2023/4/24 14:00
--- Description: 

global_api = {}
global_api.functions = {}

setmetatable(global_api,{
    __index = function(tb,key)
        --节省lua调用py的性能,将调用过的方法保存在lua层,下次调用不需要再调py层
        if tb.functions[key] == nil then
            tb.functions[key] = globalapi[key]
        end
        return tb.functions[key]
    end
})
