
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

--backup
savePal()
last_bg=term.getBackgroundColor()

--animate bg
term.setPaletteColor(colors.lightGray,term.getPaletteColor(last_bg))
term.setBackgroundColor(colors.lightGray)
paintutils.drawFilledBox(1,1,maxX,maxY)

animate_color(colors.lightGray,colors.lightBlue,0.05,50)

term.setBackgroundColor(colors.lightBlue)
paintutils.drawFilledBox(1,1,maxX,maxY)
loadPal()

--print welcome
term.setCursorPos((maxX-#wlc)/2,maxY/2-4)
term.setTextColor(colors.orange)
rainbowPrintEffect(wlc,0.35)
sleep(0.3)

--print to
term.setCursorPos((maxX-3)/2,maxY/2-2)
term.setTextColor(colors.green)
textutils.slowWrite("t o",4)

--images
s_up= {t="\x98\x8C\x9B ",f="6636",b="3363"}
s_mid={t="\x89\x8C\x9B ",f="6636",b="3363"}
s_dwn={t="\x89\x8C\x86 ",f="6666",b="3333"}
u_up= {t="\x95 \x95 ",  f="6636",b="3363"}


term.setTextColor(colors.lightGray)
term.setCursorPos((maxX-10)/2,maxY/2)
term.blit("\x98\x8C\x9B  "..s_up .t..u_up.t,"88388"..s_up.f..u_up.f,"33833"..s_up.b..u_up.b)
term.setCursorPos((maxX-10)/2,maxY/2+1)
term.blit("\x95    "      ..s_mid.t..u_up.t,"88888"..s_mid.f..u_up.f,"33333"..s_mid.b..u_up.b)
term.setCursorPos((maxX-10)/2,maxY/2+2)
term.blit("\x89\x8C\x86  "..s_dwn.t:rep(3),"88888"..s_dwn.f:rep(3),"33333"..s_dwn.b:rep(3))







