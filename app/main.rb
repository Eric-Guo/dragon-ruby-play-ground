def tick a
O||=(C,D=0,1;a.outputs)
C,D=D,C
O[0]if 2>$t+=1
a.sprites<<(O[C].sprites<<[a.solids<<[$grid.rect],D,1,F=300])
O[C].primitives<<[[600+($t*20).sin*90,F+($t*20).cos*90,'. . .',10,0,F,F,F,150].label,[611,331,58,58].solid]
end
