if not cssc then
T=function(S)
local t,f,s,c={},0
for i,v in S:gfind"()(['\"%[%-])"do
if f and i>f then
if v=='-'then s=S:find('^%-',i+1)c=s end
if v=='['or c then
 s=S:match('^%[(=*)%[',c and i+2 or i)
 if s then
  s,f=S:find(']'..('='):rep(#s)..']',f)
  t[#t+1]={t=c and'C'or'S',i,f}
 elseif c then
  s,f=S:find('\n',i)
  t[#t+1]={t='c',i,f}
 end c=nil
elseif v~='-'then f=i
 repeat s,f=S:find('\\*'..v,f+1) until not f or(f-s)%2==0
 t[#t+1]={t=v=="'"and's'or"d",i,f}
end
end end
if not f then t[#t][2]=#S end
setmetatable(t,{__call=function(t,i)local j=1
if #t<1 then return false end
while t[j] and i >= t[j][1] do j=j+1 end
return j>1 and i<=t[j-1][2]end})
return t end

C={}P={}
B={"([^ ] -)()([&|~<>][<>=]?)",['&']="band",['|']="bor",['~']="bxor",_="0).bnot(",['>>']="rshift",['<<']="lshift"}
K={"()([@$&|!%?/\\:;][/&|;]?)",['//']="):floor(",['@']="local",['&&']="and",['||']="or",['!']="not",['?']="then",['/|']="if",[':|']="elseif",['\\|']="else",['$']="return",[';;']="end"}
F={K=function(S,t)return S:gsub(K[1],function(s,b)
if not t(s)and K[b]then return' '..K[b]..' 'end
end)end,
F=function(S,t)return S:gsub("()([%(=])([%w,%. _]-)([%-%|])()>",function(s,a,v,b,f)
if not(t(s)or t(f))then
return a..'function('..v..(b=='-'and")return "or')')end
end)end}

local NL=load
L=function(x,name,mode,env)
if"string"==type(x)then
local a,p,d=x:match"^<.->"
 if a then
 x=x:sub(#a+1)
  for a in a:gfind'[%w_]+'do
  if F[a]then x=F[a](x,T(x))
  elseif a=='P'then p=0 else p=p and a if p and p~=0 and P[p]then return P[p]end end
  end
 if mode=='s'then return x end
 if p and p~=0 then if not P[p]then P[p]=NL(x,name,mode,env)end return P[p]end
 end
end
return NL(x,name,mode,env)
end

L([[<K,F>
@D,Y=debug,"[%w_%.%]%[]+)"
F.B=S,t->S:gsub(B[1],(p,s,o|>if!t(s)?
/|B[o]?$p..((o=='~'&&p:match"^[^)^_^%w]")&&B._||'):'..B[o]..'(');;
;;;;));;
F.C=S,t|>
@cr=c,s,b,a,p|>
if!t(s)?
 /|a==b?$"(0).opt('"..c.."',_ENV,"..(a=='+'&&'1'||'-1')..(p&&',0'||'')..")"
 :|a=='='&&b~='~'?$c..a..c..b..(b=='.'&&b||'');;
;;;;
S=S:gsub("("..Y.."()([%.%-~%+%*%%%^])([~%+=])",cr)t=T(S)
$S:gsub("([~%+])([~%+])()("..Y,(b,a,s,c->cr(c,s,b,a,0);;))
;;
F.A=S,t|>S=F.F(S,t)S=F.K(S,T(S))S=F.C(S,T(S))S=F.B(S,T(S))$S;;
F.dbg=S|>print(S)$S;;
C.AL=!1
I={opt=n,e,v,p|>
@c,i,l,m=0
/|C.AL?repeat c=c+1 l,m=D.getlocal(2,c) until!l||l==n:match"[%w_]+"
/|l?
/|type(m)==type{}?l=n:match("([%.%[]"..Y)i=I.opt((l&&"E"..l||n),{E=m},v,p)
\|i,m=p&&m+v||m,m+v;;D.setlocal(2,c,m)$i
;;;;
m,i=pcall(NL((tonumber(n)&&""||n.."="..n.."+"..v).." return "..n,"",nil,e))
$m&&(p&&i||i-v)||0
;;,
floor=a,b->math.floor(a/b);;,
char=string.char}
for k,v in pairs(bit32)do I[k]=v;;
D.setmetatable(0,{__index=I})

R=E,...|>
/|...?
@a,l,f,e,s={...},shell.resolveProgram(...)
f,e=fs.open(l||"","r")
e=e&&error(e)
s=f.readAll()f.close()
e=table.remove(a,1)
/|E.arg?E.arg[0]=e table.remove(E.arg,1);;
f,e=cssc.load(s,"@/"..l,nil,E)(unpack(a))
$f&&f()||error(e);;;;

_G.cssc={run=R,load=L,ctrl=C,preload=P,nummeta=I,bit=B,opts=K,flags=F,strtab=T,version=2.1}
/|shell&&...?shell.run(arg[0],...);;
]],"sus",nil,_ENV)(...)
end
return cssc.run(_ENV,...)
