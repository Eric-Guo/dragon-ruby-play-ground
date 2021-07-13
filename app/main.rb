def tick a
O=a.outputs
(O[A=:a];O[B=:b];O[:p].solids<<[S=[0,0,W=1280,H=720],[F=255]*3])if 3>$t+=2;A,B=B,A;O[A].sprites<<[a.sprites<<[S,B],[S,:p,0,V=40,0,0,0],32.map_with_ys(18){|x,y|[V*x,20*y+V*($t+x*V).sin-V,V,V,:p,$t,F,c=(V*x+$t).clamp_wrap(0,F),2*c,3*c]}]
end
