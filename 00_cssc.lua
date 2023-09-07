--LOCALS
local S,s,c,a,p,e,ce,ep,t,d=settings,shell,require"cc.shell.completion","cssc_api.lua","cssc.lua","env_pack.lua","cssc.enable","cssc.env_pack",{default=true,type="boolean"},"a_new_cssc/"
--CSSC
S.define(ce,t)
if S.get(ce)then
s.run(d..a)--load C SuS SuS
cssc.addPath(d.."?.lua")--add cssc.path to package.path in cssc environment
--SHELL
s.setAlias("cssc",d..p)--alias for cssc launcher
s.setCompletionFunction(d..p,c.build({c.programWithArgs, 2, many = true}))--set cssc launcher completion
--ENV Pack
if fs.exists(d..e)then
S.define(ep,t)
if S.get(ep)then s.run(d..e)end
end end
