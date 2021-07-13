def tick a
O=a.outputs
(O[A=:a];O[B=:b])if 2>$t+=1
A,B=B,A
a.sprites<<(O[A].sprites<<[a.solids<<[0,0,1280,720],B,45,c=255])
O[A].primitives<<[600+$t.sin*25,d=300+$t.cos*25,$t.cos*10,$t.sin*100,r=(Math.atan($t.cos)*d),r+$t.sin*c].solid
end
