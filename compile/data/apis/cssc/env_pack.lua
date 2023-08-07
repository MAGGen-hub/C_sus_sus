a,b=cssc.load([[<A,E,dbg(p)>
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
