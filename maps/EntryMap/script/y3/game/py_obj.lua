---
--- File Name : new_py_obj.lua

--- DateTime: 2022/8/25 14:50
--- Description: 
---

py_obj = {}

function py_obj.new(py)
    local obj = {}
    obj.py = py
    obj.functions = {}
    setmetatable(obj,{
        __index = function(obj,key)
            --节省lua调用py的性能,将调用过的方法保存在lua层,下次调用不需要再调py层
            if obj.functions[key] == nil then
                obj.functions[key] = obj.py[key]
            end
            return obj.functions[key]
        end,
        __call = function(obj)
           return obj.py
        end
    })
    return obj
end