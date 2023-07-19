if cssc then
clr=colors.orange
f=function()
tmp=term.getTextColor()
term.setTextColor(clr)
clr=tmp
end
--N feature test
f()
print("bruh")
f()
print("eh")
cssc.load([==[<N,dbg(p)>]==])

end
