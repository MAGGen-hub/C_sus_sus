
K={}
Ks="if then elseif else local return end function for while in do repeat until break "
Kb={}
Ks:gsub("(%S+)( )",function(x,s)K[#K+1]=s..x..s end)
local l=function(C,o)
local i,a,e,p=#C.R,1
e=C.R[i]
p=e:find"^%)%s*"and""or"("
while i>0 and(#p>0 and(a and(e:match"[%w_]+"or"..."==e)or","==e)or#p<1 and not e:find"^%(%s*")do
i,a=i-1,not a
e=C.R[i] end
table.insert(C.R,#p<1 and i or i+1,K[8]..p)
C.R[#C.R+1]=(#p>0 and")"or"")..(o:sub(1,1)=="-"and K[6]or"")
end
F={
E={ ["/|"]=K[1],--[[if]] ["?"]=K[2],
[":|"]=K[3],
["\\|"]=K[4]},
K={ ["@"]=K[5],
["$"]=K[6],
["||"]=" or ",
["&&"]=" and ",
["!"]=" not ",
[";"]=function(C,o,w)
local e,a,p,k=" end ",o:match"(;*) *([%S\n]?)%s*([%(\"]?)"
C.R[#C.R+1]=(#p>0 and (#k<1 or p~="\n") or#a>1)and e:rep(#a)or";"
return o:sub(#a+1)end},
F={ ["->"]=l,
["=>"]=l}
}
NL,a,b=load
L=function(x,name,mode,env)
if type(x)=="string" then
local c=x:match"^<.->"or x:match"^#!.-\n?<.->"
if c then
local po,R,S,O,C,s,t,a,b,l,e="",{""},{W={},O={}},{['"']="",["\0"]="\n",['..']='..',['...']='...'}
x=x:sub(#c+1)
C={O=O,S=S,R=R,F={},c={},l=1,pv=1}
for K,V in ("D"..c):gmatch"([%w_]+)%(?([%w_. ]*)"do
if F[K]then
for k,v in pairs(F[K])do O[k]=v end
l=F[K][1]and F[K][1](C,V,x,name,mode,env)
if l then return l end
end
end
O[1]=nil
l=#x+1
for o,w,i in x:gmatch"([%s!#-&(-/:-@\\-^{-~`]*%[?=*[%['\"]?%s*)([%w_]*[^%w%p%s]*[^\n%S]*)()"do
o:gsub("\n",function()C.l=C.l+1 end)
if s then
a,b,e=o:find(#s<2 and"(\\*[\n"..s.."])%s*"or"(%]=*%])%s*")
if a and(#s<2 and(s=="\n"or#e%2>0)or#s==#e)or i==l then
b=b or i
t=t..o:sub(0,b)
if c then c=C.c
else
for k,v in pairs(S.W)do t=v(C,t,i)or t end
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
s=c and(c:sub(3)==s and s or"\n")or s
t,w=o:sub(a)..w,""
o=o:sub(0,a-1)..(c and"\0"or'"')
po=c and (o or "") or""
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
for k,v in pairs(S.O)do b=v(C,a,b)or b end
if 7>#type(b)then
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
for k,v in pairs(S.W)do w=v(C,w,i)or w end
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
if mode=="c"then return R end
end
end
return NL(x,name,mode,env)
end
a,b=L([[<K,E,F>
OBJ=o->o:match"%S+";
env={}
F.D={["\0"]=C=>@r=C.R r[#r]=r[#r].." "..(table.remove(C.c,1)||"");,
['"']=C=>$nil;}
err=C,s=>C.err=C.err||"SuS["..C.l.."]:"..s;
F.err={C=>
C.F.err=C=>
/|C.err?$ nil,control_table.err;;;}
F.pre={C,V,x,n,m,e=>
/|!cssc.preload?cssc.preload={};
@P=cssc.preload
/|P[V]?$NL(P[V],n,m,e);
C.F.pre=C=>P[V]=table.concat(C.R);;}
F.dbg={C,V=>
@v=V
C.F.dbg=C,x,n,m=>
/|v=="P"?require"cc.pretty".pretty_print(C.R)
:|v=="p"?print(table.concat(C.R));
/|m=="c"?$R
:|m=="s"?$table.concat(C.R);;;}
F.b={C=>
C.S.W.b=C,w=>
@a,b,c,r,t=w:match"^0([bo])(%d*)([eE]?.*)"
/|C.b&&C.R[#C.R]=="."?t,b,c=C.b,w:match"(%d+)([eE]?.*)"
\|C.b=nil;
/|b?
t,r=t||(a>"b"&&"8"||"2"),0
for i,k in b:gmatch"()(.)"do
/|k>=t?err(C,"This is not a valid number: 0"..a..b..c);
r=r+k*t^(#b-i)
end
r=C.b&&tostring(r/t^#b):sub(3)||r
C.b=!C.b&&#c<1&&t||nil
$r..c;;;}
F.l={C=>
/|C.O["("]?$;
C.L={{p={l=0}},b={{},[0]={}},a={{},[0]={}}}
@l=C.L
@p="([{}])"
for k in p:gfind"(.)"do
C.O[k]=C,o,w=>
o=o:sub(1,1)
@t=p:find(o,1,1)<4&&1||0
for k,v in pairs(l.b[t])do v(C,o,w)end
C.R[#C.R+1]=o
l[#l+t]=t>0&&{}||nil
for k,v in pairs(l.a[t])do v(C,o,w)end;
end;}
F.s={C=>
F.l[1](C)
@l=C.L
@r=C.R
/|l[1].st?$;
l.b[1][#l.b[1]+1]=C=>/|Kb[r[#r]:match"%w*"]||!r[#r]:find"[%w_%}%]%)\"']"?l[#l].st=#r+1;;
l.a[1][#l.a[1]+1]=C=>l[#l].st=#r+1;
l[1].st=1
C.S.W.st=C,w,i=>
@p=r[#r]
/|p:match"^[.:]"&&!p:match"%.%."?$;
@ch=p:match"^ ?[%w_%]%)}\"']+"||""
/|w:find"^[%['\"].-[%]'\"]"&&!Kb[ch]&&!(" and or not "):find(" "..ch.." ")?$;
l[#l].st=#r+1;;}
do
@c,d=setmetatable
d=c({},{__call=->nil;,__index=->nil;})
c=c({},{__index=->()->nil;;})
N=(o,i)=>
/|o==nil?$i&&c||d;
/|i?$o[i]&&o||c;
$o;
end
F.N={C=>
F.s[1](C)
@p=C.O["?"]
@r=C.R
@f=C,b=>/|r[C.pc]==r[#r]?table.insert(r,C.ci,",'"..r[#r].."'");
C.pc,C.L.b[1].pc,C.S.W.str=nil;
@e="Attempt to perform '"
C.O["?"]=C,o,w=>
@a=o:match'.([.:%[%({"]?)'
/|!r[#r]:find"^ ?[%w_%]%)}\"']%s-"?err(C,e.."?"..(a||"").."' on '"..(OBJ(r[#r])or"nil").."'");
/|#a>0?
/|a:find"[.:]"&&!o:sub(3):find"^[\0%s]*$"?err(C,e..o:sub(3).."' on '?"..a.."'");
table.insert(r,C.L[#C.L].st," cssc.nilF(")
r[#r+1]=a==":"&&",'"..w.."')"||")"
/|a=="."?
C.ci=#r
C.pc=#r+2
C.S.W.str=C,w=>/|w:find"^[%w_]"?$;
f(C);
C.L.b[1].pc=f;
\|r[#r+1]=p&&" "..p.." "||"?";;;}
F.K[1]=C=>C.EQ={"&&","||",unpack(C.EQ||{})};
F.C={C=>
F.s[1](C)
C.EQ={"+","-","*","%","/","..","^",unpack(C.EQ||{})}
@l=C.L
@r=C.R
@op=C,o,w=>
o=o:match"(.-)="
r[#r+1]="="
l[#l].m={bor=#r+1}
for i=l[#l].st,#r-1 do r[#r+1]=r[i]end
@t=#type(C.O[o])
/|t==6?r[#r+1]=C.O[o]
:|t==3?r[#r+1]=o
\|C.O[o](C,o,w);
l[#l].m={bor=#r+1};
for i=1,#C.EQ do C.O[C.EQ[i].."=" ]=op end;
}
@tof=o->(getmetatable(o)||{}).__type||type(o);
@is={__call=v,...=>
@a={...}
/|#a<1?$false;
/|#type(a[1])==5?a=a[1];
for i=1,#a do
/|tof(v[1])==a[i]?$true;
end $false;}
env.typeof=tof
F.IS={C=>
F.s[1](C)
@l=C.L
C.S.W[1]=C,w=>
w=OBJ(w)
/|w=='is'?
table.insert(C.R,l[#l].st,"setmetatable({")
$"},cssc.is)";;;}
do
@B={}
for k,v in pairs(bit32)do B[k]=v end
B.idiv=a,b->math.floor(a/b);
B.shl=B.lshift
B.shr=B.rshift
@bt={shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}
@kp={}('and or , = ; > < >= <= ~= == => -> '):gsub("%S+",(x)=>kp[x]=1;)
@f=t,m->"Attempt to perform"..t.."bitwise operation on a "..m.." value";
M={bnot=setmetatable({},{
__pow=a,b=>
@m=(getmetatable(b)||{}).bnot
/|m?$m(b);
m=type(b)
/|m~='number'?error(f('bitwise',m),3);
$B.bnot(b);})}
for k,v in pairs(bt)do
@n='__'..k
@t='number'
@e=v=='//'&&'idiv'||'bitwise'
@f=a,b=>
@m=(getmetatable(a[1])||{})[n]||(getmetatable(b)||{})[n]
/|m?$m(a,b);
m=type(a[1])
m=m==t&&type(b)||m
/|m~=t?error(f(e,m),3);
$B[k](a[1],b);
M[k]=v=='//'&&{__div=f}||{__concat=f}
end
F.M={C=>
C.O['~=']='~='
C.EQ={">>","<<","&","|",unpack(C.EQ||{})}
F.s[1](C)
@l=C.L
@r=C.R
l[#l].m={bor=1}
l.a[1][#l.a[1]+1]=C=>l[#l].m={bor=#r+1};
@f=C,o=>
o=OBJ(o)
@i=#r+2
@b=Kb[o]||kp[o]
/|b?l[#l].m={bor=i};
/|b||(" .. + -"):find(' '..o..' ',1,1)?l[#l].m.idiv=i;;
C.S.O.pc=C,a,b=>
/|type(b)==6?f(C,b)
\|f(C,a);;
C.S.W.pc=f
for k,v in pairs(bt)do
C.O[v]=C,o,w=>
@p=OBJ(r[#r])
/|v=='~'&&
((p:find"[^%)}%]'\"%P]"&&!p:find"%[=*%[")||
Kb[p]||kp[p])?
r[#r+1]="cssc.mt.bnot^" $;
table.insert(r,l[#l].m[k]||l[#l].m.bor||l[#l].st,"setmetatable({")
r[#r+1]="},cssc.mt."..k..(v=='//'&&')/'||')..')
@i=#r+1
@l=l[#l]
/|v=='|'?l.m.bxor=i;
/|v:find'[|~]'?l.m.band=i;
/|v:find'[|~&]'?l.m.shl,l.m.shr,l.m.idiv=i,i,i;
/|v:find"([><])%1"?l.m.idiv=i;;
end;}
end
F.ENV={C=>
C.F.env=C,x,n,m,e=>
e=e||{}
for k,v in pairs(env)do e[k]=v end
return nil,nil,e
;;}
F.A={C=>
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
;}
_G.cssc={features=F,load=L,nilF=N,mt=M,version="3.4-alpha",__CSSC=_ENV,is=is,env=env}
]],"SuS",nil,_ENV)
b=b and error(b)
a=a and a(...)
