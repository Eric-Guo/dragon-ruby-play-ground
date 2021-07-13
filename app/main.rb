$t = 0

def tick a
  $t+=1
  srand 1
  16.map do
    x,y=2.map{rand 1e3}
    h=1+rand(75)
    g=(rand+3.6*$t*(0.5-rand)).to_i
    c=[15,105,160].sample
    0.step(800,20){|j|a.outputs.solids<<[j,-j].map{|n|[x+g.cos*n,y+g.sin*n,h,h,c]}}
  end
end
