-- C SuS SuS Programming language compiler 3.5 - alpha

--CODE START
--this section contain all lua keywords for specific features
K={}
Ks="if function for while repeat elseif else do then end until local return in break "
Kb={}
Ks:gsub("(%S+)( )", function (x,s)K[#K+1]=s..x..s Kb[x]=#K end )
--initialize lambda function feature
local l= function (C,o) --DO NOT PLACE LAMBDA AT THE START OF FILE!!! You will got ")" instead of "function(*args*)"
    local i,a,e,p=#C.R,1
    e=C.R[i]
    p=e:find"^%)%s*" and "" or "("
    while i>0 and (#p>0 and (a and (e:match"[%w_]+" or "..."==e) or ","==e) or #p<1 and  not e:find"^%(%s*")do --comma or word or ( if ) located
        i,a=i-1,not a
        e=C.R[i] end
    table.insert(C.R,#p<1 and i or i+1,K[2]..p)-- K[2] - function keyword K[13] - return
    C.R[#C.R+1]=(#p>0 and ")" or "")..(o:sub(1,1)=="-" and K[13] or "") --WARNING!!! Thanks for your attention! =)
    if C.L then --core exist
        C.pv=2 -- Lua5.3 operators compatability patch (and for some future things)
        C.C.L("function",1)
    end
end

--FEATURES TABLE
F={
--initialise main features::

-- keywords and "if else then" shortcut section
E={ ["/|"]=K[1],--if
    ["?"]=K[9],--then
    [":|"]=K[6],--elseif
    ["\\|"]=K[7]},--else
K={ ["@"]=K[12],--local
    ["$"]=K[13],--return
    ["||"]=" or ",--or
    ["&&"]=" and ",--and
    ["!"]=" not ",--not
    [";"]=K[10]},--end

--lambda section
F={ ["->"]=l,
    ["=>"]=l}

,dbg={function(C,V)--debug (To debug the second part of compiller, removed in final version)
        C.F[V]=function(k)
            if k=="P"then
                require"cc.pretty".pretty_print(C.R)
            else
                print(table.concat(C.R),#C.R)
            end
        end
        --C.S.dbg=nil
    end}
}

-- C SuS SuS Compiller (CSSC)
-- Base function for all cores and modules
NL,a,b=load --native CraftOS load function
L= function (x,name,mode,env)
    if type(x)=="string" then -- x might be a function or a string
        local c=x:match"^<.->" or x:match"^#!.-\n?<.->" -- locate control string
        if c then --control string exists!
        
            --INITIALISE LOCALS
            local po,R,O,C,s,t,a,b,l,e="",{""},{['"']= function () return  end ,["\0"]= function (C) local r=C.R r[#r]=r[#r].." "..(table.remove(C.c,1) or "") end ,['..']='..',['...']='...'} -- " - for strings \0 - for comments
            x=x:sub(#c+1) --remove control string to start parsing
            C={O=O,C= function () end ,R=R,F={},c={},l=1,pv=1} -- initialise control tablet for special functions call
                 --S -> the core module (empty by default)
            --INITIALIZE COMPILLER
            for K,V in ("D"..c):gmatch"([%w_]+)%(?([%w_. ]*)"do--load flags that used in control string: K - feature name V - feature argument
                if F[K] then -- feature exist                   -- D here is for default beaviour that expected from C SuS SuS
                    for k,v in pairs(F[K])do O[k]=v end        -- D is not initialised at the start to make commpiller smaller
                    l=F[K][1] and F[K][1](C,V,x,name,mode,env)-- [1] index is used to store special compiller directives
                    if l then  return l end --PRELOAD CHECK
                end                                          -- if special has argumet V ex: "<pre(V)>" then F["pre"][1](ctrl_table,"V")
            end
            O[1]=nil -- remove trash from current_operators table (all specials in S table now)
            
            --COMPILE -- o: operator, w: word
            l=#x+1
            for o,w,i in x:gmatch"([%s!#-&(-/:-@\\-^{-~`]*%[?=*[%['\"]?%s*)([%w_]*[^%w%p%[-`{-~\\-_%s]*[^\n%S]*)()"do
                                        -- see that pattern? Now try to spell it in one breath! =P
                --LINE COUNTER          -- in this pattern the word (w) will never be "^%s*$"!
                o:gsub("\n", function ()C.l=C.l+1 end )
                --STRING MODE: string or comment located and must be captured
                if s then
                    a,b,e=o:find(#s<2 and "(\\*[\n"..s.."])%s*" or "(%]=*%])%s*") --locate posible end of string (depends on string type)
                    if a and (#s<2 and (s=="\n" or #e%2>0) or #s==#e) or i==l then -- end of something found, check is it our string end or not
                        b=b or i
                        t=t..o:sub(0,b) --finish string
                        if c then c=C.c
                        else 
                            t=C.C(nil,t,i)or t --CORE module
                            c=R
                        end
                        c[#c+1]=t -- insert object
                        o=po..o:sub(b+1) --form new operators sequence
                        s,t=nil --disable string mode
                    else
                        t=t..o..w --continue string
                    end
                end
                
                --DEFAULT MODE: main compiler part
                if  not s then
                    --STRING LOCATOR
                    o=o:gsub("-%-%s-\n","")--remove all empty comments (they may corrupt a lot of things!)
                    c=o:match"-%-%[?=*%[?" --if start found: init str_mode
                    s=o:match"%[=*%["or o:match"['\"]"
                    if c or s then
                        a=o:find(c or s,1,1)
                        s=c and (c:sub(3)==s and s or "\n") or s --(string/long_string/long_comment) or small_comment
                        t,w=o:sub(a)..w,"" -- save temp string and errase word
                        o=o:sub(0,a-1)..(c and "\0" or '"') -- correct opeartor seq add control character
                        po=c and (o or "") or "" -- set previous operator
                    end
                    --IF NOT COMMENT
                    if not c or i==l then
                        --OPERATOR PARCE: Default parcer and custom functions launcher
                        while #o>0 do
                            a=o:match"^%s*" --this code was made to decrase the length of result table and allow spacing in operators capture section
                            R[#R]=R[#R]..a
                            o=o:sub(#a+1)
                            for i=3,1,-1 do --WARNING! Max operator length: 3    
                                a=o:sub(1,i)  -- a variable here used to store enabled_operators[posible operator]
                                b=O[a] or i<2 and a
                                if b and #o>0 then --if O[posible_operator] -> C SuS SuS enabled operator (or something else) found and must be parced
                                    b=C.C(a,b,i) or b -- CORE module call
                                    if 7>#type(b) then --type<7 -> string; >7 - function | these can't be any othere values
                                        R[#R+1]=b --string located
                                        o=o:sub(i+1)
                                    else
                                        b={b(C,o,w,i)} --if there is a special replacement function
                                        o,w=b[1] or o:sub(i+1),b[2] or w
                                    end
                                    break -- operator found! break out...
                                end
                            end
                        end
                        --WORD
                        if #w>0 then
                            w=C.C(nil,w,i) or w --CORE module call
                            R[#R+1]=w
                        end
                    end
                end 
            end
            
            --FINISH COMPILE
            for k,v in pairs(C.F)do
                local a,n,m,e=v(x,name,mode,env)--launch all finalizer function
                if C.rt then  return a,n end -- if finaliser return something then return it vithout calling native load
                x=a or x
                name=n or name
                mode=m or mode
                env=e or env
            end
            x=table.concat(R)
            if mode=="c" then  return R end 
        end
    end
    return NL(x,name,mode,env)
end

--COMPILLER CORES AND MODULES:load other features of compiler using compiler ITSELF
a,b=L([=[<K,E,F>

F.K[';']=C,o,w=> -- any ";" that stand near ";,)]" or "\n" will be replaced by " end " for ex ";;" equal to " end  end "
    @a,p=o:match"(;*) *([%S\n]?)%s*"
    /|#p>0&&p~="("||#a>1?
        for i=1,#a do
        C.R[#C.R+1]=K[10]
        /|C.L?C.C.L("end");--K[10]="end"
                  end
    \|C.R[#C.R+1]=";";
    $o:sub(#a+1);
    
--OBJ: object separator function
OBJ=o=>$type(o)=='string'&&o:match"%S+"||"";

do--CSSC Environmet table (CC:T-f)
@o=setmetatable({},{__index=os})
@c=value,arg=>
    @t=type(value)
    arg=arg||{}
    /|t=="function"?
        @I=debug.getinfo(value)
        @f=NL(t.dump(value),I.source,nil,arg.env||getfenv(value))
        for i=1,I.nups do 
            /|arg.ref?debug.upvaluejoin(f,i,value,i)
            \|@n,d=debug.getupvalue(value,i) debug.setupvalue(f,i,d);
                      end $f
    :|t=="table"?
        t={}for k,v in pairs(value)do t[k]=v end
        $setmetatable(t,arg.meta||getmetatable(value));;
@m={__index=_G}
env={os=o,
     clone=c,
     load=L,
     loadfile=c(loadfile,{env=setmetatable({load=L},m)}),
     include=name,force=>
         @e=getfenv(2)
         @r=e.require
         /|!r?error("Unable to include '"..name.."', _ENV has no require function!",2);
         @f,t=pcall(r,name)
         /|!f?error(t,2);
         for k,v in pairs(t)do 
             e[k]=!force&&e[k]||v
                           end $t;}

@e={env=setmetatable({loadfile=env.loadfile},m)}
o.run=c(os.run,e)
o.loadAPI=c(os.loadAPI,e)
end

--Error detector
err=C,s=>C.err=C.err||"SuS["..C.l.."]:"..s;
F.err={C=>
    C.F.err==>
        /|C.err?C.rt=1$ nil,C.err;;;}

--Preload feature
F.pre={C,V,x,n,m,e=>
    /|!cssc.preload?cssc.preload={};
    @P=cssc.preload
    /|P[V]?$NL(P[V],n,m,e);
    C.F.pre==>P[V]=table.concat(C.R);;}

--Debug feature (old debug will be removed in final version)
F.dbg={C,V=>-- V - argument
    @v=V
    C.F.dbg=x,n,m=>
        /|v=="P"?require"cc.pretty".pretty_print(C.R)
        :|v=="p"?print(table.concat(C.R));
        /|m=="c"?$R
        :|m=="s"?$table.concat(C.R);;;}

--0b0000000 and 0o0000.000 number format support (avaliable exponenta: E+-x)
F.b={C=>--return function that will be inserted in special extensions table
    F.c[1](C)
    C.C.W.b=o,w=>
        @a,b,c,r,t=w:match"^0([bo])(%d*)([eE]?.*)" --RUSH EEEEEEEEEEEEE for exponenta
        /|C.b&&C.R[#C.R]=="."?t,b,c=C.b,w:match"(%d+)([eE]?.*)"--b located! posible floating point!
        \|C.b=nil;
        /|b?--number exist
          t,r=t||(a>"b"&&"8"||"2"),0--You are a good person if you read this (^_^)
          for i,k in b:gmatch"()(.)"do
             /|k>=t?err(C,"This is not a valid number: 0"..a..b..c);--if number is weird
             r=r+k*t^(#b-i)-- t: number base system, r - result, i - current position in number string
                                   end
          r=C.b&&tostring(r/t^#b):sub(3)||r--this is a floating point! recalculate required!
          C.b=!C.b&&#c<1&&t||nil--floating point support
          $r..c;;;}


--This function works as #include directive in C++
--include"module" inserts all module values to _ENV (_ENV must have 'require' inside it!)
do
-- Add path
adp=str=>cssc.path=cssc.path..str..";";
--ATP: Attempt to perform
ATP=C,wt,on=>err(C,"Attempt to perform '"..wt.."' on '"..on.."'!");

--C SuS SuS LANGUAGE CORE
F.c={C=>
    /|C.CR?$;
    C.CR=1--mark & skip
    C.L={{st=1,t="main"},o={},c={}}--leveling table [o -> on lvl open, c -> on lvl close]
    @l=C.L
    @r=C.R
    --add uncatched operators
    for k in("=~<>"):gfind"."do k=k..'='C.O[k]=k end
    --EVENT invocator
    @f=T,o,w,i=>for k,v in pairs(T)do w=v(o,w,i)or w end $w;
    --CORE table
    C.C={W={},O={},A={},K={},o={['and']=1,['or']=1,['not']=1}, -- o for operators
    --LEVELING controller
        l={["for"]="do",["while"]="do",["repeat"]="until",["if"]="then",["elseif"]="then",["else"]="end",["do"]="end",["function"]="end",["{"]="}",["("]=")",["["]="]"},--level ends table (then has no end because it can has multiple ones)
        L=o,v=>/|v?l[#l+1]=f(l.o,o,{t=o})     -- level+
               \|@e=C.C.l[l[#l].t]
                 /|e&&e~=o?err(C,"Expected '"..e.."' after '"..l[#l].t.."' but got '"..o.."'!");--level error detection
                 /|#l<2?err(C,"Unexpected '"..o.."'!");
                 @cl=l[#l]
                 l[#l]=#l<2&&l[#l]||nil
                 f(l.c,o,cl);;}-- level-
    @c=C.C
    C.F[1]=x,n,m,e=>
        /|#l>1?err(C,"Unclosed construction! Missing '"..(c.l[l[#l].t]||"end").."'!"..#l);
        @p=e&&e.package --CC:T require 
        /|p?p.path=p.path..cssc.path--if package.path exist then add additional path
            setfenv(p.loaders[2],setmetatable({loadfile=env.loadfile},{_index=_G}))
            for k,v in pairs(env)do e[k]=rawget(e,k)||v end;;
    
    --CORE function
    setmetatable(C.C,{__call=S,o,w,i=>
        /|o=='"'||o=='\0'?$;--skip string markers and comments
        C.pv=C.cv -- set previous value
        C.cv=nil
        /|#type(w)==6?
            @ow=OBJ(w)
            @k=Kb[ow]--get keyword id if keyword
            /|k?C.cv=1--KEYWORD
                --keywords leveling part
                /|k>5&&k<12?c.L(ow);--end  level
                /|k<10?c.L(ow,1);   --open level
                w=f(c.K,o,w,i)||w
            :|c.o[ow]? C.cv=2 w=f(c.O,o,w,i)||w;;--OPERATOR (and or not)
        /|!C.cv?
            /|!o?C.cv=w:find"^['\"%[]"&&6||3 w=f(c.W,o,w,i)||w                       --KEYWORD(1)  WORD(3)         STRING(6)
            \|C.cv=o:find"^[%[%({]"&&4||o:find"^[%]%)}]"&&5||2
              /|C.cv==4?c.L(o,1); --breaket+
              /|C.cv==5?c.L(o);   --breaket-
              w=f(c.O,o,w,i)||w;;                                                    --OPERATOR(2) BREAKET_OPEN(4) BREAKET_CLOSE(5)
        w=f(c.A,o,w,i)||w--ALL
        $w;})
    
    --START SEARCHER
    --@lb=->OBJ(r[#r]):find"^ ?[%]%)}\"']";
    l.o[#l.o+1]=o,t=>--on level open
        @s=#r+1
        /|C.pv&&C.pv<3?l[#l].st=s;--previous level
        t.st=s+1;--next level table
    c.W.st=o,w=>
        @p=OBJ(r[#r])
        /|p:find"[.:]"&&#p<2?$;--default start searcher allowed operators
        /|C.cv==6&&C.pv>2?$;--current word is string and previous word was an operator or keyword
        l[#l].st=#r+1;
    ;}
end

--UE:Unexpected value
UE=C,o=>err(C,"Unexpected '"..o.."'!");
-- Default function arguments feature
F.D={C=>
    F.c[1](C)
    @l=C.L
    @r=C.R
    l.o[#l.o+1]=o,t=>
        /|t.t=="function"?t.ada=1;-- allow_default_args for nex level
        /|l[#l].ada?
            l[#l].ada=nil
            /|t.t=="("?t.da={};;;
    l.c[#l.c+1]=o,t=>--on level close
        l[#l].ada=nil
        /|t.da&&#t.da>0&&t.t=="("? -- da - default_args
            r[#r+1]=")"
            t.da[#t.da].nd=t.da[#t.da].nd||#r-1 --set last index if not exist
            --remove default statements and finalise default args
            for i=#t.da,1,-1 do
            --print(r[t.da[i].st],t.da[i].nd,#r,t.t)
                @ob=r[t.da[i].st-1]
                r[#r+1]="if "..ob.."==nil then "..ob.."="--insert start
                for j=t.da[i].st,t.da[i].nd do r[#r+1]=r[j]end--insert obj
                r[#r+1]=" end "--insert end
                for j=t.da[i].nd,t.da[i].st,-1 do table.remove(r,j)end--remove default arg
                            end
            t.da=nil
            C.C.A.da=o,w=>C.C.A.da=nil$()->;;;;--this part is required to switch of the ')' insertion (because we already inserted one)
    C.C.O.da=o,w=> --catch coma and ';'
        @d=l[#l].da
        /|d&&o==';'?UE(C,';');
        /|d&&#d>0&&o==','?
            d[#d].nd=d[#d].nd||#r;;
    C.O[":="]=C,o,w=>
        /|!l[#l].da?UE(C,':=')--emit an error
        \|@d=l[#l].da
          d[#d+1]={st=#r+1};;
    ;}

-- Nil forgiving operators feature
do
@c,d=setmetatable--nil returning object | nilF feature: nil forgiving operators | d -> default c-> colon
d=c({},{__call=->nil;,__index=->nil;})
c=c({},{__index=->()->nil;;})

N=(o,i)=>-- o -> object, i -> index
    /|o==nil?$i&&c||d;--> obj not exist (false and other variables are allowed)
    /|i?$o[i]&&o||c;--> obj and index exist -> colon mode
    $o;-- obj exist but not index

F.N={C=>
    F.c[1](C)
    C.C.O.N=o=>/|F.N[o]?C.cv=C.pv;;;}--mark F.N operators as start searcher allowed (core-invisible)
for v,k in('.:"({'):gfind"()(.)"do
    F.N['?'..k]=C,o,w=>
        @r=C.R
        /|#r<2||C.pv<3?ATP(C,k,r[#r]);--previous value was a keyword or operator
        /|o:sub(3):find"[^\0%s]"?ATP(C,OBJ(o:sub(3)),k);
        table.insert(C.R,C.L[#C.L].st," cssc.nilF(")--first part
        r[#r+1]=v==2&&",'"..w.."')"||')'
        /|v==1?--no error and index detected
            C.ci=#r--index of ? 
            C.pc=#r+2-- index of word
            C.C.A.str=o=>
                /|C.pc<=#r? print(C.cv,w,r[#r],r[#r-1],r[#r-2],#r,o)
                    /|C.cv>4||C.cv>3&&!o:find'^[)%]}]'?
                        table.insert(r,C.ci,",'"..w.."'");
                    C.C.A.str=nil;;;
        $o:sub(2);
                               end
end

-- X= operators feature.
--WARNING! They don't support multiple asignemnt (a,b X= *code*) - is prohibited!

--Add initialiser function to F.K feature to enable support of &&= and ||= 
F.K[1]=C=>C.EQ={"&&","||",unpack(C.EQ||{})};
-- ?= function
@qeq=b,a=> --b - base, a - adition
/|a==nil?$b
\|$a;;
F.C={C=>
    F.c[1](C)--load start searcher
    --EQ - table with operators that support *op*= behaviour
    C.EQ={"+","-","*","%","/","..","^","?",unpack(C.EQ||{})}
    @l=C.L
    @r=C.R
    C.C.A.br=o,w=>
        /|l[#l].br&&(C.pv==3||C.pv>4)&&(C.cv==1||C.cv==3||(o==','||o==';'))? --breaket request located and end of block located
            l[#l].br=nil
            r[#r+1]=")";;
    l.c[#l.c+1]=o,t=>/|t.br?r[#r+1]=")";; -- on level end
    C.F.c==>/|l[#l].br?r[#r+1]=")";;
    --operator main parce function
    @op=C,o,w=>
        @lt=l[#l].t
        /|lt:find"[{(%[]"||lt=="if"||lt=="for"||lt=="while"?err(C,"Attempt to use X= operator in prohibited area! '"..lt.." *var* X= *val* "..C.C.l[lt].."'");
        /|OBJ(r[l[#l].st-1]||"")==","?err(C,"Comma detected! X= operators has no multiple assignments support!");
        /|#r<2||C.pv<3?ATP(C,k,r[#r]);
        o=o:match"(.-)="--for this we need only the first part of operator
        r[#r+1]="="..(o=="?"&&"cssc.q_eq("||"")--insert equality or ?=
        l[#l].m={bor=#r+1} --Lua5.3 feature support
        for i=l[#l].st,#r-1 do r[#r+1]=r[i]end --copy variable from the start of an object
        @t=#type(C.O[o])
        /|o=="?"?r[#r+1]=","
        :|t==6?r[#r+1]=C.O[o]--string
        :|t==3?r[#r+1]=o--operator
        \|C.O[o](C,o,w);--function
        --print(C,o,w)
        /|o~="?"?r[#r+1]="("; --add opening breaket
        l[#l].br=1  --request closing breaet for this level
        l[#l].m={bor=#r+1}; --Lua5.3 feature support
    -- main function initialiser        
    for i=1,#C.EQ do C.O[C.EQ[i].."=" ]=op end;--END OF F.C
}

--IS keyword simular to typeof()
@tof=o->(getmetatable(o)||{}).__type||type(o);
@is=setmetatable({},{__concat=v,a=>$setmetatable({a},--is inited
        {__concat=v,a=> --a args v value
        /|type(a[1])=="table"?a=a[1];
        for i=1,#a do
            /|tof(v)==a[i]?$true;
                  end
        $false;});})
_G.typeof=tof--include typeof into global environment
F.IS={C=>
    F.c[1](C) 
    C.C.o['is']=1
    @l=C.L
    C.C.O[1]=o,w=>
        w=OBJ(w)
        /|w=='is'?
            /|#C.R<2||C.pv<3?ATP(C,'is',C.R[#C.R]);
            $" ..cssc.is.. ";;;}

--Lua5.3 operators feature! Bitwise and idiv operators support!
do
@B={}
for k,v in pairs(bit32)do B[k]=v end
B.idiv=a,b->math.floor(a/b);
B.shl=B.lshift
B.shr=B.rshift
@bt={shl='<<',shr='>>',bxor='~',bor='|',band='&',idiv='//'}
@kp={}('and or , = ; > < >= <= ~= == '):gsub("%S+",(x)=>kp[x]=1;) -- all operators that has lower priority than bitise operators
@f=t,m->"Attempt to perform "..t.." bitwise operation on a "..m.." value";
M={bnot=setmetatable({},{
    __pow=a,b=>
        @m=(getmetatable(b)||{}).bnot
        /|m?$m(b);
        m=type(b)
        /|m~='number'?error(f('bitwise',m),3);
        $B.bnot(b);})}

for k,v in pairs(bt)do
    @n='__'..k--name of metamethod
    @t='number'--number value type
    @e=v=='//'&&'idiv'||'bitwise'
    @f=a,b=>--base calculation function
        @m=(getmetatable(a[1])||{})[n]||(getmetatable(b)||{})[n]
        /|m?$m(a,b);--metamethod located! Calculation override!
        m=type(a[1])
        m=m==t&&type(b)||m
        /|m~=t?error(f(e,m),3);
        $B[k](a[1],b);
    M[k]=v=='//'&&{__div=f}||{__concat=f}
                   end
F.M={C=>
    C.EQ={">>","<<","&","|",unpack(C.EQ||{})}--additional equality
    F.c[1](C)--enable core
    @l=C.L
    @r=C.R
    l[#l].m={bor=1}
    --on level open
    l.o[#l.o+1]=o,t=>
        /|o=="function"&&C.pv==2?l[#l].m.sk=1; -- curent value is function keyword and previous value was an operator -> mark function end on skip
        t.m={bor=#r+2};
    --function to correct priority of sequence (set on O and on W)
    C.C.A.pc=o,w=>
        @i=#r+2
        @b=C.cv<2&&!l[#l].m.sk||o&&kp[o]--current value is equal to keyword or operator and has lower priority than bitwises
        l[#l].m.sk=nil--reset end skip
        /|b?l[#l].m={bor=i};--reset the starter table
        /|b||o&&(" .. + -"):find(' '..o..' ',1,1)?l[#l].m.idiv=i;;--start of sequence and reset!
    for k,v in pairs(bt)do
        C.O[v]=C,o,w=>
            @p=OBJ(r[#r])-- grep the value, skip the comments
            /|v=='~'&&--posible unary operator
                ((p:find"[^%)}%]'\"%P]"&&!p:find"%[=*%[")||--there is no breaket or string before op or string
                Kb[p]||kp[p])?-- there is no keyword before op
                    r[#r+1]="cssc.mt.bnot^" $;--bnot located. Insert and return...
            table.insert(r,l[#l].m[k]||l[#l].m.bor||l[#l].st,"setmetatable({")
            r[#r+1]="},cssc.mt."..k..(v=='//'&&')/'||')..')
            @i=#r+1
            @l=l[#l]
            /|v=='|'?l.m.bxor=i;
            /|v:find'[|~]'?l.m.band=i;
            /|v:find'[|~&]'?l.m.shl,l.m.shr,l.m.idiv=i,i,i;-- Full support of bitwizes!111 Finaly!
            /|v:find"([><])%1"?l.m.idiv=i;;-- Full support of idiv
                       end;}
end

--DEFAULT: ALL INCLUSIVE (E feature disabled!)
F.A={C=>
 F.M[1](C) -- Lua5.3 opts
 F.K[1](C) -- Keyword shortcuts
 F.IS[1](C)-- IS keyword
 F.N[1](C) -- nil forgiving operators
 F.C[1](C) -- X= operators
 F.D[1](C) -- default function arguments
 F.b[1](C) -- octal and binary number formats
 C.O['..']=' ..' --fix number concatenation bug
 for K,V in pairs{F.K,F.F}do
     for k,v in pairs(V)do
         C.O[k]=v
     end
 end
 ;}

_G.cssc={features=F,load=L,nilF=N,mt=M,version="3.5-alpha",creator="M.A.G.Gen.",_CSSC=env,_ENV=_ENV,path=";",addPath=adp,is=is,q_eq=qeq,env=env}
]=],"SuS",nil,_ENV)--]=]
b=b and error(b)
a=a and a(...)
