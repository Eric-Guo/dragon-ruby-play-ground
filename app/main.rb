def tick a
  o=a.outputs
  o.background_color=[H=720,W=1280,F=255]
  A||=o[:r].solids<<[G=0,0,W,H,F,F,F]
  G+=1
  0.step(W,B=40) do |i|
    0.step(H,B) do |j|
      a.sprites<<[i,j,B,B,:r,(i+j).sin*G*2,F,(i-G).sin*j,(i+G).cos*(j/3),j/3]
    end
  end
end
