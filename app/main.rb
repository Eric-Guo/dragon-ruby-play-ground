M,F,A=Math,255,0
def tick a
  A += 1.57
  a.outputs[:r].solids<<[0,0,1280,720,F,F,F] if A<2
  a.sprites<<(0..360).map do |i|
    w,h=M.sin(i)*F,M.cos(i)*F
    [638,360,w,h,:r,A,10,F-F*M.atan(w),F*M.atan(w+h),F-F*M.atan(h)]
  end
end
