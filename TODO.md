### Things to do/implement/fix in the game:

1. ~~Algebraic notation as input from the user~~
2. Reformat/refactor/abstract methods
3. ~~Check dependencies/design~~
4. ~~Proto AI~~
5. ~~Define access modifiers~~
6. ~~Add a..h and 1..8 on x and y axis in board representation~~
7. Simplify pieces class system design
8. Add YAML file with messages
9. Enable castling move:

    - two forms:

        - kingside or short (king to g1 for w., g8 for b.; rook to f1 for w., f8 for b.)

        - queenside or long (king to c1 for w., c8 for b.; rook to d1 for w., d8 for b.)

    - requirements:

        - the king or the rook have been previously moved (add `moved?` method to `Rook`, `King`)

        - not in check

        - no pieces between rook and king

        - the castling won't result in check

  Tasks:

    - ~~add moved? to Rook and King:~~

        ~~if location != start location (relative to color), then moved = true~~

    - filter two types of castling: castle king, castle queen

      (castle rights king? castle rights queen? for white/for white)

    - add castling rights to Board/BoardAnalysis: castling_rights?(color, side) if...

10. Add white/black random selection for the human player
11. ~~Class Player, Human, Computer.~~
12. ~~Add possibility of two algebraic positions (fast move)~~
13. ~~Pawns into queens~~
14. ~~Calculate material evaluation of the board~~
15. ~~make/unmake provisional move~~
16. ~~Display graphics for score~~
17. Replan design
18. ~~Improve evaluation function `board#evaluate`~~
19. Enable en passant move
20. Separated `Display` class/module for `Engine`
21. Module `PieceAnalysis` for `Board`