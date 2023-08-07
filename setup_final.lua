local cssc_code=[====[
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
]====]
local env_pack_code =[====[a,b=cssc.load([[<A,E,dbg(p)>
--Env setupper
nE=->setmetatable({},{__index=_G});

--GLOBAL: __auto methamethod support
cssc.enable__auto==>
    @f=fs.open("rom/apis/textutils.lua",'r')
    @t=f.readAll() f.close()
    @p='.-__)(.-x)(' --part of template
    @m='autocomplete' -- name of the meta
    @s=t:match'.-t.field.'.. -- insert 'expect' part
       t:match'local g_tL.-%b{}.'.. -- insert 'g_tLuaKeywords' part
       t:match'function complete.+' -- hijack unmodified function
        :gsub('(.+)( tM'..p..p..'.-se)','%1%2%3%4%5%6if%2'..m..'%4'..m..'%6').. -- inject __auto meta support
        'return complete' -- return new textutils.complete function 
    @a,b=load(s,"__AUTO patch")
    /|b?error(b);
    $s,a
    ;
--Vector pack .xyz - feature
do
 @v=nE()
 @fl=loadfile("rom/apis/vector.lua",nil,tE)()
 v._ENV=nil
 @vm=getmetatable(v.new())--get CSSC vector metatable
 env.vector=v
 vm.__autocomplete=vm.__index
 vm.__index=s,i=> --self,index
     $vm.__autocomplete[i]||(s,i=>
         /|i:find'[^xyz]':$;
         @f=i:gfind"."
         /|#i==3?$v.new(s[f()],s[f()],s[f()]);--return vector
         ;)(s,i);
end
--IO bitwise pack >> - read line << - write line
do

end

]],"CSSC_ENV",nil,cssc.__CSSC)
b=b and error(b)
a=a and a(...)
]====]

cssc_code=cssc_code or ""
env_pack_code = env_pack_code or ""
startup_code=[[
shell.run("%s")
shell.run("%s")
]]

--skips
local intro=false
local about=false

function rainbowPrintEffect(text,delay)
    local next,fg,bg,X,Y,prev=0,term.getTextColor(),term.getBackgroundColor()
    for char in (text.." "):gmatch"."do
        if prev then
            term.setCursorPos(X-1,Y)
            term.write(prev)
            prev=nil
        end
        if char:find"%s" then
            term.write(char)
        else
            repeat
                next=(next+1)%16
            until 2^next ~= fg and 2^next ~= bg
        term.blit(char,colors.toBlit(2^next),colors.toBlit(bg))
        prev=char
        sleep(delay or 0.4)
        end
        X,Y=term.getCursorPos()
    end
end

function animate_color(first, second, delay,count)
    local s_clr={term.getPaletteColor(first)}
    local e_clr={term.getPaletteColor(second)}
    local step= {(e_clr[1]-s_clr[1])/count,
                 (e_clr[2]-s_clr[2])/count,
                 (e_clr[3]-s_clr[3])/count}
    for i=1,count do
        --print(unpack(e_clr))
        for j=1,3 do
            s_clr[j]=s_clr[j]+step[j]
        end
        sleep(delay)
        term.setPaletteColor(first,unpack(s_clr))
    end
end

pal={}
function savePal()
    for i=0,15 do
        pal[i]={term.getPaletteColor(2^i)}
    end
end
function loadPal()
    for i=0,15 do
        term.setPaletteColor(2^i,unpack(pal[i]))
    end
end

-- Set words
wlc="W E L C O M E"
maxX,maxY=term.getSize()

--skip intro
if intro then

--backup
savePal()--save default pallete
last_bg=term.getBackgroundColor()

--animate bg
term.setPaletteColor(colors.lightGray,term.getPaletteColor(last_bg))
term.setBackgroundColor(colors.lightGray)
paintutils.drawFilledBox(1,1,maxX,maxY)

animate_color(colors.lightGray,colors.lightBlue,0.03,50)

term.setBackgroundColor(colors.lightBlue)
paintutils.drawFilledBox(1,1,maxX,maxY)
loadPal()

--print welcome
term.setCursorPos((maxX-#wlc)/2,maxY/2-4)
term.setPaletteColor(colors.orange,term.getPaletteColor(colors.red))
term.setTextColor(colors.orange)
rainbowPrintEffect(wlc,0.3)
sleep(0.3)

--print to
term.setCursorPos((maxX-3)/2,maxY/2-2)
term.setPaletteColor(colors.green,term.getPaletteColor(colors.blue))
term.setTextColor(colors.green)
textutils.slowWrite("t o",5)

--images
s_up= {t="\x98\x8C\x9B ",f="ee3e",b="33e3"}
s_mid={t="\x89\x8C\x9B ",f="ee3e",b="33e3"}
s_dwn={t="\x89\x8C\x86 ",f="eeee",b="3333"}
u_up= {t="    "--[["\x90 \x9F "]],  f="eeee",b="3333"}
u_mid={t="\x95 \x95 ",f="ee3e",b="33e3"}

--set new pal colors
--pink / lightGray

term.setPaletteColor(colors.lightGray,term.getPaletteColor(colors.blue))
term.setPaletteColor(colors.pink,term.getPaletteColor(colors.red))
term.setPaletteColor(colors.red,term.getPaletteColor(colors.lightBlue))
term.setPaletteColor(colors.blue,term.getPaletteColor(colors.lightBlue))

--blit images
term.setTextColor(colors.lightGray)
term.setCursorPos((maxX-26.5)/2,maxY/2)
term.blit("\x98\x8C\x9B  "..(s_up .t..u_up.t..s_up.t.." "):rep(2),"bb3bb"..(s_up.f..u_up.f..s_up.f.."8"):rep(2),"33b33"..(s_up.b..u_up.b..s_up.b.."3"):rep(2))
term.setCursorPos((maxX-26.5)/2,maxY/2+1)
term.blit("\x95    "      ..(s_mid.t..u_mid.t..s_mid.t.." "):rep(2),"bbbbb"..(s_mid.f..u_mid.f..s_mid.f.."6"):rep(2),"33333"..(s_mid.b..u_mid.b..s_mid.b.."3"):rep(2))
term.setCursorPos((maxX-26.5)/2,maxY/2+2)
term.blit("\x89\x8C\x86  "..(s_dwn.t:rep(3).." "):rep(2),"bbbbb"..(s_dwn.f:rep(3).."6"):rep(2),"33333"..(s_dwn.b:rep(3).."3"):rep(2))

animate_color(colors.blue,colors.lightGray,0.02,50)
animate_color(colors.red,colors.pink,0.02,50)

d=colors.lightBlue
--hide text
parallel.waitForAll(
    function()animate_color(colors.blue,d,0.03,40)end,
    function()animate_color(colors.red,d,0.03,40)end,
    function()animate_color(colors.orange,d,0.03,40)end,
    function()animate_color(colors.green,d,0.03,40)end)

--reload pallete
sleep(0.5)

loadPal()
end

-- logo
--image=paintutils.parseImage("3bb3eee33eee3\nb333bbee3bbee\nb333eeee3eeee\n3bb3e3e33e3e3")
term.setBackgroundColor(colors.lightBlue)
paintutils.drawFilledBox(1,1,maxX,maxY)
term.setCursorPos(4,2)
term.blit("\x96\x83 \x8C\x82 \x8C\x82","bb3b33b3","333ee3ee") 
term.setCursorPos(4,3)
term.blit("\x82\x83 \x81\x81 \x81\x81","bb3ee3ee","33333333")
term.setTextColor(colors.blue)
print(" Installer")

-- MAIN:
comp=require"cc.shell.completion"

function readPath(x,y,text,def)
cur=term.current()
term.setTextColor(colors.blue)
term.setCursorPos(x,y)
print(text)
wnd=window.create(cur,x,y+1,30,1)
term.redirect(wnd)
term.setBackgroundColor(colors.gray)
term.clear()
term.setTextColor(colors.red)
term.setCursorPos(1,1)
rez=read(nil,nil,function(X)return comp.dir(shell,X) end,def)
term.setBackgroundColor(colors.lightBlue)
term.clear()
term.redirect(cur)
term.setTextColor(colors.red)
term.setCursorPos(x+#text+1,y)
print(rez)
term.setTextColor(colors.blue)
return rez:match"%S" and shell.resolve(rez) or rez
end



function continue()
    stop=false
    repeat
    ev,key=os.pullEvent("key")
        if key==keys.y or key==keys.n then
            stop=key
        end
    until stop
    term.redirect(crnt)
    if stop==keys.n then
        paintutils.drawFilledBox(1,1,maxX,maxY,colors.black)
        return true
    end
end

-- ABOUT AND LICENCE lst
crnt=term.current()
if about then
wnd=window.create(term.current(),6,6,maxX-10,maxY-10)
wnd.setBackgroundColor(colors.white)
wnd.setTextColor(colors.brown)


paintutils.drawBox(4,5,maxX-4,maxY-4,colors.blue)
paintutils.drawLine(5,6,5,maxY-5,colors.white)
term.redirect(wnd)
paintutils.drawFilledBox(1,1,maxX,maxY)
term.setCursorPos(1,1)
textutils.pagedPrint([[


ABOUT C SUS SUS:

 What is C SuS SuS?
C SuS SuS is Lua5.1 based modular macro language created by M.A.G.Gen..
C SuS SuS has it own compiller that will also provide different usefull functions, 
    (by default that functions can't be accessed from _G table).

This language allow usage of different keywords, 
syntax constuctions and operators in Lua5.1.

 What C SuS SuS provides?
 1. Full support of Lua5.3 operators
    Such as ">>" "//" "&"
 2. Keywords shortcuts 
    (and -> "&&", or -> "||", local ->"@", return -> "$", ...)
 3. Assignment operators
    ("+=", "-=", "*=", "^=" ...)
 4. IS keyword 
    (variable is "string") with {__type="your_type"} metamethod support
 5. Nil forgiving operators
    (object?.method()) error will not be emited if "method" is nil.
 6. Lambdas 
    "(*args*)=>" will be turned into "function(args)"
 7. More custom features...

To know more about C SuS SuS Environment, it's features, how use them and how to works with them, 
please wisit officia github and read or download the documentation.

 How much free space will C SuS SuS take?
Default language API package has realy small weight (less than 10Kbs).
It might become bigger if you install cssc runner or _ENV-package, but
it will not take more than 2% of 1Mb (Advanced Computer default Max memory value)

Can I edit and publish my own C SuS SuS?
No... You can't use C SuS SuS parcer/compiller 
(only parcer and compiller) code for your own projects without my approval.
But you can create your own features, packs, and modules for C SuS SuS Compiller.
So tecnicaly you can create your own features based on features provided by C SuS SuS.

 How to publish project that uses C SuS SuS?
If you have your own project/script programmed in C SuS SuS that you want to publish, 
then you have to tell the user of your project that it require C SuS SuS to work, 
so user need to download it manualy.
Or you can create the installer that will launch that C SuS SuS installer.

Your project installer can install C SuS SuS buy it's own but it hardly unrecomended, 
because any changes in default C SuS SuS code or installer or git files 
that 100% will be done in future may break some dependencies in your project.

Continue instalation? [Y/N]
]])
if continue() then return end
end
paintutils.drawFilledBox(4,5,maxX,maxY,colors.lightBlue)
os.pullEvent()
-- Ask for api folder
term.setTextColor(colors.orange)
term.setCursorPos(4,5)
print("!If you don't need module leave the field empty!")
term.setTextColor(colors.blue)
api_folder=readPath(4,6,"1. Api instalation folder:","/apis/cssc")

-- Ask for env package
--print("\n   (Leave next's empty if you don't need it)")
cssc_path=readPath(4,8,"3. Cssc main module:",api_folder.."/cssc.lua")
env_package_path=readPath(4,10,"2. _ENV-pack:",api_folder.."/env_pack.lua")

startup_path=readPath(4,12,"3. Startup:","startup/00_cssc.lua")

cssc_set=cssc_path:match"%S"
envP_set=env_package_path:match"%S"
startup_set=startup_path:match"%S"

--Generate startup
if startup_set then
    startup_code=startup_code:format(cssc_path,env_package)
end

--Total
print(                 "\n   4. Selected modules:"..
      (cssc_set    and("\n      - C SuS SuS Compiller:%8.2f Kbs"):format(#cssc_code/1024.0)or"")     ..
      (envP_set    and("\n      - _ENV-pack:          %8.2f Kbs"):format(#env_pack_code/1024.0)or"")..
      (startup_set and("\n      - Startup module:     %8.2f Kbs"):format(#startup_code/1024.0)or"")..
                    ("\n\n      = Total size:         %8.2f Kbs"):format(((cssc_set and#cssc_code or 0)+
                                                                      (envP_set and#env_pack_code or 0)+
                                                                      (startup_set and#startup_code or 0))/1024))
print("\n      Continue instalation? [Y/N]")
if continue() then return end
 



