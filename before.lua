a,b=cssc.load([=[<K,E,F,dbg>
F.K[';']=C,o,w=>
@a,p=o:match"(;*) *([%S\n]?)%s*"
/|#p>0&&p~="("||#a>1?
for i=1,#a do
C.R[#C.R+1]=K[10]
/|C.L?C.C.L("end");
end
\|C.R[#C.R+1]=";";
$o:sub(#a+1);
OBJ=o=>$type(o)=='string'&&o:match"%S+"||"";
env={}
F.D={["\0"]=C=>@r=C.R r[#r]=r[#r].." "..(table.remove(C.c,1)||"");,
['"']=C=>$nil;}
err=C,s=>C.err=C.err||"SuS["..C.l.."]:"..s;
F.err={C=>
C.F.err=C=>
/|C.err?$ nil,C.err;;;}
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
F.c[1](C)
C.C.W.b=o,w=>
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
ATP=C,wt,on=>err(C,"Attempt to perform '"..wt.."' on '"..on.."'!");
F.c={C=>
/|C.CR?$;
C.CR=1
C.L={{st=1},o={},c={}}
@l=C.L
@r=C.R
for k in("=~<>"):gfind"."do k=k..'='C.O[k]=k end
@f=T,o,w,i=>for k,v in pairs(T)do w=v(o,w,i)or w end $w;
C.C={W={},O={},A={},K={},o={['and']=1,['or']=1,['not']=1},
l={["for"]="do",["while"]="do",["repeat"]="until",["if"]="then",["elseif"]="then",["else"]="end",["do"]="end",["function"]="end",["{"]="}",["("]=")",["["]="]"},
L=o,v=>/|v?l[#l+1]=f(l.o,o,{t=o})
\|@e=C.C.l[l[#l].t]
/|e&&e~=o?err(C,"Expected '"..e.."' after '"..l[#l].t.."' but got '"..o.."'!");
/|#l<2?err(C,"Unexpected '"..o.."'!");
f(l.c,o,l[#l])l[#l]=#l<2&&l[#l]||nil;;}
@c=C.C
C.F[1]==>/|#l>1?err(C,"Uncolsed construction! Missing '"..(c.l[l[#l].t]||"end").."'!");;
setmetatable(C.C,{__call=S,o,w,i=>
/|o=='"'||o=='\0'?$;
C.pv=C.cv
C.cv=nil
/|#type(w)==6?
@ow=OBJ(w)
@k=Kb[ow]
/|k?C.cv=1 w=f(c.K,o,w,i)||w
/|k>7&&k<12?c.L(ow);
/|k<10?c.L(ow,1);
:|c.o[ow]? C.cv=2 w=f(c.O,o,w,i)||w;;
/|!C.cv?
/|!o?C.cv=w:find"^['\"%[]"&&6||3 w=f(c.W,o,w,i)||w
\|C.cv=o:find"^[%[%({]"&&4||o:find"^[%]%)}]"&&5||2
/|C.cv==4?c.L(o,1);
/|C.cv==5?c.L(o);
w=f(c.O,o,w,i)||w;;
w=f(c.A,o,w,i)||w
$w;})
l.o[#l.o+1]=o,t=>
@s=#r+1
/|C.pv&&C.pv<3?l[#l].st=s;
t.st=s+1;
c.W.st=o,w=>
@p=OBJ(r[#r])
/|p:find"[.:]"&&#p<2?$;
/|C.cv==6&&C.pv>2?$;
l[#l].st=#r+1;
;}
do
@c,d=setmetatable
d=c({},{__call=->nil;,__index=->nil;})
c=c({},{__index=->()->nil;;})
N=(o,i)=>
/|o==nil?$i&&c||d;
/|i?$o[i]&&o||c;
$o;
F.N={C=>
F.c[1](C)
C.C.O.N=o=>/|F.N[o]?C.cv=C.pv;;;}
for v,k in('.:"({'):gfind"()(.)"do
F.N['?'..k]=C,o,w=>
@r=C.R
/|#r<2||C.pv<3?ATP(C,k,r[#r]);
/|o:sub(3):find"[^\0%s]"?ATP(C,OBJ(o:sub(3)),k);
table.insert(C.R,C.L[#C.L].st," cssc.nilF(")
r[#r+1]=v==2&&",'"..w.."')"||')'
/|v==1?
C.ci=#r
C.pc=#r+2
C.C.A.str=o=>
/|C.pc<=#r? print(C.cv,w,r[#r],r[#r-1],r[#r-2],#r,o)
/|C.cv>4||C.cv>3&&!o:find'^[)%]}]'?
table.insert(r,C.ci,",'"..w.."'");
C.C.A.str=nil;;;
$o:sub(2);
end
end
F.K[1]=C=>C.EQ={"&&","||",unpack(C.EQ||{})};
@qeq=b,a=>
/|a==nil?$b
\|$a;;
F.C={C=>
F.c[1](C)
C.EQ={"+","-","*","%","/","..","^","?",unpack(C.EQ||{})}
@l=C.L
@r=C.R
C.C.A.br=o,w=>
/|l[#l].br&&(C.pv==3||C.pv>4)&&(C.cv==1||C.cv==3||(o==','||o==';'))?
l[#l].br=nil
r[#r+1]=")";;
l.c[#l.c+1]=o,t=>/|t.br?r[#r+1]=")";;
C.F.c==>/|l[#l].br?r[#r+1]=")";;
@op=C,o,w=>
/|#r<2||C.pv<3?ATP(C,k,r[#r]);
o=o:match"(.-)="
r[#r+1]="="..(o=="?"&&"cssc.q_eq("||"")
l[#l].m={bor=#r+1}
for i=l[#l].st,#r-1 do r[#r+1]=r[i]end
@t=#type(C.O[o])
/|o=="?"?r[#r+1]=","
:|t==6?r[#r+1]=C.O[o]
:|t==3?r[#r+1]=o
\|C.O[o](C,o,w);
/|o~="?"?r[#r+1]="(";
l[#l].br=1
l[#l].m={bor=#r+1}
;
for i=1,#C.EQ do C.O[C.EQ[i].."=" ]=op end;
}
@tof=o->(getmetatable(o)||{}).__type||type(o);
@is=setmetatable({},{__concat=v,a=>$setmetatable({a},
{__concat=v,a=>
/|type(a[1])=="table"?a=a[1];
for i=1,#a do
/|tof(v)==a[i]?$true;
end
$false;});})
env.typeof=tof
F.IS={C=>
F.c[1](C)
C.C.o['is']=1
@l=C.L
C.C.O[1]=o,w=>
w=OBJ(w)
/|w=='is'?
/|#C.R<2||C.pv<3?ATP(C,'is',C.R[#C.R]);
$" ..cssc.is.. ";;;}
do
@B={}
for k,v in pairs(bit32)do B[k]=v end
B.idiv=a,b->math.floor(a/b);
B.shl=B.lshift
B.shr=B.rshift
@bt={shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}
@kp={}('and or , = ; > < >= <= ~= == => -> '):gsub("%S+",(x)=>kp[x]=1;)
@f=t,m->"Attempt to perform "..t.." bitwise operation on a "..m.." value";
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
C.EQ={">>","<<","&","|",unpack(C.EQ||{})}
F.c[1](C)
@l=C.L
@r=C.R
l[#l].m={bor=1}
l.o[#l.o+1]=o,t=>t.m={bor=#r+2};
C.C.A.pc=o,w=>
@i=#r+2
@b=C.cv<2||o&&kp[o]
/|b?l[#l].m={bor=i};
/|b||o&&(" .. + -"):find(' '..o..' ',1,1)?l[#l].m.idiv=i;;
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
_G.cssc={features=F,load=L,nilF=N,mt=M,version="3.5-beta",creator="M.A.G.Gen.",__CSSC=_ENV,is=is,q_eq=qeq,env=env}
]=],"SuS","s",_ENV)
print(a)
file=fs.open("data/progs/a_new_cssc/after.lua","w")
file.write(a)
file.close()