M,B=Math,0
def tick a
s=a.outputs.solids
s<<[0,0,C=1e4,C]
B+=a.tick_count.cos/1e3
100.step(600,12){|y|100.step(600,12){|x|
e=(M.sin(y*B)+(M.cos(x)))*h=200
f=(M.sin(x*B)+(M.cos(y)))*h
s<<[x,y,8,8,(e+f).abs-10,(g=e-f).abs-50,g.abs-50]}}
end
