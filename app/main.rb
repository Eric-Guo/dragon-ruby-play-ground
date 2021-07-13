def tick a
  B=a.outputs[:r].solids<<[A=0,0,1e2,1e4,F=255,F,F]
  a.solids<<[0,0,2e3,1e3,0,0,0]
  a.sprites<<960.map do
    [638,360,w=($i+=3).sin*F*1.5,h=$i.sin*F,:r,A+=3,5,F*w,-F*(w+h),-F*h]
  end
  $i+=1
end
