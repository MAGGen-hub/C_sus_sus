a,b=cssc.load([[<A,E,dbg(p)>
--Env setupper
nE=->setmetatable({},{__index=_G});
@G={}
--GLOBAL: better strings
G.strings==>
    @sm=getmetatable("") --get strings metatable
    sm.__autocomplete=sm.__index
    sm.__index=s,i=>$sm.__autocomplete[i]||type(i)=="number"&&s:sub(i,i)||nil;
    sm.__mod=s,f=> --self,format
        /|type(f)==table?$s:format(unpack(f));
        $:format(f);;
            
    

--GLOBAL: __auto methamethod support
G.__autocomplete==>
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
    
cssc.global=G

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

--custom read
do
 @c={gray=colors.gray,white=colors.white}
 @br=load(("").dump(read),'cssc_read',nil,setmetatable({colors=c},{}))
 debug.setupvalue(br,require'cc.expect'.expect)
 env.read=_sReplaceChar,_tHistory,_fnComplete,_sDefault,_nTextColor,_nBackColor=>
     c.gray=_nBackColor||colors.gray
     c.white=_nTextColor||colors.white
     $br(_sReplaceChar,_tHistory,_fnComplete,_sDefault); --colorised read autocompletion
end

--string pairs support

--fields support

--table copy clone size is_empty has_key, has_value

cssc.env_version="1.2"
]],"CSSC_ENV",nil,cssc.__CSSC)
b=b and error(b)
a=a and a(...)
