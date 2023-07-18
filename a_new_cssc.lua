-- C SuS SuS Programming language compiler 3.0

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
K={"if","then","elseif","else","local","return","or","and","not","end","function","for","while","in","do","repeat","until","break","nil","true","false"}
--initialize lambda function feature
l=function(C,o) --DO NOT PLACE LAMBDA AT THE START OF FILE!!! You will got ")" instead of "function(*args*)"
    i=#C.R
    a=1
    e=C.R[i]
    p=e:find"^%)%s*"and""or"("
    while i>0 and(#p>0 and(a and(e:match"[%w_]+"or"..."==e)or","==e)or#p<1 and not e:find"^%(%s*")do --comma or word or ( if ) located
        i,a=i-1,not a
        e=C.R[i] end
    table.insert(C.R,#p<1 and i or i+1,K[11]..p)-- K[11] - function keyword K[6] - return
    C.R[#C.R+1]=(#p>0 and")"or"")..(o:sub(1,1)=="-"and K[6].." "or"") --WARNING!!! Thanks for your attention! =)
end

--FEATURES TABLE
F={
--initialise main features::

--if else then shortcut section
E={ ["/|"]=K[1],--[[if]] ["?"]=K[2],--then
    [":|"]=K[3],--elseif
    ["|"]="   ",--empty symbol to make code a little bit F# looking (only to make it look more understandable in unminified version (removed in release!))
    ["\\|"]=K[4]},--else

-- keywords section
K={ ["@"]=K[5],--local
    ["$"]=K[6],--return
    ["||"]="or",
    ["&&"]=K[8],--and
    ["!"]=K[9],--not
    [";"]=function(C,o) -- any ";" that stand near ";,)]" or "\n" will be replaced by " end " for ex ";;" equal to " end  end "
              e,a,p=" end ",o:match"(;*) *([\n%S]?)"
              C.R[#C.R+1]=(#p>0 or#a>1)and e:rep(#a)or";"
              return o:sub(#a+1)
          end},

--lambda section
F={ ["..."]="...", -- You may ask why this token is here, but if you remove it and use ... in lambda you code will crush. So don't remove it please...
    ["->"]=l,
    ["=>"]=l},
    
--debug (will be moved to C SuS SuS loaded part soon)
dbg={function(C,V)
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
local NL,a,b=load --native CraftOS load function
L=function(x,name,mode,env)
    if type(x)=="string" then -- x might be a function or a string
        local c=x:match"^<.->"or x:match"^#!.-\n?<.->" -- locate control string
        if c then --control string exists!
        
            --INITIALISE LOCALS
            local R,S,O,po,C,s,t,a,b,l={""},{},{},""
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
            for K,V in c:gmatch"([%w_]+)%(?([%w_. ]*)"do--load flags that used in control string: K - feature name V - feature argument
                if F[K]then -- feature exist
                    for k,v in pairs(F[K])do O[k]=v end
                    S[K]=F[K][1] and F[K][1](C,V,x,name,mode,env)-- [1] index is used to store special compiller directives
                end                                              -- if special has argumet V ex: "<pre(V)>" then F["pre"][1](ctrl_table,"V")
            end
            O[1]=nil -- remove trash from current_operators table (all specials in S table now)
            
            --PRELOAD CHECK
            if S.pre then return S.pre end
            
            --COMPILE -- o: operator, w: word
            cnt=1
            l=#x+1
            for o,w,i in x:gmatch"([%s!#-&(-/:-@\\-^{-~`]*%[?=*[%['\"]?%s*)([%w_]*[^%w%p%s]*[^\n%S]*)()"do
                                        -- see that pattern? Now try to spell it in one breath! =P
                                        -- in this pattern the word (w) will never be "^%s*$"!
                
                cnt=cnt+1 -- this cycle counter used to debug and optimise C SuS SuS parcer
                --LINE COUNTER
                o:gsub("\n",function()C.l=C.l+1 end)
                --STRING MODE: string or comment located and must be captured
                if s then
                    a,b=o:find(#s<2 and "\\*[\n"..s.."]"or "%]=*%]") --locate posible end of string (depends on string type)
                    if a and(#s<2 and(s=="\n"or b-a%2<1)or #s==b-a+1)or i==l then -- end of something found, check is it our string end or not
                        b=b or i
                        t=t..o:sub(0,b) --finish string
                        C.pv=c and C.pv or#R+1
                        c=c and C.c or R --choose table to insert
                        c[#c+1]=t -- insert object
                        o=po..o:sub(b+1) --form new operators sequence
                        --if s=="'" then print(t)end
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
                        --SPECIAL FUNCTIONS (they usualy work with "R" table and not changing words or operators (if it not new keyword or number format))
                        for k,v in pairs(S) do a,b=v(C,o,w,i) o,w=a or o,b or w end --call all funcs and save new o,w if they exist as return result
                        --OPERATOR PARCE
                        while #o>0 do
                            a=o:match"^%s*" --this code was made to decrase the length of result table and allow spacing in operators capture section
                            R[#R]=R[#R]..a
                            o=o:sub(#a+1)
                            for i=3,1,-1 do --WARNING! Max operator length: 3    
                                a=O[o:match((".?"):rep(i))] -- a variable here used to store enabled_operators[posible operator]
                                if a then --if O[posible_operator] -> C SuS SuS enabled operator (or something else) found and must be parced
                                    if 7>#type(a)then --type<7 -> string; >7 - function | these can't be any othere values
                                        R[#R+1]=" "..a.." "
                                        o=o:sub(i+1)
                                    else
                                        a,b=a(C,o,w,i) --if there is a special replacement function
                                        o,w=a or o:sub(i+1),b or w
                                    end
                                    --C.pv=#R
                                    break -- operator found! break out...
                                elseif i<2 then --operator was not found
                                    a=o:sub(1,1)
                                    --C.pv=a=="\0"and C.pv or #R+1
                                    R[#R+1]=#o>0 and(a=="\0"and (table.remove(C.c,1)or"")or a~='"'and a)or nil -- \0 - comment operator " -- string mark (always at end of seq)
                                    o=o:sub(2)
                                end
                            end
                            C.pv=a=="\0"and C.pv or #R
                        end
                        --WORD
                        R[#R+1]=#w>0 and w or nil --save word and undefined values. Oh wait... I removed *undefined* variable long time ago...
                        C.pv=#w>0 and#R or C.pv
                    end
                end 
            end
            
            --FINISH COMPILE
            a,b=nil
            for k,v in pairs(C.F) do a,b=v(C,x,name,mode,env) end --launch all finalizer function
            if a or b then return a,b end -- if finaliser return something then return it vithout calling native load
            --print("cnt",cnt)
            x=table.concat(R)
            if mode=="c"then return R end
        end
    end
    return NL(x,name,mode,env)
end
--load other features of compiler using compiler it self (can be used as example of C SuS SuS programming)
a,b=L([[<E,K,F,dbg>

--local keyword access table
@Kt={}
for i=1,21 do Kt[K[i] ]=1 end

--Error detector
err=C,s=>C.err=C.err or "SuS["..C.l.."]:"..s;

F.err={C=>
    C.F.err=C=>
        /|C.err?$ nil,C.err;;;}

--Debug feature
F.dbg={C,V=> -- V - argument
    @v=V
    C.F.dbg=C,x,n,m=>
        /|v=="P"?require"cc.pretty".pretty_print(C.R)
        \|print(table.concat(C.R));
        /|m=="c"?$R
        :|m=="s"?table.concat(R);;;}
    
--0b0000000 and 0o0000.000 number format support (avaliable exponenta: E+-x)
F.b={C->--return function that will be inserted in special extensions table
    C,o,w=>
        @a,b,c,r,t=w:match"^0([bo])(%d*)([eE]?.*)" --RUSH EEEEEEEEEEEEE for exponenta
        /|C.b&&o=="."?t,b,c=C.b,w:match"(%d+)([eE]?.*)"--b located! posible floating point!
        \|C.b=nil;
        -- 8 line
        /|b?--number exist
          t,r=t||(a>"b"&&"8"||"2"),0 --You are a good person if you read this (^_^)
          for i,k in b:gmatch"()(.)"do
             /|k>=t?err(C,"This is not a valid number: 0"..a..b..c);--if number is weird
             r=r+k*t^(#b-i)-- t: number base system, r - result, i - current position in number string
                                   end
          r=C.b&&tostring(r/t^#b):sub(3)||r --this is a floating point! recalculate required!
          C.b=!C.b&&#c<1&&t||nil--floating point support
          $nil,r..c;;;}-- 17 line

-- leveling function initialiser (breakets counter)
F.l={C=> /|C.O["("]?$; --if C.O["("] exist - leveling system already initialized, skip proccess (line 22)
    C.L={{}}
    @p="([{}])"
    for k in p:gfind"(.)"do
        C.O[k]=C,o=>
            o=o:sub(1,1)
            C.R[#C.R+1]=o
            o=p:find("%"..o)<4
            C.L[#C.L+(o&&1||0)]=o&&{}||nil;
                        end;}
                                        -- This code is hard to understand because
                                        -- it was sponsored by Peppino Spagetti from Pizza Tower PC game

--start searcher initialiser
F.s={C=>
    --init leveling function
    F.l[1](C)
    /|C.L[1].st?$; -- Searcher was inited before! Skip!
    @f=C.O["("]
    for i in("([{"):gmatch"."do
    C.O[i]=C,o=>
        @r=C.R[#C.R]
        /|Kt[r:match"%w*"]||!r:find"[%w_]"?C.L[#C.L].st=#C.R+1; --object might start with "(":  ("a"):blabla("")
        f(C,o)--call level
        C.L[#C.L].st=#C.R+1;
                            end
        
    C.L[1].st=1--first start of object is start of file (it must be set to avoid errors)
    C.S.s=C,o,w=> -- Cow says "MOOO"; F.s says "start of object is here *table index*"
        --forward operator parcing 
            --what is the start of the object?
            -- object in Lua can start with () or word:  ("bruh"):sub(1,1) or string.sub("bruh",1,1) --numbers here are not important but thay also objects
            -- if operator before word is . or : then it is not the start
            -- if . or : are before ("bruh") thats an error and must be catched by lua 
            -- need last value variable to not search for it if o or w will contain "   "
            -- we not paing attention to incode strings because they can't be an object and anything that go straight after string must be the start of obj
        
        --step 0: check if start object exist but not set
        @l=C.L[#C.L]
        /|l.pr?l.st,l.pr=#C.R;--set previous word as start
        --step 1: word exist?
        /|#w<1?$; --return if not
        --step 2: operator exist?
        /|o:find"^%s*$"?o=C.R[#C.R]or""; --if o is empty R[#R] (thanks to space concatting code) will never equal "^%s*$"
        --step 3: word or operator (if a word then index of w is the start of the object)
        /|o:find"^[%w_]"?l.st=#C.R+1 $; -- if o is word then actual operator is empty and obj start was at the index of "w" variable #C.R+1
        @a=o:match"(%.?[.:])%s*$"--if this part reached o is an operator and must be anything but not "." or ":"
        --keyword ckeck
        /|a&&#a<2?$;--word has a "." or ":" before it
        --finaly start object is located and can be setted on next cycle (operator string might be not empty end ruin the code if l.st=#C.R set before parce)
        l.pr=1;;} --;; -> ends to both lambdas

-- nil forgiving function initialiser
do
@c,d=setmetatable--nil returning object | nilF feature: nil forgiving operators | d -> default c-> colon
d=c({},{__call=->nil;,__index=->nil;})
c=c({},{__index=->()->nil;;})

N=(o,i)=>-- o -> object, i -> index
    /|o==nil?$i&&c||d; --> obj not exist (false and other variables are allowed
    /|i?$o[i]&&o||c; --> obj and index exist -> colon mode
    $o; -- obj exist but not index
end
-- not null check feature! Must be loaded after E for E support
F.N={C=>
    F.s[1](C)--load start searcher!
    @p=C.O["?"]--if E feature was enabled
    @e="Attempt to perform '"
    C.O["?"]=C,o,w=>
        @a,r=o:match".(.)",C.R
        @b=a && a:match'[.:%[%({"]'
        /|!r[C.pv]:find"[%w_%]%)}\"']%s*$"?err(C,e.."?"..a.."' on '"..(r[C.pv]or"nil").."'");--if previous value was an operator
        /|b?
            /|a:find"[.:]"&&!o:sub(3):find"^[\0%s]*$"?err(C,e..o:sub(3).."' on '?"..a.."'");--error if ?[.:] has operators but not word after it 
            table.insert(r,C.L[#C.L].st," cssc.nilF(") --Insert a breaket at the start of object!
            r[#r+1]=b==":"&&",'"..w.."')"||")"--Call required! Insert an 'index'!
            /|b=="."?
                C.pc=#r -- Index detected, and call check required!
                C.S.pc=C,o=>
                    /|o:gsub("\0",""):find"^%("&&C.pc?table.insert(C.R,C.pc,",'"..C.R[#C.R].."'"); --Call required! Insert an 'index'!
                    C.pc=nil C.S.pc=nil;;
        \|r[#r+1]=p&&p||"?";;;}--if a was nil or not [.:] return if then else shortcut (if it not enabled -> let lua parce '?' as an error)
    
--This table contain all operators with *operator*= support "+= -= *= ..."
Ck={"+","-","*","%","/","..","&&","||","//","&","|",">>","<<"}

-- Ariphmetic end searcher needed
-- C++ feature
F.C={C=>
    F.s[1](C)--load start searcher
    C.EQ={"+","-","*","%","/","..",unpack(C.EQ||{})}--unpack here for functions that added something into C.EQ before
    --function to end to "ariphmetical" expression with breaket
    @es=C,o,w=>
        @k={["and"]=1,["or"]=1}
        @r=C.R
        /|(o:find"[%)%]}][%s\0]*"||o:find"^[%s\0]*$"&&
          (r[C.pv]:find"^['\"%[].*[%]'\"]%s*$"||!Kt[r[C.pv]:match"%S"]))
          &&#w>0&&!k[w:match"%S"]? -- if operator was a breaket or previous value was a word (not keyword) or string and current word is not "and" or "or"
            o=o..")"C.S.aes=nil;; --insert a breaket and remove function from special compiller directives  
    
    @f=C,o,w=>
        o=o:match"(.-)=" --for this we need only the first part of operator
        @t=type(C.O[o])
        @r=C.R
        /|t>3? --Type is not nil! Parce required! C SuS SuS operator!
            /|t<7?t=" "..C.O[o].." " --string
            \|t=C.O[o](C,o,w,-1); --function direct call (if i < 0)
            o=t;
        r[#r+1]="="--insert equality 
        for i=C.L[#C.L].st,#r-1 do --copy variable from the start of an object
        ;
            
    for i=1,#k do C.O[Ck[i] ]=f end --initialise all
    ;
}

F.B={

}
]],"SuS",nil,_ENV)--]=]
b=b and error(b)
a=a and a(...)

_G.cssc={features=F,lua_keywords=K,load=L,nilF=N,op_equal=Ck,version="3.4-beta"}
