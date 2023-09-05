--CSSC Launcher
if#{...}<1 then print"Usage: cssc <prog>"return end
local p,E,a,t,f,e,r=shell.resolveProgram(...),error,{...},table.remove
p=p or E("Program `"..a[1].."` not found!")
f,e=fs.open(p,"r")
e=e and E(e)
r=f.readAll():gsub("^#!cssc\n","",1)
r=r:find"^[^<]"and"<A,err>"..r or r
r,e=cssc.load(r,"@"..p,nil,_ENV)
f.close()
e=e and E(e)
t(a,1)
arg[0]=t(arg,1)
return r(unpack(a))
