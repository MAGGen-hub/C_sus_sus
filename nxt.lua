file=fs.open("data/progs/a_new_cssc/half_final2.lua","r")
str=file.readAll()
file.close()
S=str:
gsub(' end ',"\x81"):
gsub(' function ',"\x82"):
gsub(' local ','\x83'):
gsub(' return ',"\x84"):
gsub('or ','\x85'):
gsub(' if ','\x86'):
gsub('find',"\x87"):
gsub('match',"\x88"):
gsub('type',"\x89"):
gsub(' then ',"\x90"):
gsub(' and ',"\x91"):
gsub('table',"\x92"):
gsub(' else',"\x93"):

gsub('C%.',"\x94"):
gsub('%]=',"\x95"):
gsub(' in pairs','\x96'):
gsub('l%[#l%]','\x97'):
gsub('etmeta',"\x98")

print(#S)