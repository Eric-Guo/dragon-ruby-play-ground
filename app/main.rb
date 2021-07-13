$a = 0
def tick a
(o=a.outputs).background_color=[0]*3
360.times{|h|o.lines<<[640+h.sin*300,380+h.cos*300,640+(m=Math).cos(h*$a+=1e-06)*150,360+m.sin(h*$a)*150,[255]*3]}
end
