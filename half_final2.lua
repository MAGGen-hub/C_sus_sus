 local l= function (C,o)
 local i,a,e,p=#C.R,1
e=C.R[i]
p=e:find"^%)%s*" and "" or "("
while i>0 and (#p>0 and (a and (e:match"[%w_]+"or "..."==e)or ","==e)or #p<1 and not e:find"^%(%s*")do
i,a=i-1,not a
e=C.R[i] end 
table.insert(C.R,#p<1 and i or i+1,K[4]..p)
C.R[#C.R+1]=(#p>0 and ")"or "")..(o:sub(1,1)=="-" and K[13] or "")
 if C.L then C.C.L("function",1) end 
 end 
F={
E={ ["/|"]=K[1],
["?"]=K[9],
[":|"]=K[2],
["\\|"]=K[3]},
K={ ["@"]=K[12],
["$"]=K[13],
["||"]=" or ",
["&&"]=" and ",
["!"]=" not ",
[";"]=K[10]},
F={ ["->"]=l,
["=>"]=l}
}
NL=load
L= function (x,name,mode,env)
 if type(x)=="string" then 
 local c=x:match"^<.->"or x:match"^#!.-\n?<.->"
 if c then 
 local po,R,O,C,s,t,a,b,l,e="",{""},{['"']="",["\0"]="\n",['..']='..',['...']='...'}
x=x:sub(#c+1)
C={O=O,C= function () end ,R=R,F={},c={},l=1,pv=1}
for K,V in ("D"..c):gmatch"([%w_]+)%(?([%w_. ]*)"do
 if F[K]then 
for k,v in pairs(F[K])do O[k]=v end 
l=F[K][1] and F[K][1](C,V,x,name,mode,env)
 if l then return l end 
 end 
 end 
O[1]=nil
l=#x+1
for o,w,i in x:gmatch"([%s!#-&(-/:-@\\-^{-~`]*%[?=*[%['\"]?%s*)([%w_]*[^%w%p%s]*[^\n%S]*)()"do
o:gsub("\n", function ()C.l=C.l+1 end )
 if s then 
a,b,e=o:find(#s<2 and "(\\*[\n"..s.."])%s*"or "(%]=*%])%s*")
 if a and (#s<2 and (s=="\n"or #e%2>0)or #s==#e)or i==l then 
b=b or i
t=t..o:sub(0,b)
 if c then c=C.c
 else
t=C.C(nil,t,i)or t
c=R
 end 
c[#c+1]=t
o=po..o:sub(b+1)
s,t=nil
 else
t=t..o..w
 end 
 end 
 if not s then 
o=o:gsub("-%-%s-\n","")
c=o:match"-%-%[?=*%[?"
s=o:match"%[=*%["or o:match"['\"]"
 if c or s then 
a=o:find(c or s,1,1)
s=c and (c:sub(3)==s and s or "\n")or s
t,w=o:sub(a)..w,""
o=o:sub(0,a-1)..(c and "\0"or '"')
po=c and (o or "") or ""
 end 
 if not c or i==l then 
while #o>0 do
a=o:match"^%s*"
R[#R]=R[#R]..a
o=o:sub(#a+1)
for i=3,1,-1 do
a=o:sub(1,i)
b=O[a] or i<2 and a
 if b and #o>0 then 
b=C.C(a,b,i)or b
 if 7>#type(b) then 
R[#R+1]=b
o=o:sub(i+1)
 else
b={b(C,o,w,i)}
o,w=b[1]or o:sub(i+1),b[2]or w
 end 
break
 end 
 end 
 end 
 if #w>0 then 
w=C.C(nil,w,i)or w
R[#R+1]=w
 end 
 end 
 end 
 end 
a,b=nil
for k,v in pairs(C.F) do
a,b,e=v(C,x,name,mode,env)
 if e then env=e end 
 if a or b then return a,b end 
 end 
x=table.concat(R)
 if mode=="c" then return R end 
 end 
 end 
 return NL(x,name,mode,env)
 end 
F.K[';']= function (C,o,w)
 local a,p=o:match"(;*) *([%S\n]?)%s*"
 if #p>0 and p~="(" or #a>1 then 
for i=1,#a do
C.R[#C.R+1]=K[10]
 if C.L then C.C.L("end") end 
 end 
 else C.R[#C.R+1]=";" end 
 return o:sub(#a+1) end 
OBJ= function (o) return type(o)=='string' and o:match"%S+" or "" end 
env={}
F.D={["\0"]= function (C) local r=C.R r[#r]=r[#r].." "..(table.remove(C.c,1) or "") end ,
['"']= function (C) return nil end }
err= function (C,s)C.err=C.err or "SuS["..C.l.."]:"..s end 
F.err={ function (C)
C.F.err= function (C)
 if C.err then  return  nil,C.err end  end  end }
F.pre={ function (C,V,x,n,m,e)
 if  not cssc.preload then cssc.preload={} end 
 local P=cssc.preload
 if P[V] then  return NL(P[V],n,m,e) end 
C.F.pre= function (C)P[V]=table.concat(C.R) end  end }
F.dbg={ function (C,V)
 local v=V
C.F.dbg= function (C,x,n,m)
 if v=="P" then require"cc.pretty".pretty_print(C.R)
 elseif v=="p" then print(table.concat(C.R)) end 
 if m=="c" then  return R
 elseif m=="s" then  return table.concat(C.R) end  end  end }
F.b={ function (C)
F.c[1](C)
C.C.W.b= function (o,w)
 local a,b,c,r,t=w:match"^0([bo])(%d*)([eE]?.*)"
 if C.b and C.R[#C.R]=="." then t,b,c=C.b,w:match"(%d+)([eE]?.*)"
 else C.b=nil end 
 if b then 
t,r=t or (a>"b" and "8" or "2"),0
for i,k in b:gmatch"()(.)"do
 if k>=t then err(C,"This is not a valid number: 0"..a..b..c) end 
r=r+k*t^(#b-i)
 end 
r=C.b and tostring(r/t^#b):sub(3) or r
C.b= not C.b and #c<1 and t or nil
 return r..c end  end  end }
ATP= function (C,wt,on)err(C,"Attempt to perform '"..wt.."' on '"..on.."'!") end 
F.c={ function (C)
 if C.CR then  return  end 
C.CR=1
C.L={{st=1},o={},c={}}
 local l=C.L
 local r=C.R
for k in("=~<>"):gfind"."do k=k..'='C.O[k]=k end 
 local f= function (T,o,w,i)for k,v in pairs(T)do w=v(o,w,i)or w end  return w end 
C.C={W={},O={},A={},K={},o={['and']=1,['or']=1,['not']=1},
l={["for"]="do",["while"]="do",["repeat"]="until",["if"]="then",["elseif"]="then",["else"]="end",["do"]="end",["function"]="end",["{"]="}",["("]=")",["["]="]"},
L= function (o,v) if v then l[#l+1]=f(l.o,o,{t=o})
 else  local e=C.C.l[l[#l].t]
 if e and e~=o then err(C,"Expected '"..e.."' after '"..l[#l].t.."' but got '"..o.."'!") end 
 if #l<2 then err(C,"Unexpected '"..o.."'!") end 
f(l.c,o,l[#l])l[#l]=#l<2 and l[#l] or nil end  end }
 local c=C.C
C.F[1]= function () if #l>1 then err(C,"Uncolsed construction! Missing '"..(c.l[l[#l].t] or " end ").."'!") end  end 
setmetatable(C.C,{__call= function (S,o,w,i)
 if o=='"' or o=='\0' then  return  end 
C.pv=C.cv
C.cv=nil
 if #type(w)==6 then 
 local ow=OBJ(w)
 local k=Kb[ow]
 if k then C.cv=1 w=f(c.K,o,w,i) or w
 if k>7 and k<12 then c.L(ow) end 
 if k<10 then c.L(ow,1) end 
 elseif c.o[ow] then  C.cv=2 w=f(c.O,o,w,i) or w end  end 
 if  not C.cv then 
 if  not o then C.cv=w:find"^['\"%[]" and 6 or 3 w=f(c.W,o,w,i) or w
 else C.cv=o:find"^[%[%({]" and 4 or o:find"^[%]%)}]" and 5 or 2
 if C.cv==4 then c.L(o,1) end 
 if C.cv==5 then c.L(o) end 
w=f(c.O,o,w,i) or w end  end 
w=f(c.A,o,w,i) or w
 return w end })
l.o[#l.o+1]= function (o,t)
 local s=#r+1
 if C.pv and C.pv<3 then l[#l].st=s end 
t.st=s+1 end 
c.W.st= function (o,w)
 local p=OBJ(r[#r])
 if p:find"[.:]" and #p<2 then  return  end 
 if C.cv==6 and C.pv>2 then  return  end 
l[#l].st=#r+1 end 
 end }
do
 local c,d=setmetatable
d=c({},{__call= function () return nil end ,__index= function () return nil end })
c=c({},{__index= function () return  function () return nil end  end })
N= function (o,i)
 if o==nil then  return i and c or d end 
 if i then  return o[i] and o or c end 
 return o end 
F.N={ function (C)
F.c[1](C)
C.C.O.N= function (o) if F.N[o] then C.cv=C.pv end  end  end }
for v,k in('.:"({'):gfind"()(.)"do
F.N['?'..k]= function (C,o,w)
 local r=C.R
 if #r<2 or C.pv<3 then ATP(C,k,r[#r]) end 
 if o:sub(3):find"[^\0%s]" then ATP(C,OBJ(o:sub(3)),k) end 
table.insert(C.R,C.L[#C.L].st," cssc.nilF(")
r[#r+1]=v==2 and ",'"..w.."')" or ')'
 if v==1 then 
C.ci=#r
C.pc=#r+2
C.C.A.str= function (o)
 if C.pc<=#r then  print(C.cv,w,r[#r],r[#r-1],r[#r-2],#r,o)
 if C.cv>4 or C.cv>3 and  not o:find'^[)%]}]' then 
table.insert(r,C.ci,",'"..w.."'") end 
C.C.A.str=nil end  end  end 
 return o:sub(2) end 
 end 
 end 
F.K[1]= function (C)C.EQ={"&&","||",unpack(C.EQ or {})} end 
 local qeq= function (b,a)
 if a==nil then  return b
 else  return a end  end 
F.C={ function (C)
F.c[1](C)
C.EQ={"+","-","*","%","/","..","^","?",unpack(C.EQ or {})}
 local l=C.L
 local r=C.R
C.C.A.br= function (o,w)
 if l[#l].br and (C.pv==3 or C.pv>4) and (C.cv==1 or C.cv==3 or (o==',' or o==';')) then 
l[#l].br=nil
r[#r+1]=")" end  end 
l.c[#l.c+1]= function (o,t) if t.br then r[#r+1]=")" end  end 
C.F.c= function () if l[#l].br then r[#r+1]=")" end  end 
 local op= function (C,o,w)
 if #r<2 or C.pv<3 then ATP(C,k,r[#r]) end 
o=o:match"(.-)="
r[#r+1]="="..(o=="?" and "cssc.q_eq(" or "")
l[#l].m={bor =#r+1}
for i=l[#l].st,#r-1 do r[#r+1]=r[i] end 
 local t=#type(C.O[o])
 if o=="?" then r[#r+1]=","
 elseif t==6 then r[#r+1]=C.O[o]
 elseif t==3 then r[#r+1]=o
 else C.O[o](C,o,w) end 
 if o~="?" then r[#r+1]="(" end 
l[#l].br=1
l[#l].m={bor =#r+1}
 end 
for i=1,#C.EQ do C.O[C.EQ[i].."=" ]=op end end 
}
 local tof= function (o) return (getmetatable(o) or {}).__type or type(o) end 
 local is=setmetatable({},{__concat= function (v,a) return setmetatable({a},
{__concat= function (v,a)
 if type(a[1])=="table" then a=a[1] end 
for i=1,#a do
 if tof(v)==a[i] then  return true end 
 end 
 return false end }) end })
env.typeof=tof
F.IS={ function (C)
F.c[1](C)
C.C.o['is']=1
 local l=C.L
C.C.O[1]= function (o,w)
w=OBJ(w)
 if w=='is' then 
 if #C.R<2 or C.pv<3 then ATP(C,'is',C.R[#C.R]) end 
 return " ..cssc.is.. " end  end  end }
do
 local B={}
for k,v in pairs(bit32)do B[k]=v end
B.idiv= function (a,b) return math.floor (a/b) end 
B.shl=B.lshift
B.shr=B.rshift
 local bt={shl='<<',shr='>>',bxor ='~',bor ='|',band='&',idiv='//'}
 local kp={}('and or , = ; > < >= <= ~= == => -> '):gsub("%S+", function (x)kp[x]=1 end )
 local f= function (t,m) return "Attempt to perform "..t.." bitwise operation on a "..m.." value" end 
M={bnot=setmetatable({},{
__pow= function (a,b)
 local m=(getmetatable(b) or {}).bnot
 if m then  return m(b) end 
m=type(b)
 if m~='number' then error (f('bitwise',m),3) end 
 return B.bnot(b) end })}
for k,v in pairs(bt)do
 local n='__'..k
 local t='number'
 local e=v=='//' and 'idiv' or 'bitwise'
 local f= function (a,b)
 local m=(getmetatable(a[1]) or {})[n] or (getmetatable(b) or {})[n]
 if m then  return m(a,b) end 
m=type(a[1])
m=m==t and type(b) or m
 if m~=t then error (f(e,m),3) end 
 return B[k](a[1],b) end 
M[k]=v=='//' and {__div=f} or {__concat=f}
 end 
F.M={ function (C)
C.EQ={">>","<<","&","|",unpack(C.EQ or {})}
F.c[1](C)
 local l=C.L
 local r=C.R
l[#l].m={bor =1}
l.o[#l.o+1]= function (o,t)t.m={bor =#r+2} end 
C.C.A.pc= function (o,w)
 local i=#r+2
 local b=C.cv<2 or o and kp[o]
 if b then l[#l].m={bor =i} end 
 if b or o and (" .. + -"):find(' '..o..' ',1,1) then l[#l].m.idiv=i end  end 
for k,v in pairs(bt)do
C.O[v]= function (C,o,w)
 local p=OBJ(r[#r])
 if v=='~' and 
((p:find"[^%)}%]'\"%P]" and  not p:find"%[=*%[") or 
Kb[p] or kp[p]) then 
r[#r+1]="cssc.mt.bnot^"  return  end 
table.insert(r,l[#l].m[k] or l[#l].m.bor or l[#l].st,"setmetatable({")
r[#r+1]="},cssc.mt."..k..(v=='//' and ')/' or ')..')
 local i=#r+1
 local l=l[#l]
 if v=='|' then l.m.bxor =i end 
 if v:find'[|~]' then l.m.band=i end 
 if v:find'[|~&]' then l.m.shl,l.m.shr,l.m.idiv=i,i,i end 
 if v:find"([><])%1" then l.m.idiv=i end  end 
end end }
 end 
F.ENV={ function (C)
C.F.env= function (C,x,n,m,e)
e=e or {}
for k,v in pairs(env)do e[k]=v end
 return nil,nil,e
 end  end }
F.A={ function (C)
F.M[1](C)
F.K[1](C)
F.IS[1](C)
F.N[1](C)
F.C[1](C)
F.b[1](C)
C.O['..']=' ..'
F.ENV[1](C)
for K,V in pairs{F.K,F.F}do
for k,v in pairs(V)do
C.O[k]=v
 end 
 end 
 end }
_G.cssc={features=F,load=L,nilF=N,mt=M,version="3.5-beta",creator ="M.A.G.Gen.",__CSSC=_ENV,is=is,q_eq=qeq,env=env}