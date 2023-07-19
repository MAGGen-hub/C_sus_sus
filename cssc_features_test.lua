
clr=colors.orange
f=function()--color mark
tmp=term.getTextColor()
term.setTextColor(clr)
clr=tmp
end
f()
print("Enter test ID")
i=tonumber(read())
t={
--N FEATURE TEST SECTION
{"N feature test N\xB01",[==[<N,dbg(p)>
    --call test
    local a = print
    a?("this will be printed...")
    a=nil
    
    a--[[hello! I am a little trouble maker commentary]]?("This will be skipped...")
    a = print
    --short call
    a?"But this will work again"
    
    --MULTY (short/full/index)call
    local b = nil --can be false
    local p = b?"B equal nil, this will not be printed"?"and this too"?("and this",1)?.ind("and this")?"and this"?[[again]]
    print("p is nil:",p)
]==]},
{"N feature test N\xB02",[==[<N,dbg(p)>
    --indexing test
    print(("This will work: %s")?:format"yes")
    p?.--[[another troublemaker]]pp""
]==]}
}
if not i then
    i=1
    while b==nil and i<#t+1 do
        print(t[i][1])f()
        a,b=cssc.load(t[i][2])
        f()print(a,b)f()
        if a then a()end
        f()
        i=i+1
    end
else
    name,code=unpack(t[i])
    print(name)f()
    a,b = cssc.load(code)
    f()print(a,b)f()    
    if a then a()end
    f()
end
print("--END--")


