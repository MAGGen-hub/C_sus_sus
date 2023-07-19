
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
--N feature test
{"N feature test N\xB01",[==[<N,dbg(p)>
    --call test
    local a = print
    a?("this will be printed...")
    a=nil
    
    a?("This will be skipped...")
    a = print
    --short call
    a?"But this will work again"
    
    --MULTY shortcall
    local b = nil --can be false
    local p = b?"B equal nil, this will not be printed"?"and this too"?("and this",1)?.ind("and this")?"and this"?[[again]]
    print("p is nil:",p)
]==]},
}
name,code = unpack(t[i])

print(name)f()
a,b = cssc.load(code)
f()print(a,b)f()
if a then a()end
f()print("--END--")


