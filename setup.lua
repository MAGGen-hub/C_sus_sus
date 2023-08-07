
cssc_code=cssc_code or ""
env_pack_code = env_pack_code or ""
startup_code=[[
local S,s,c,g,e,C,b=settings,shell,"cssc.","global_load","enable"," C SuS SuS ","boolean"
S.define(c..g,{description="Replaces `_G.load` with `cssc.load` for global"..C.."support.",default=false,type=b})
S.define(c..e,{description="Enables"..C,default=true,type=b})
S.load()
if S.get(c..e)then
s.run("%s")
s.run("%s")
if S.get(c..g)then
_G.load=cssc.load
end
end
]]

--parts
local intro=true
local about=true

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

--skip or not intro
parallel.waitForAny(
    function() 
        repeat 
        local ev,key=os.pullEvent"key" 
        if key==keys.space or key==keys.enter then
            break
        end
        until false
        loadPal()
    end,
function()
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
term.setCursorPos((maxX-28.5)/2,maxY/2)
term.blit("\x98\x8C\x9B  "..(s_up .t..u_up.t..s_up.t.." "):rep(2),"bb3bb"..(s_up.f..u_up.f..s_up.f.."8"):rep(2),"33b33"..(s_up.b..u_up.b..s_up.b.."3"):rep(2))
term.setCursorPos((maxX-28.5)/2,maxY/2+1)
term.blit("\x95    "      ..(s_mid.t..u_mid.t..s_mid.t.." "):rep(2),"bbbbb"..(s_mid.f..u_mid.f..s_mid.f.."6"):rep(2),"33333"..(s_mid.b..u_mid.b..s_mid.b.."3"):rep(2))
term.setCursorPos((maxX-28.5)/2,maxY/2+2)
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
end)

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
        --paintutils.drawFilledBox(1,1,maxX,maxY,colors.black)
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
if continue() then 
print("Canceled by user. Press any key to exit...")
os.pullEvent("key")
return 
end
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
cssc_path=readPath(4,7,"3. Cssc main module:",api_folder.."/cssc.lua")
env_package_path=readPath(4,8,"2. _ENV-pack:",api_folder.."/env_pack.lua")

startup_path=readPath(4,9,"3. Startup:","startup/00_cssc.lua")

cssc_set=cssc_path:match"%S"
envP_set=env_package_path:match"%S"
startup_set=startup_path:match"%S"

--Generate startup
if startup_set then
    startup_code=startup_code:format(cssc_path,env_package_path)
end

--Total
print(                   "   4. Selected modules:"..
      (cssc_set    and("\n      - C SuS SuS Compiller:%8.2f Kbs"):format(#cssc_code/1024.0)or"")     ..
      (envP_set    and("\n      - _ENV-pack:          %8.2f Kbs"):format(#env_pack_code/1024.0)or"")..
      (startup_set and("\n      - Startup module:     %8.2f Kbs"):format(#startup_code/1024.0)or"")..
                    ("\n\n      = Total size:         %8.2f Kbs"):format(((cssc_set and#cssc_code or 0)+
                                                                      (envP_set and#env_pack_code or 0)+
                                                                      (startup_set and#startup_code or 0))/1024))
local x,y = term.getCursorPos()
print("\n      Continue instalation? [Y/N]")
if continue() then 
print("      Canceled by user. Press any key to exit...")
os.pullEvent("key")
return end
paintutils.drawLine(x,y+1,40,y+1)
term.setCursorPos(x,y)
write("\n      Installing. Please wait")


--INTERFACE PART END

--MAIN PART
base="/data/progs/a_new_cssc/compile/"

for k,v in pairs{[cssc_path]=cssc_code,[env_package_path]=env_pack_code,[startup_path]=startup_code}do
    if k:match"%S" then
        local file=fs.open(base..k,'w')
        --if not file then print(k) return end
        file.write(v)
        file.close()
        sleep(0.3) 
        write('.')
    end
end
sleep(0.3)
paintutils.drawLine(x,y+1,40,y+1)
term.setCursorPos(x,y)
print("\n      Unpacking complete. Reboot your PC to apply changes.")
print("\n      Reboot now? [Y/N]")
local reboot= not continue()
print("\n      Instalation complete. Press any key to exit...")
os.pullEvent("key")
if reboot then os.reboot()end


