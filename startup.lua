pathToCssc="cssc.lua"

local C=require"cc.shell.completion" --for auto complete
shell.setCompletionFunction(pathToCssc,C.build({C.programWithArgs,2,many=true}))

shell.run(pathToCssc) --init api (launch cssc.lua in any posible way)
_G.load=cssc.load -- if you want to call C SuS SuS progs without cssc *prog* usage
