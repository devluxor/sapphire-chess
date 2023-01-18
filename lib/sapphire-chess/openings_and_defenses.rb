module OpeningsAndDefenses
  OPENINGS = {
    nf3: { probabilty: (1..50), move: [[7, 6], [5, 5]] }, # Most flexible white opening favored by many
    e4: { probabilty:  (51..75),  move: [[6, 4], [4, 4]] }, # The best and most famous white opening.
    d4: { probabilty:  (76..90),  move: [[6, 3], [4, 3]] }, # This can lead to the Queen's Gambit
    c4: { probabilty:  (91..100), move: [[6, 2], [4, 2]] }
  }.freeze

  DEFENSES = {
    [[7, 6], [5, 5]] => [[[1, 2], [3, 2]], [[0, 6], [2, 5]]].sample, # Answers to 1.nf3
    [[6, 4], [4, 4]] => [[[1, 2], [3, 2]], [[1, 4], [3, 4]]].sample, # Answers to 1.e4
    [[6, 3], [4, 3]] => [[[0, 6], [2, 5]], [[1, 2], [2, 2]]].sample, # Answers to 1.d4
    [[6, 2], [4, 2]] => [[[1, 2], [3, 2]], [[1, 4], [3, 4]]].sample # Answers to 1.c4
  }.freeze
end