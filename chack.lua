K={}
Ks="if elseif else function for while repeat do then end until local return in break "
Kb={}
Ks:gsub("(%S+)( )", function (x,s)K[#K+1]=s..x..s Kb[x]=#K end )
NL=load
a,b=NL(([=[]=])
:gsub('.',{["\x81"]=K[10],["\x82"]=K[4],["\x83"]=K[12],["\x84"]=K[13],["\x85"]="or ",["\x86"]=K[1],["\x87"]="find",["\x88"]="match",["\x89"]="type",["\x90"]=K[9],["\x91"]=" and ",["\x92"]="table"}),"SuS",nil,_ENV)
b=b and error(b)
a=a and a(...)