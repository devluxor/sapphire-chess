| Things to do/implement/fix in the game | Bugs found |
| ---------------------------------------|--------------------------------- |
| 1. ~~Algebraic notation as input from the user~~ | 1. ~~Game is not over when black king is killed~~
| 2. ~~Reformat/refactor/abstract methods~~ | ~~2. Engine#game_over? not working~~
| 3. ~~Check dependencies/design~~ | 3. Bug encountered only once: Board#move_piece! tries to move a NullPiece? (NoMethodError `location=` on NullPiece, line: `self[target_square].location = target_square)`
| 4. ~~Proto AI~~ | 4.
| 5. ~~Define access modifiers~~ | 5.
| 6. ~~Add a..h and 1..8 on x and y axis in board representation~~ |
| 7. ~~Simplify pieces class system design~~ |
| 8. Add YAML file with messages ?? |
| 9. ~~Enable castling move~~ |
| 10. Add white/black random selection for the human player |
| 11. ~~Class Player, Human, Computer.~~ |
| 12. ~~Add possibility of two algebraic positions (fast move)~~ |
| 13. ~~Pawns into queens~~ |
| 14. ~~Calculate material evaluation of the board~~ |
| 15. ~~make/unmake provisional move~~ |
| 16. ~~Display graphics for score~~ |
| 17. Replan design |
| 18. ~~Improve evaluation function `board#evaluate`~~ |
| 19. Enable en passant move |
| 20. ~~Separated `Display` class/module for `Engine`~~ |
| 21. ~~Module `PieceAnalysis` for `Board`~~ |
| 22. ~~Add difficulty setting~~ |
| 23. ~~Rename modules/classes (more expressive)~~ |
| 24. Fine tuning of game over system |
| 25. ~~Add turn number~~ |
| 26. Study alpha-beta pruning |
| 27. Minimax to Negamax ??? |
| 28. Write a detailed MAP.md |
| 29. Add a 'want to play again?' method |
| 30. Implement speed optimization for AI#minimax |
| 31. Research TCO (_Tail Call Optimization_) |
| 32. Enable AI vs. AI mode |
| 33. Add player + computer last move |
| 34. Learn code packaging |
| 35. Add history of moves |
