def tick a
A||=(O=a.outputs)[:p].solids<<[0,0,1e4,720,[255]*3]
o=[]
O.background_color=[0]*3
g=a.tick_count.sin*2
160.step(600,10){|y|440.step(880,10){|x|b=(y*g).to_i.sin*20
c=(x*g).to_i.cos*20
o<<[x+b,y+c,9,9,:p]}}
O.sprites<<o
end
