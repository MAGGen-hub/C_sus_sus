
base="/data/progs/a_new_cssc/"

cssc_code=fs.open(base.."a_new_cssc_pressed.lua",'r').readAll()
env_pack=fs.open(base.."env_pack.lua",'r').readAll()
setup=fs.open(base.."setup.lua",'r').readAll()

tEnv=setmetatable({shell=shell,require=require},{__index=_G})

final = "local cssc_code=[====["..cssc_code.."]====]\n".."local env_pack_code =[====["..env_pack.."]====]\n"..setup
a,b=load(final,"C_SUS_SUS_Instal",nil,tEnv)
if a then 
    a()
end
file=fs.open(base.."setup_final.lua",'w')
file.write(final)
file.close()

