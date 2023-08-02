--Compressor to remove all spaces and comments

--Open cssc
file=fs.open("data/progs/a_new_cssc/a_new_cssc.lua","r")
cssc_base=file.readAll()
file.close()

--Press
cssc_final=cssc_base:
    gsub(",dbg>",">"):--disable base-debug
    gsub(",dbg=%b{}",""):--delete base-debug from final version
    gsub("-%-[^%[].-\n","\n"):--remove comments
    gsub("%s+",
        function(str)
            return str:find"\n" and "\n" or " "
        end)--remove useless gapes

--Create _ENV
tEnv=setmetatable({},{__index=_G})

--Check
func,err=load(cssc_final,"CSSC_FINAL",nil,tEnv)
print(("Status:\n    Base size:%9d b\n    Pressed:%11d b\n    Cost: %13.3f %% of 1Mb\n\nCompile:\n    Function: %s\n    Error:%26s\n"):
        format(#cssc_base,#cssc_final,#cssc_final/10485.67,func,err or "--//--"))
if func then 
    result = func() 
    print("Run successful")
end

--Save pressed
file=fs.open("data/progs/a_new_cssc/a_new_cssc_pressed.lua","w")
file.write(cssc_final)
file.close()
print("Save successful")

