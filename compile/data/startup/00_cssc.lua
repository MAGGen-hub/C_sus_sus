local S,s,c,g,e,C,b=settings,shell,"cssc.","global_load","enable"," C SuS SuS ","boolean"
S.define(c..g,{description="Replaces `_G.load` with `cssc.load` for global"..C.."support.",default=false,type=b})
S.define(c..e,{description="Enables"..C,default=true,type=b})
S.load()
if S.get(c..e)then
s.run("data/apis/cssc/cssc.lua")
s.run("data/apis/cssc/env_pack.lua")
if S.get(c..g)then
_G.load=cssc.load
end
end
