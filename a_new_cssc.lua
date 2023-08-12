-- C SuS SuS Programming language compiler 3.4-alpha

-- VARIABLE DOCUMENTATION
    --(variables already minified because it takes THE HECK OF A LOT time to find and replce them all after prog done)
    --IMPORTANT TABLES
    -- F - table with C SuS SuS language features
    -- R - table with parcing results
    -- S - table with special compiller extensions
    -- O - table with operators enable for current script
    -- C - control tablet that contains R,S,O tablets and other data for operators/specials functions (first argument to each function)
        -- C.F - table with finaliser functions that run after main script
        -- C.L - table with breaket levels: disabled by default but could be used by some features
        -- C.l - current line
    --CALCULATION VARS
    -- t - temp: used to store unfinished strings and some other temporal data
    -- s - str_mode: used to switch compiller to string or comment parceing mode
    -- R - result: table with parced code
    -- c - in compiller used to grab comments and throw them away from operator/word squence
    -- a - start_point of string/other data storage
    -- b - end point of string/other data storage
    -- i - usualy used for index
    -- p - posible *something*
    -- l - temporal container
    -- e - temporal container (used to calculate lines in main script)
    -- Some of variables may diaspear from script in future

--CODE START
--this section contain all lua keywords for specific features
K={}
Ks="if then elseif else local return end function for while in do repeat until break "
Kb={}
Ks:gsub("(%S+)( )",function(x,s)K[#K+1]=s..x..s  end)
--initialize lambda function feature
local l=function(C,o) --DO NOT PLACE LAMBDA AT THE START OF FILE!!! You will got ")" instead of "function(*args*)"
    local i,a,e,p=#C.R,1
    e=C.R[i]
    p=e:find"^%)%s*"and""or"("
    while i>0 and(#p>0 and(a and(e:match"[%w_]+"or"..."==e)or","==e)or#p<1 and not e:find"^%(%s*")do --comma or word or ( if ) located
        i,a=i-1,not a
        e=C.R[i] end
    table.insert(C.R,#p<1 and i or i+1,K[8]..p)-- K[8] - function keyword K[6] - return
    C.R[#C.R+1]=(#p>0 and")"or"")..(o:sub(1,1)=="-"and K[6]or"") --WARNING!!! Thanks for your attention! =)
end

--FEATURES TABLE
F={
--initialise main features::

-- keywords and "if else then" shortcut section
E={ ["/|"]=K[1],--if
    ["?"]=K[2],--then
    [":|"]=K[3],--elseif
    ["\\|"]=K[4]},--else
K={ ["@"]=K[5],--local
    ["$"]=K[6],--return
    ["||"]=" or ",--or
    ["&&"]=" and ",--and
    ["!"]=" not ",--not
    [";"]=function(C,o,w) -- any ";" that stand near ";,)]" or "\n" will be replaced by " end " for ex ";;" equal to " end  end "
              local e,a,p,k=K[7],o:match"(;*) *([%S\n]?)%s*([%(\"]?)"
              C.R[#C.R+1]=(#p>0 and (#k<1 or p~="\n") or#a>1)and e:rep(#a)or";"
              return o:sub(#a+1)end},

--lambda section
F={ ["->"]=l,
    ["=>"]=l}

,dbg={function(C,V)--debug (To debug the second part of compiller, removed in final version)
        C.F[V]=function(C,k)
            if k=="P"then
                require"cc.pretty".pretty_print(C.R)
            else
                print(table.concat(C.R),#C.R)
            end
        end
        --C.S.dbg=nil
    end}
}
NL,a,b=load --native CraftOS load function
L=function(x,name,mode,env)
    if type(x)=="string" then -- x might be a function or a string
        local c=x:match"^<.->"or x:match"^#!.-\n?<.->" -- locate control string
        if c then --control string exists!
        
            --INITIALISE LOCALS
            local po,R,S,O,C,s,t,a,b,l,e="",{""},{W={},O={}},{['"']="",["\0"]="\n",['..']='..',['...']='...'} -- " - for strings \0 - for comments
            x=x:sub(#c+1) --remove control string to start parsing
            C={O=O,S=S,R=R,F={},c={},l=1,pv=1} -- initialise control tablet for special functions calls
                -- Control table specification
                -- O - enabled operators
                -- S - enabled special functions
                -- R - result table
                -- F - finaliser functions
                -- c - table with comments
                -- l - line of code (used to catch errors)
                -- L - table with levels (in witch breaket we are?)
                -- pv - previous value (can be an operator, a word or string)
                
            
            --INITIALIZE COMPILLER
            for K,V in ("D"..c):gmatch"([%w_]+)%(?([%w_. ]*)"do--load flags that used in control string: K - feature name V - feature argument
                if F[K]then -- feature exist                   -- D here is for default beaviour that expected from C SuS SuS
                    for k,v in pairs(F[K])do O[k]=v end        -- D is not initialised at the start to make commpiller smaller
                    l=F[K][1]and F[K][1](C,V,x,name,mode,env)-- [1] index is used to store special compiller directives
                    if l then return l end--PRELOAD CHECK
                end                                          -- if special has argumet V ex: "<pre(V)>" then F["pre"][1](ctrl_table,"V")
            end
            O[1]=nil -- remove trash from current_operators table (all specials in S table now)
            
            --COMPILE -- o: operator, w: word
            l=#x+1
            for o,w,i in x:gmatch"([%s!#-&(-/:-@\\-^{-~`]*%[?=*[%['\"]?%s*)([%w_]*[^%w%p%s]*[^\n%S]*)()"do
                                        -- see that pattern? Now try to spell it in one breath! =P
                --LINE COUNTER          -- in this pattern the word (w) will never be "^%s*$"!
                o:gsub("\n",function()C.l=C.l+1 end)
                --STRING MODE: string or comment located and must be captured
                if s then
                    a,b,e=o:find(#s<2 and"(\\*[\n"..s.."])%s*"or"(%]=*%])%s*") --locate posible end of string (depends on string type)
                    if a and(#s<2 and(s=="\n"or#e%2>0)or#s==#e)or i==l then -- end of something found, check is it our string end or not
                        b=b or i
                        t=t..o:sub(0,b) --finish string
                        if c then c=C.c
                        else 
                            for k,v in pairs(S.W)do t=v(C,t,i)or t end --word/string parcers/overriders
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
                if not s then
                    --STRING LOCATOR
                    o=o:gsub("-%-%s-\n","")--remove all empty comments (they may corrupt a lot of things!)
                    c=o:match"-%-%[?=*%[?" --if start found: init str_mode
                    s=o:match"%[=*%["or o:match"['\"]"
                    if c or s then
                        a=o:find(c or s,1,1)
                        s=c and(c:sub(3)==s and s or"\n")or s --(string/long_string/long_comment) or small_comment
                        t,w=o:sub(a)..w,"" -- save temp string and errase word
                        o=o:sub(0,a-1)..(c and"\0"or'"') -- correct opeartor seq add control character
                        po=c and (o or "") or"" -- set previous operator
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
                                    for k,v in pairs(S.O)do b=v(C,a,b)or b end -- for all located operators: Lua and C SuS SuS
                                    if 7>#type(b)then --type<7 -> string; >7 - function | these can't be any othere values
                                        R[#R+1]=b --string located
                                        o=o:sub(i+1)
                                    else
                                        b={b(C,o,w,i)} --if there is a special replacement function
                                        o,w=b[1]or o:sub(i+1),b[2]or w
                                    end
                                    break -- operator found! break out...
                                end
                            end
                        end
                        --WORD
                        if #w>0 then
                            for k,v in pairs(S.W)do w=v(C,w,i)or w end --word/string parcers/overriders
                            R[#R+1]=w --insert word
                        end
                    end
                end 
            end
            
            --FINISH COMPILE
            a,b=nil
            for k,v in pairs(C.F) do
                a,b,e=v(C,x,name,mode,env)--launch all finalizer function
                if e then env=e end --custom env support
                if a or b then return a,b end -- if finaliser return something then return it vithout calling native load
            end
            x=table.concat(R)
            if mode=="c"then return R end
        end
    end
    return NL(x,name,mode,env)
end

--COMPILLER EXTENSIONS:load other features of compiler using compiler ITSELF (can be used as example of C SuS SuS programming)
a,b=L([[<K,E,F,dbg>
--OBJ function| UNUSED
OBJ=o->o:match"%S+";

--Environmet table
env={}

--Default features: comment parcing
F.D={["\0"]=C=>@r=C.R r[#r]=r[#r].." "..(table.remove(C.c,1)||"");,
     ['"']=C=>$nil;}

--Error detector
err=C,s=>C.err=C.err||"SuS["..C.l.."]:"..s;

F.err={C=>
    C.F.err=C=>
        /|C.err?$ nil,control_table.err;;;}

--Preload feature
F.pre={C,V,x,n,m,e=>
    /|!cssc.preload?cssc.preload={};
    @P=cssc.preload
    /|P[V]?$NL(P[V],n,m,e);
    C.F.pre=C=>P[V]=table.concat(C.R);;}

--Debug feature
F.dbg={C,V=>-- V - argument
    @v=V
    C.F.dbg=C,x,n,m=>
        /|v=="P"?require"cc.pretty".pretty_print(C.R)
        :|v=="p"?print(table.concat(C.R));
        /|m=="c"?$R
        :|m=="s"?$table.concat(C.R);;;}

--0b0000000 and 0o0000.000 number format support (avaliable exponenta: E+-x)
F.b={C=>--return function that will be inserted in special extensions table
    C.S.W.b=C,w=>
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
         
-- leveling function initialiser (breakets counter)
F.l={C=>
    /|C.O["("]?$;--if C.O["("] exist - leveling system already initialized, skip proccess (line 22)
    C.L={{p={l=0}},b={{},[0]={}},a={{},[0]={}}}-- 1 - open "({["; 0 - close "]})"
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
                        end;}            -- This code is hard to understand because
                                        -- it was sponsored by Peppino Spagetti from Pizza Tower PC game
--start searcher initialiser
F.s={C=>
    --init leveling function
    F.l[1](C)
    @l=C.L
    @r=C.R
    /|l[1].st?$; -- Searcher was inited before! Skip! VVV!DEBUG!VVV
    l.b[1][#l.b[1]+1]=C=>/|Kb[r[#r]:match"%w*"]||!r[#r]:find"[%w_%}%]%)\"']"?l[#l].st=#r+1;;--on level open
    l.a[1][#l.a[1]+1]=C=>l[#l].st=#r+1;--after level open
    l[1].st=1--first start of object is start of file (it must be set to avoid errors)
    C.S.W.st=C,w,i=>-- Cow says "MOOO"; F.s says "start of object is here *table index*"
        @p=r[#r]
        --check previous value for opts that continue the object " . : " 
        /|p:match"^[.:]"&&!p:match"%.%."?$;--exit
        --if current value is a string
        @ch=p:match"^ ?[%w_%]%)}\"']+"||""
        /|w:find"^[%['\"].-[%]'\"]"&&!Kb[ch]&&!(" and or not "):find(" "..ch.." ")?$;--previous value was a breaket or word (func"" "shortcut call") or string (func()""[]{}"" multy shortcall) (operators skip)
        --start of object found
        l[#l].st=#r+1;;}--set word as start

-- nil forgiving function initialiser
do
@c,d=setmetatable--nil returning object | nilF feature: nil forgiving operators | d -> default c-> colon
d=c({},{__call=->nil;,__index=->nil;})
c=c({},{__index=->()->nil;;})

N=(o,i)=>-- o -> object, i -> index
    /|o==nil?$i&&c||d;--> obj not exist (false and other variables are allowed
    /|i?$o[i]&&o||c;--> obj and index exist -> colon mode
    $o;-- obj exist but not index
end

-- Not null check feature! Must be loaded after E for E support
F.N={C=>
    F.s[1](C)--load start searcher!
    @p=C.O["?"]--if E feature was enabled
    @r=C.R
    @f=C,b=>/|r[C.pc]==r[#r]?table.insert(r,C.ci,",'"..r[#r].."'");--function to insert index if index have a call after it
            C.pc,C.L.b[1].pc,C.S.W.str=nil;

    @e="Attempt to perform '"
    C.O["?"]=C,o,w=>
        @a=o:match'.([.:%[%({"]?)'
        /|!r[#r]:find"^ ?[%w_%]%)}\"']%s-"?err(C,e.."?"..(a||"").."' on '"..(OBJ(r[#r])or"nil").."'");--if previous value was an operator
        /|#a>0?
            /|a:find"[.:]"&&!o:sub(3):find"^[\0%s]*$"?err(C,e..o:sub(3).."' on '?"..a.."'");--error if ?[.:] has operators but not word after it 
            table.insert(r,C.L[#C.L].st," cssc.nilF(")--Insert a breaket at the start of object!
            r[#r+1]=a==":"&&",'"..w.."')"||")"--Call required! Insert an 'index'!
            /|a=="."?-- Index detected, and call check required!
                C.ci=#r--save index of cell (call_index) to insert if it needed
                C.pc=#r+2--save index of word (posible_call)
                C.S.W.str=C,w=>/|w:find"^[%w_]"?$;
                               f(C);--for string shortcalls
                C.L.b[1].pc=f;--Call required! Insert an 'index'!
        \|r[#r+1]=p&&" "..p.." "||"?";;;}--if a was nil or not [.:] return if then else shortcut (if it not enabled -> let lua parce '?' as an error)

--Add initialiser function to F.K feature to enable support of &&= and ||= 
F.K[1]=C=>C.EQ={"&&","||",unpack(C.EQ||{})};

-- X= operators feature
--WARNING! This feature has only partual support of C++ X= operator
--It has default lua priority, not C++:
--Example: 
--C SuS SuS: a*=4+5 --> a=a*4+5
--C++      : a*=4+5 --> a=a*(4+5)
--Current solution: for full priority mimicry -> place sequence into breakets like in examle. 
F.C={C=>
    F.s[1](C)--load start searcher
    
    --EQ - table with operators that support *op*= behaviour
    C.EQ={"+","-","*","%","/","..","^",unpack(C.EQ||{})}
    @l=C.L
    @r=C.R
    --operator main parce function
    --TODO insert end searcher feature for ?= operator support in C SuS SuS future versions...
    @op=C,o,w=>
        o=o:match"(.-)="--for this we need only the first part of operator
        r[#r+1]="="--insert equality
        l[#l].m={bor=#r+1} --Lua5.3 feature support
        for i=l[#l].st,#r-1 do r[#r+1]=r[i]end --copy variable from the start of an object
        @t=#type(C.O[o])
        /|t==6?r[#r+1]=C.O[o]--string
        :|t==3?r[#r+1]=o--operator
        \|C.O[o](C,o,w);--function
        l[#l].m={bor=#r+1};--Lua5.3 feature support
    -- main function initialiser        
    for i=1,#C.EQ do C.O[C.EQ[i].."=" ]=op end;--END OF F.C
}

--IS keyword simular to type of
--WARNING! "is" keyword accepts as second argument only strings or variables in breakets
--EXAMPLE: first_arg is "second_arg", first_arg is {"second_arg","third_arg"}, first_arg is (second_arg)
--This: (first_arg is second_arg) will emit an error!
@tof=o->(getmetatable(o)||{}).__type||type(o);
@is={__concat=v,...=>
    @a={...}
    /|#a<1?$false;
    /|#type(a[1])==5?a=a[1];
    for i=1,#a do
        /|tof(v[1])==a[i]?$true;
              end $false;}
env.typeof=tof--include typeof into CSSC environment
F.IS={C=>
    F.s[1](C)
    @l=C.L
    C.S.W[1]=C,w=>
        w=OBJ(w)
        /|w=='is'?
            table.insert(C.R,l[#l].st,"setmetatable({")
            $"},cssc.is)..";;;}

--Lua5.3 operators feature! Bitwise and idiv operators support!
--WARNING! This feature has no support of `function()end` constructors! (At last for now)
--If you want to a = function()end>>5 then use breakets: like this: a = (function()end)>>5
--Same rule works for lambdas => ->, so BE CAREFULL and DO NOT mix functions and numbers!
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
    --by default compiller not reacts to this operators, required to add for priority support
    --(">= <= ~= =="):gsub("%S+",(x)=>C.O[x]=x;)
    C.O['~=']='~=' --to avoid errors
    --require"cc.pretty".pretty_print(C.EQ)
    C.EQ={">>","<<","&","|",unpack(C.EQ||{})}
    F.s[1](C)
    @l=C.L
    @r=C.R
    l[#l].m={bor=1}
    l.a[1][#l.a[1]+1]=C=>l[#l].m={bor=#r+1};
    --function to correct priority of sequence (set on O and on W)
    @f=C,o=>
        o=OBJ(o)
        @i=#r+2
        @b=Kb[o]||kp[o]
        /|b?l[#l].m={bor=i}; 
        /|b||(" .. + -"):find(' '..o..' ',1,1)?l[#l].m.idiv=i;;--start of sequence and reset!
    C.S.O.pc=C,a,b=>
        /|type(b)==6?f(C,b)--replacement
        \|f(C,a);;--base
    C.S.W.pc=f 
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

--CSSC ENVIRONMENT addition
F.ENV={C=>
    C.F.env=C,x,n,m,e=>
        e=e||{}
        for k,v in pairs(env)do e[k]=v end
        return nil,nil,e--nev env
        ;;}

--DEFAULT: ALL INCLUSIVE (E feature disabled!)
F.A={C=>
 F.M[1](C) -- Lua5.3 opts
 F.K[1](C) -- Keyword shortcuts
 F.IS[1](C)-- IS keyword
 F.N[1](C) -- nil forgiving operators
 F.C[1](C) -- X= operators
 F.b[1](C) -- octal and binary number formats
 C.O['..']=' ..' --fix number concatenation bug
 F.ENV[1](C)-- Custom environment
 for K,V in pairs{F.K,F.F}do
     for k,v in pairs(V)do
         C.O[k]=v
     end
 end
 ;}

_G.cssc={features=F,load=L,nilF=N,mt=M,version="3.4-beta",creator="M.A.G.Gen.",__CSSC=_ENV,is=is,env=env}
]],"SuS",nil,_ENV)--]=]
b=b and error(b)
a=a and a(...)
