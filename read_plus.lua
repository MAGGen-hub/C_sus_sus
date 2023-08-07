if not native_read then
    _G.native_read=read
    local tEnv=setmetatable({colors={gray=colors.gray,white=colors.white}},{__index=_G})
    setfenv(read,tEnv)
    
    _G.read=function(_sReplaceChar,_tHistory,_fnComplete,_sDefault,_nTextColor,_nBackColor)
        tEnv.colors.gray=_nBackColor or colors.gray
        tEnv.colors.white=_nTextColor or colors.white
        return native_read(_sReplaceChar,_tHistory,_fnComplete,_sDefault)
    end
end


