# frozen_string_literal: true

def tick(args)
  render args
end

def render(args)
  group = [
    { w:  20, h: 20, r: 255, g: 0, b: 0, a: 255 },
    { w:  20, h:  20, r:    0, g:  255, b:    0, a: 255 },
    { w:  20, h:  20, r:    0, g:  0, b: 255, a: 255 },
    { w:  20, h:  20, r:    127, g: 127, b: 127, a: 255 }
  ]

  (args.layout.rect_group row: 0, col: 0, dcol: 0.5,
                          merge: { vertical_alignment_enum: 0, size_enum: -2 },
                          group: group * 12).into args.outputs.solids

  (args.layout.rect_group row: 1, col: 0, dcol: 0.5,
                          merge: { vertical_alignment_enum: 0, size_enum: -2 },
                          group: group.reverse * 12).into args.outputs.solids

  (args.layout.rect_group row: 2, col: 0, dcol: 0.5,
                          merge: { vertical_alignment_enum: 0, size_enum: -2 },
                          group: group.shuffle(Random.new(1)) * 12).into args.outputs.solids

  (args.layout.rect_group row: 3, col: 0, dcol: 0.5,
                          merge: { vertical_alignment_enum: 0, size_enum: -2 },
                          group: group.shuffle(Random.new(2)) * 12).into args.outputs.solids

end
