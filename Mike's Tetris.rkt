;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Mike's Tetris|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Data Definitions

(define WIDTH 200)
(define HEIGHT 400)
(define BLOCK-LENGTH 20)
(define BLOCK-RADIUS 10)
(define BG (empty-scene WIDTH HEIGHT))
(define RANDOM-NUM (random 7))
(define TICK-RATE (/ 1 3))
(define FALL-PACE 20)
(define BLOCK-OUTLINE (square BLOCK-LENGTH 'outline 'black))

;; A Block is a (make-block Number Number Color)
(define-struct block (x y color))

(define BLOCK1 (make-block 50 100 'red))
(define BLOCK2 (make-block 30 100 'blue))
(define BLOCK3 (make-block 70 390 'green))
(define BLOCK4 (make-block 90 390 'yellow))
(define BLOCK5 (make-block 110 390 'green))
(define BLOCK6 (make-block 70 370 'green))
(define BLOCK7 (make-block 190 390 'red))
(define BLOCK8 (make-block 170 390 'red))
(define PILE-FILLER (make-block 290 390 'red))

;; block-temp : Block -> ???
#;(define (block-temp b)
    (...(block-x b)...)
    (...(block-y b)...)
    (...(block-color b)...))

;; A Set of Blocks (BSet) is one of:
;; - empty
;; - (cons Block BSet)
;; Order does not matter.

(define BSET1 (cons BLOCK3 (cons BLOCK4 (cons BLOCK5 empty))))
(define BSET2 empty)
(define BSET3 (cons BLOCK3 empty))
(define BSET4 (cons BLOCK2 empty))
(define BSET5 (cons BLOCK6 empty))
(define BSET6 (cons BLOCK4 empty))
(define BSET7 (list (make-block 170 390 'purple)
                    (make-block 150 390 'purple)
                    (make-block 190 390 'purple)
                    (make-block 190 370 'purple)))
(define BSET8 (cons BLOCK7 empty))
(define BSET9 (cons (make-block 130 390 'red) empty))
(define PILE-FILLER-SET (cons PILE-FILLER empty))

;; bset-temp : BSet -> ???
#;(define (bset-temp abset)
    (cond [(empty? abset) ...]
          [(cons? abset) ...(first abset)
                         ...(bset-temp (rest abset))]))

;; A Tetra is a (make-tetra Posn BSet)
;; The center point is the point around which the tetra rotates
;; when it spins.
(define-struct tetra (center blocks))

(define TETRA1 (make-tetra (make-posn 50 100) (cons BLOCK1 empty)))
(define TETRA2 (make-tetra (make-posn 90 390) BSET1))
(define TETRA3 (make-tetra (make-posn 70 370) BSET5))
(define TETRA4 (make-tetra (make-posn 80 390) BSET3))

(define TETRA-O (make-tetra (make-posn 100 -20)
                            (list (make-block 90 -10 'green)
                                  (make-block 110 -10 'green)
                                  (make-block 90 -30 'green)
                                  (make-block 110 -30 'green))))
(define TETRA-I (make-tetra (make-posn 90 -10)
                            (list (make-block 70 -10 'blue)
                                  (make-block 90 -10 'blue)
                                  (make-block 110 -10 'blue)
                                  (make-block 130 -10 'blue))))
(define TETRA-L (make-tetra (make-posn 90 -10)
                            (list (make-block 90 -10 'purple)
                                  (make-block 70 -10 'purple)
                                  (make-block 110 -10 'purple)
                                  (make-block 110 -30 'purple))))
(define TETRA-J (make-tetra (make-posn 90 -10)
                            (list (make-block 90 -10 'cyan)
                                  (make-block 70 -10 'cyan)
                                  (make-block 110 -10 'cyan)
                                  (make-block 70 -30 'cyan))))
(define TETRA-T (make-tetra (make-posn 90 -10)
                            (list (make-block 90 -10 'orange)
                                  (make-block 70 -10 'orange)
                                  (make-block 110 -10 'orange)
                                  (make-block 90 -30 'orange))))
(define TETRA-Z (make-tetra (make-posn 90 -10)
                            (list (make-block 90 -30 'pink)
                                  (make-block 70 -30 'pink)
                                  (make-block 90 -10 'pink)
                                  (make-block 110 -10 'pink))))
(define TETRA-S (make-tetra (make-posn 90 -10)
                            (list (make-block 90 -10 'red)
                                  (make-block 70 -10 'red)
                                  (make-block 90 -30 'red)
                                  (make-block 110 -30 'red))))
(define TETRA-S-TEST (make-tetra (make-posn 170 350)
                                 (list (make-block 170 350 'red)
                                       (make-block 150 350 'red)
                                       (make-block 170 330 'red)
                                       (make-block 190 330 'red))))

;; tetra-temp : Tetra -> ???
#;(define (tetra-temp t)
    (...(tetra-center t)...)
    (...(tetra-blocks t)...))

;; A World is a (make-world Tetra BSet)
;; The BSet represents the pile of blocks at the bottom of the screen.
(define-struct world (tetra pile))

(define WORLD1 (make-world TETRA1 BSET1))
(define WORLD2 (make-world TETRA3 BSET3))
(define WORLD3 (make-world TETRA4 BSET5))
(define WORLD4 (make-world TETRA-S BSET3))
(define WORLD5 (make-world TETRA3 BSET6))
(define WORLD6 (make-world TETRA-S-TEST BSET7))
(define WORLD7 (make-world TETRA-Z PILE-FILLER-SET))


;; world-temp : World -> ???
#;(define (world-temp w)
    (...(world-tetra w)...)
    (...(world-pile w)...))

;; A SOY (Set of Y) is one of:
;; empty
;; (cons Number SOY)

(define SOY1 (list 4 6 7 8 empty))
(define SOY2 empty)
(define SOY3 (list 390 390 390))
(define SOY4 (list 370 370))
(define SOY5 (list 250 370))

#;(define (soy-temp asoy)
    (cond [(empty? asoy) ...]
          [(cons? asoy) ...(first asoy)
                        ...(soy-temp (rest asoy))]))

;; A SOX (Set of X) is one of:
;; empty
;; (cons Number SOX)

(define SOX1 (list 4 6 7 8 empty))
(define SOX2 empty)
(define SOX3 (list 180))
(define SOX4 (list 180 200))
(define SOX5 (list 250 370))

#;(define (soy-temp asox)
    (cond [(empty? asox) ...]
          [(cons? asox) ...(first asox)
                        ...(sox-temp (rest asox))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TICK

;; World -> World
(define (main w)
  (big-bang w
            [to-draw world-draw]
            [on-tick tetra-tick TICK-RATE]
            [on-key key-handler]
            [stop-when game-over? stop-picture]))

#;(define (main w)
    (big-bang w
              [to-draw world-draw]
              [on-tick tetra-tick TICK-RATE]
              [on-key key-handler]
              [stop-when game-over?]))

;; tetra-tick : World -> World
(define (tetra-tick w)
  (if (landed? w)
      (process-tetra w)
      (fall w)))

;; landed? : World -> Boolean
;; checks if a tetra has landed
(define (landed? w)
  (or (on-ground? (get-y-coords (tetra-blocks (world-tetra w))))
      (touching-xy? (tetra-blocks (world-tetra w))
                    (world-pile w))))

#;(check-expect (landed? WORLD2) true)
(check-expect (landed? WORLD5) false)
#;(check-expect (landed? WORLD6) true)

;; on-ground? : SOY -> Boolean
;; checks if a tetra is now touching the ground
(define (on-ground? asoy)
  (cond [(empty? asoy) false]
        [(cons? asoy) (or (= 390 (first asoy))
                          (on-ground? (rest asoy)))]))

(check-expect (on-ground? (cons 390 empty)) true)
(check-expect (on-ground? SOY3) true)
(check-expect (on-ground? SOY4) false)
(check-expect (on-ground? SOY2) false)

;; touching-xy? : World -> Boolean
;; checks if all of the individual blocks in the tetra have landed
(define (touching-xy? bset1 bset2)
  (cond [(empty? bset1) false]
        [(cons? bset1) (or (colliding-block? (first bset1) bset2)
                           (touching-xy? (rest bset1) bset2))]))

(define (colliding-block? ablock abset)
  (cond [(empty? abset) false]
        [(cons? abset) (or (compare-blocks ablock (first abset))
                           (colliding-block? ablock (rest abset)))]))

(check-expect (colliding-block? (make-block 150 370 'red)
                                (list (make-block 150 390 'purple)
                                      (make-block 170 390 'purple)
                                      (make-block 190 390 'purple)
                                      (make-block 190 370 'purple)))
              true)
(check-expect (colliding-block? (make-block 170 370 'red)
                                (list (make-block 150 390 'purple)
                                      (make-block 170 390 'purple)
                                      (make-block 190 390 'purple)
                                      (make-block 190 370 'purple)))
              true)
(check-expect (colliding-block? (make-block 170 350 'red)
                                (list (make-block 150 390 'purple)
                                      (make-block 170 390 'purple)
                                      (make-block 190 390 'purple)
                                      (make-block 190 370 'purple)))
              false)
(check-expect (colliding-block? (make-block 190 350 'red)
                                (list (make-block 150 390 'purple)
                                      (make-block 170 390 'purple)
                                      (make-block 190 390 'purple)
                                      (make-block 190 370 'purple)))
              true)


(define (compare-blocks block1 block2)
  (and (= (block-x block1) (block-x block2))
       (= (block-y block1) (- (block-y block2) 20))))

(check-expect (compare-blocks (make-block 150 370 'red)
                              (make-block 150 390 'purple)) true)
(check-expect (compare-blocks (make-block 150 370 'red)
                              (make-block 170 390 'purple)) false)
(check-expect (compare-blocks (make-block 150 370 'red)
                              (make-block 190 390 'purple)) false)
(check-expect (compare-blocks (make-block 150 370 'red)
                              (make-block 190 370 'purple)) false)


(check-expect (touching-xy? (list (make-block 150 350 'red)
                                  (make-block 170 350 'red)
                                  (make-block 170 330 'red)
                                  (make-block 190 330 'red))
                            (list (make-block 150 390 'purple)
                                  (make-block 170 390 'purple)
                                  (make-block 190 390 'purple)
                                  (make-block 190 370 'purple)))
              false)

;;WRONG
(check-expect (touching-xy? (list (make-block 150 370 'red)
                                  (make-block 170 370 'red)
                                  (make-block 170 350 'red)
                                  (make-block 190 350 'red))
                            (list (make-block 150 390 'purple)
                                  (make-block 170 390 'purple)
                                  (make-block 190 390 'purple)
                                  (make-block 190 370 'purple)))
              true)


;; get-y-coords : Bset -> SOY
;; makes a list of all the y-coordinates in a Bset
(define (get-y-coords abset)
  (cond [(empty? abset) empty]
        [(cons? abset) (cons (block-y (first abset))
                             (get-y-coords (rest abset)))]))

(check-expect (get-y-coords BSET1) SOY3)
(check-expect (get-y-coords BSET2) empty)
(check-expect (get-y-coords (list (make-block 150 370 'red)
                                  (make-block 170 370 'red)
                                  (make-block 170 350 'red)
                                  (make-block 190 350 'red)))
              (list 370 370 350 350))

;; colliding-soy? : Number SOY -> Boolean
;; checks if the y-coordinate of a block is in touching range of another block
(define (colliding-soy? n asoy)
  (cond [(empty? asoy) false]
        [(cons? asoy) (or (= n (- (first asoy) 20))
                          (colliding-soy? n (rest asoy)))]))

(check-expect (colliding-soy? 10 SOY3) false)
(check-expect (colliding-soy? 370 SOY3) true)
(check-expect (colliding-soy? 370 SOY2) false)

(check-expect (colliding-soy? 350 (list 390 390 390 370)) true)
(check-expect (colliding-soy? 330 (list 390 390 390 370)) false)
(check-expect (colliding-soy? 350 (list 370)) true)

;; colliding-sox? : Number SOX -> Boolean
;; checks if the x-coordinate of a block is in touching range of another block
(define (colliding-sox? n asox)
  (cond [(empty? asox) false]
        [(cons? asox) (or (= n (first asox))
                          (colliding-sox? n (rest asox)))]))

(check-expect (colliding-sox? 180 SOX4) true)
(check-expect (colliding-sox? 180 SOX5) false)
(check-expect (colliding-sox? 150 (list 150 170 190 190)) true)
(check-expect (colliding-sox? 170 (list 150 170 190 190)) true)
(check-expect (colliding-sox? 170 (list 150 170 190 190)) true)
(check-expect (colliding-sox? 190 (list 150 170 190 190)) true)

;; process-tetra : World -> World
;; includes landed tetra into pile and initiates the spawn of a new tetra
(define (process-tetra w)
  (make-world (new-tetra (random 7))
              (append (tetra-blocks (world-tetra w))
                      (world-pile w))))

#;(check-expect (process-tetra WORLD2)
                (make-world (new-tetra RANDOM-NUM)
                            (append (tetra-blocks (world-tetra WORLD2))
                                    (world-pile WORLD2))))

;; new-tetra : Number -> Tetra
;; creates a new tetra piece to start falling at the top of the screen
(define (new-tetra n)
  (cond [(= n 0) TETRA-O]
        [(= n 1) TETRA-I]
        [(= n 2) TETRA-L]
        [(= n 3) TETRA-J]
        [(= n 4) TETRA-T]
        [(= n 5) TETRA-Z]
        [(= n 6) TETRA-S]))

(check-expect (new-tetra 0) TETRA-O)
(check-expect (new-tetra 1) TETRA-I)
(check-expect (new-tetra 2) TETRA-L)
(check-expect (new-tetra 3) TETRA-J)
(check-expect (new-tetra 4) TETRA-T)
(check-expect (new-tetra 5) TETRA-Z)
(check-expect (new-tetra 6) TETRA-S)

(define START-WORLD (make-world (new-tetra (random 7)) PILE-FILLER-SET))

;; fall : World -> World
;; advances the falling tetra farther down the grid
(define (fall w)
  (make-world (make-tetra (move-center (tetra-center (world-tetra w)))
                          (move-blocks (tetra-blocks (world-tetra w))))
              (world-pile w)))

#;(check-expect (fall WORLD4)
                (make-world (make-tetra (make-posn 190 -9)
                                        (cond (make-block 170 -9 'red)
                                              (cond (make-block 150 -9 'red)
                                                    (cond (make-block 170 -29 'red)
                                                          (cond (make-block 190 -29 'red))))))
                            (world-pile WORLD4)))


;; move-center : Posn -> Posn
;; shifts the center position down a set distance
(define (move-center aposn)
  (make-posn (posn-x aposn)
             (+ (posn-y aposn) FALL-PACE)))

(check-expect (move-center (make-posn 30 30)) (make-posn 30 50))

;; move-blocks : Bset -> Bset
;; produces a set of shifted blocks
(define (move-blocks abset)
  (cond [(empty? abset) empty]
        [(cons? abset) (cons (shift-y (first abset))
                             (move-blocks (rest abset)))]))

(check-expect (move-blocks BSET2)
              empty)
(check-expect (move-blocks (list BLOCK3 BLOCK2))
              (cons (make-block 70 410 'green)
                    (cons (make-block 30 120 'blue) empty)))

;; shift-y : Block -> Block
;; shifts the block down a set distance
(define (shift-y ablock)
  (make-block (block-x ablock)
              (+ FALL-PACE (block-y ablock))
              (block-color ablock)))

(check-expect (shift-y BLOCK1)
              (make-block 50 120 'red))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DRAW

;; world-draw : World -> Image
;; draws the world onto the scene
(define (world-draw w)
  (draw-blocks (all-blocks (tetra-blocks (world-tetra w))
                           (world-pile w))))

;; draw-blocks : Bset -> Image
;; draws all of the blocks onto the scene
(define (draw-blocks abset)
  (cond [(empty? abset) BG]
        [(cons? abset) (place-image (draw-a-block (first abset))
                                    (block-x (first abset))
                                    (block-y (first abset))
                                    (draw-blocks (rest abset)))]))

(check-expect (draw-blocks BSET1)
              (place-image (draw-a-block BLOCK3) 70 390
                           (place-image (draw-a-block BLOCK4) 90 390
                                        (place-image (draw-a-block BLOCK5) 110 390
                                                     BG))))

;; all-blocks : Bset Bset -> Bset
;; combines two sets of blocks into one set
(define (all-blocks bset1 bset2)
  (cond [(empty? bset1) bset2]
        [(cons? bset1) (cons (first bset1)
                             (all-blocks (rest bset1) bset2))]))

(check-expect (all-blocks BSET4 BSET1)
              (list BLOCK2 BLOCK3 BLOCK4 BLOCK5))

;; draw-a-block : Block -> Image
;; draws a block as an image
(define (draw-a-block ablock)
  (overlay BLOCK-OUTLINE
           (square BLOCK-LENGTH 'solid
                   (block-color ablock))))

(check-expect (draw-a-block BLOCK3)
              (overlay (square 20 'outline 'black)
                       (square 20 'solid 'green)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; KEY HANDLER

;; key-handler : World Key -> World
;; change position of the tetra with the arrow keys
(define (key-handler w key)
  (cond [(key=? key "left") (process-move-left w)]
        [(key=? key "right") (process-move-right w)]
        [(key=? key "s") (rotate-clockwise w)]
        [(key=? key "a") (rotate-c-clockwise w)]
        [(key=? key "r") WORLD7]
        [else w]))

;; rotate-clockwise : World -> World
(define (rotate-clockwise w)
  (if (cw-collision (tetra-center (world-tetra w)) (tetra-blocks (world-tetra w)) (world-pile w))
      w
      (make-world (make-tetra (tetra-center (world-tetra w))
                              (tetra-clockwise (tetra-center (world-tetra w))
                                               (tetra-blocks (world-tetra w))))
                  (world-pile w))))

;; cw-collision : Posn Bset Bset -> Boolean
(define (cw-collision aposn bset1 bset2)
  (or (cw-wall-collision aposn bset1)
      (cw-block-collision-check aposn bset1 bset2)))

;; cw-block-collision-check : Posn Bset Bset -> Boolean
(define (cw-block-collision-check aposn bset1 bset2)
  (cond [(empty? bset1) false]
        [(cons? bset1) (or (cw-block-collision aposn (first bset1) bset2)
                           (cw-block-collision-check aposn (rest bset1) bset2))]))

;; cw-block-collision : Posn Block Bset -> Boolean
(define (cw-block-collision aposn ablock abset)
  (cond [(empty? abset) false]
        [(cons? abset) (or (and (= (block-x (block-rotate-cw aposn ablock)) (block-x (first abset)))
                                (= (block-y (block-rotate-cw aposn ablock)) (block-y (first abset))))
                           (cw-block-collision aposn ablock (rest abset)))]))

;; cw-wall-collision : Posn Bset -> Boolean
(define (cw-wall-collision aposn abset)
  (cond [(empty? abset) false]
        [(cons? abset) (or (< (block-x (block-rotate-cw aposn (first abset))) 0)
                           (> (block-x (block-rotate-cw aposn (first abset))) 200)
                           (> (block-y (block-rotate-cw aposn (first abset))) 400)
                           (cw-wall-collision aposn (rest abset)))]))

;; tetra-clockwise : Posn Bset -> Bset
(define (tetra-clockwise aposn abset)
  (cond [(empty? abset) empty]
        [(cons? abset) (cons (block-rotate-cw aposn (first abset))
                             (tetra-clockwise aposn (rest abset)))]))

;; block-rotate-cw : Posn Block -> Block
;; rotate the block 90 clockwise around the posn
(define (block-rotate-cw c b)
  (make-block (+ (posn-x c)
                 (- (posn-y c)
                    (block-y b)))
              (+ (posn-y c)
                 (- (block-x b)
                    (posn-x c)))
              (block-color b)))

;; rotate-c-clockwise : World -> World
(define (rotate-c-clockwise w)
  (if (ccw-collision (tetra-center (world-tetra w)) (tetra-blocks (world-tetra w)) (world-pile w))
      w
      (make-world (make-tetra (tetra-center (world-tetra w))
                              (tetra-c-clockwise (tetra-center (world-tetra w))
                                                 (tetra-blocks (world-tetra w))))
                  (world-pile w))))

;; ccw-collision : Posn Bset Bset -> Boolean
(define (ccw-collision aposn bset1 bset2)
  (or (ccw-wall-collision aposn bset1)
      (ccw-block-collision-check aposn bset1 bset2)))

;; ccw-block-collision-check : Posn Bset Bset -> Boolean
(define (ccw-block-collision-check aposn bset1 bset2)
  (cond [(empty? bset1) false]
        [(cons? bset1) (or (ccw-block-collision aposn (first bset1) bset2)
                           (ccw-block-collision-check aposn (rest bset1) bset2))]))

;; ccw-block-collision : Posn Block Bset -> Boolean
(define (ccw-block-collision aposn ablock abset)
  (cond [(empty? abset) false]
        [(cons? abset) (or (and (= (block-x (block-rotate-ccw aposn ablock)) (block-x (first abset)))
                                (= (block-y (block-rotate-ccw aposn ablock)) (block-y (first abset))))
                           (ccw-block-collision aposn ablock (rest abset)))]))

(check-expect (ccw-block-collision (make-posn 10 210)
                                   (make-block 10 250 'red)
                                   BSET2)
              false)
(check-expect (ccw-block-collision (make-posn 10 210)
                                   (make-block 10 230 'red)
                                   BSET2)
              false)
(check-expect (ccw-block-collision (make-posn 10 210)
                                   (make-block 10 210 'red)
                                   BSET2)
              false)

;; ccw-wall-collision : Posn Bset -> Boolean
(define (ccw-wall-collision aposn abset)
  (cond [(empty? abset) false]
        [(cons? abset) (or (< (block-x (block-rotate-ccw aposn (first abset))) 0)
                           (> (block-x (block-rotate-ccw aposn (first abset))) 200)
                           (> (block-y (block-rotate-ccw aposn (first abset))) 400)
                           (ccw-wall-collision aposn (rest abset)))]))

(check-expect (ccw-wall-collision (make-posn 10 210)
                                  (list (make-block 10 190 'red)))
              true)

(check-expect (ccw-wall-collision (make-posn 10 210)
                                  (list (make-block 10 250 'red)
                                        (make-block 10 230 'red)
                                        (make-block 10 210 'red)
                                        (make-block 10 190 'red)))
              true)

;; tetra-c-clockwise : Posn Bset -> Bset
(define (tetra-c-clockwise aposn abset)
  (cond [(empty? abset) empty]
        [(cons? abset) (cons (block-rotate-ccw aposn (first abset))
                             (tetra-c-clockwise aposn (rest abset)))]))

;; block-rotate-ccw : Posn Block -> Block
;; rotate the block 90 counterclockwise around the posn
(define (block-rotate-ccw c b)
  (block-rotate-cw c (block-rotate-cw c (block-rotate-cw c b))))

(check-expect (block-rotate-ccw (make-posn 10 210)
                                (make-block 10 190 'red))
              (make-block -10 210 'red))

;; process-move-left : World -> World
;; decides if tetra will move left or stay
(define (process-move-left w)
  (if (cant-move-left? (tetra-blocks (world-tetra w)) (world-pile w))
      w
      (make-world (move-left (world-tetra w)) (world-pile w))))

;; cant-move-left? : Bset Bset -> Boolean
(define (cant-move-left? bset1 bset2)
  (cond [(empty? bset1) false]
        [(cons? bset1) (or (cant-move-block-left? (first bset1) bset2)
                           (cant-move-left? (rest bset1) bset2))]))

;; cant-move-block-left? : Block Bset -> Boolean
(define (cant-move-block-left? ablock abset)
  (cond [(empty? abset) false]
        [(cons? abset) (or (or (hit-left-boundary (block-x ablock))
                               (and (= (block-y ablock) (block-y (first abset)))
                                    (= (- (block-x ablock) BLOCK-LENGTH) (block-x (first abset)))))
                           (cant-move-block-left? ablock (rest abset)))]))

;; hit-left-boundary : Number -> Boolean
(define (hit-left-boundary n)
  (< (- n BLOCK-LENGTH) 0))

(check-expect (hit-left-boundary 10) true)

;; move-left : Tetra -> Tetra
(define (move-left atetra)
  (make-tetra (make-posn (shift-left (posn-x (tetra-center atetra)))
                         (posn-y (tetra-center atetra)))
              (shift-blocks-left (tetra-blocks atetra))))

;; shift-blocks-left : Bset -> Bset
(define (shift-blocks-left abset)
  (cond [(empty? abset) empty]
        [(cons? abset) (cons (make-block (shift-left (block-x (first abset)))
                                         (block-y (first abset))
                                         (block-color (first abset)))
                             (shift-blocks-left (rest abset)))]))

;; shift-left : Number -> Number
(define (shift-left n)
  (- n BLOCK-LENGTH))

;; process-move-right : World -> World
;; decides if tetra will move right or stay
(define (process-move-right w)
  (if (cant-move-right? (tetra-blocks (world-tetra w)) (world-pile w))
      w
      (make-world (move-right (world-tetra w)) (world-pile w))))

;; cant-move-right? : Bset Bset -> Boolean
;; checks if any blocks in the tetra will make an illegal action if shifted right
(define (cant-move-right? bset1 bset2)
  (cond [(empty? bset1) false]
        [(cons? bset1) (or (cant-move-block-right? (first bset1) bset2)
                           (cant-move-right? (rest bset1) bset2))]))

(check-expect (cant-move-right? BSET3 BSET6) true)
(check-expect (cant-move-right? BSET2 BSET6) false)
(check-expect (cant-move-right? BSET1 BSET9) true)

;; cant-move-block-right? : Block Bset -> Boolean
;; checks if a block will make an illegal action if shifted right
(define (cant-move-block-right? ablock abset)
  (cond [(empty? abset) false]
        [(cons? abset) (or (or (hit-right-boundary (block-x ablock))
                               (and (= (block-y ablock) (block-y (first abset)))
                                    (= (+ (block-x ablock) BLOCK-LENGTH) (block-x (first abset)))))
                           (cant-move-block-right? ablock (rest abset)))]))

(check-expect (cant-move-block-right? BLOCK8 BSET8) true)
(check-expect (cant-move-block-right? BLOCK8 BSET2) false)

;; hit-right-boundary : Number -> Boolean
;; checks if the x-coordinate will lie outside the playing area boundary after shifting
;; the x-coordinate one block length to the right
(define (hit-right-boundary n)
  (> (+ n BLOCK-LENGTH) 200))

(check-expect (hit-right-boundary 190) true)
(check-expect (hit-right-boundary 120) false)

;; move-right : Tetra -> Tetra
;; moves a tetra one block length to the right
(define (move-right atetra)
  (make-tetra (make-posn (shift-right (posn-x (tetra-center atetra)))
                         (posn-y (tetra-center atetra)))
              (shift-blocks-right (tetra-blocks atetra))))

(check-expect (move-right TETRA2)
              (make-tetra (make-posn 110 390)
                          (list (make-block 90 390 'green)
                                (make-block 110 390 'yellow)
                                (make-block 130 390 'green))))


;; shift-blocks-right : Bset -> Bset
;; moves a block one block length to the right
(define (shift-blocks-right abset)
  (cond [(empty? abset) empty]
        [(cons? abset) (cons (make-block (shift-right (block-x (first abset)))
                                         (block-y (first abset))
                                         (block-color (first abset)))
                             (shift-blocks-right (rest abset)))]))

(check-expect (shift-blocks-right BSET2) empty)
(check-expect (shift-blocks-right BSET1)
              (list (make-block 90 390 'green)
                    (make-block 110 390 'yellow)
                    (make-block 130 390 'green)))

;; shift-right : Number -> Number
;; shifts the x-coordinate to the right by one block length
(define (shift-right n)
  (+ n BLOCK-LENGTH))

(check-expect (shift-right 10) 30)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STOP-WHEN

;; game-over? : World -> Boolean
;; checks if the world meets the condition for the game to be over
(define (game-over? w)
  (over-flows? (world-pile w)))

(check-expect (game-over? WORLD7) false)

;; over-flows? : Bset -> Boolean
;; checks if any of the blocks in the pile qualify for the game to be over
(define (over-flows? bset)
  (cond [(empty? bset) false]
        [(cons? bset) (or (less-than-zero? (block-y (first bset)))
                          (over-flows? (rest bset)))]))

(check-expect (over-flows? BSET2) false)
(check-expect (over-flows? BSET6) false)

;; less-than-zero? Number -> Boolean
;; checks if the given y-coordinate is above the boundary of the playing area
(define (less-than-zero? n)
  (< n 0))

(check-expect (less-than-zero? 7) false)
(check-expect (less-than-zero? -2) true)

;; find-score : Bset -> Boolean
;; calculates the end score of the game by finding how many blocks ended up in the pile
(define (find-score abset)
  (cond [(empty? abset) 0]
        [(cons? abset) (+ 1
                          (find-score (rest abset)))]))

(check-expect (find-score BSET2) 0)
(check-expect (find-score BSET6) 1)

;; stop-picture : World -> Image
;; returns a game over picture to display after the player has lost
(define (stop-picture w)
  (place-image (text "GAME OVER" 30 'red)
               100 170
               (place-image (text (string-append "Score: " 
                                                 (number->string (find-score (world-pile w))))
                                  20 'red)
                            100 220
                            BG)))


(check-expect (stop-picture WORLD6) (place-image (text "GAME OVER" 30 'red)
                                                 100 170
                                                 (place-image (text "Score: 4" 20 'red)
                                                              100 220
                                                              BG)))

;; Runs the Tetris game
(main WORLD7)