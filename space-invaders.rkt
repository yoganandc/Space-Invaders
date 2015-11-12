;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname space-invaders) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;;;; Data Definitions

(define WIDTH 500) 
(define HEIGHT 500)
(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define MAX-SHIP-BULLETS 3)
(define MAX-INVADER-BULLETS 10)

(define SHIP-WIDTH 25)
(define SHIP-HEIGHT 15)
(define SPACESHIP-IMAGE (rectangle SHIP-WIDTH SHIP-HEIGHT 'solid 'black))

(define INVADER-SIDE 20)
(define INVADER-IMAGE (square INVADER-SIDE 'solid 'red))

(define BULLET-RADIUS 2)
(define SPACESHIP-BULLET-IMAGE (circle BULLET-RADIUS 'solid 'black))
(define INVADER-BULLET-IMAGE (circle BULLET-RADIUS 'solid 'red))

(define SHIP-SPEED 10)
(define BULLET-SPEED 10)

(define MAX-X 420)
(define MIN-X 100)

;; An Invader is a Posn 
;; INTERP: represents the location of the invader

;;;; Template: invader-fn : Invader -> ???
#; (define (invader-fn an-invader)
     ... (posn-x an-invader) ...
     ... (posn-y an-invader) ...)

;; A Bullet is a Posn 
;; INTERP: represents the location of a bullet

;;;; Template: bullet-fn : Bullet -> ???
#; (define (bullet-fn a-bullet)
     ... (posn-x a-bullet) ...
     ... (posn-y a-bullet) ...)

;; A Location is a Posn 
;; INTERP: represents a location of a spaceship

;;;; Template: location-fn : Location -> ???
#; (define (location-fn a-location)
     ... (posn-x a-location) ...
     ... (posn-y a-location) ...)

;; A Direction is one of: 
;; - 'left 
;; - 'right 
;; INTERP: represent the direction of movement for the spaceship

;;;; Template: direction-fn : Direction -> ???
#; (define (direction-fn dir)
     (cond
       [(symbol=? 'left dir) ...]
       [(symbol=? 'right dir) ...]))

(define-struct ship (dir loc))
;; A Ship is (make-ship Direction Location) 
;; INTERP: represent the spaceship with its current direction 
;;         and movement

;;;; Template: ship-fn : Ship -> ???
#; (define (ship-fn a-ship)
     ... (direction-fn (ship-dir a-ship)) ...
     ... (location-fn (ship-loc a-ship)) ...)

(define SHIP-INIT (make-ship 'left (make-posn 250 480)))
(define SHIP-1 (make-ship 'right (make-posn 440 240)))
(define SHIP-2 (make-ship 'left (make-posn 80 220)))

;; A List of Invaders (LoI) is one of 
;; - empty 
;; - (cons Invader LoI)

;;;; Template: loi-fn : LoI -> ???
#; (define (loi-fn loi)
     (cond
       [(empty? loi) ...]
       [(cons? loi) ... (invader-fn (first loi)) ...
                    ... (loi-fn (rest loi)) ...]))

(define INVADERS-INIT 
   (list (make-posn MIN-X 20) (make-posn 140 20) (make-posn 180 20) 
         (make-posn 220 20) (make-posn 260 20) (make-posn 300 20) 
         (make-posn 340 20) (make-posn 380 20) (make-posn 420 20)
         (make-posn 100 50) (make-posn 140 50) (make-posn 180 50) 
         (make-posn 220 50) (make-posn 260 50) (make-posn 300 50) 
         (make-posn 340 50) (make-posn 380 50) (make-posn 420 50)
         (make-posn 100 80) (make-posn 140 80) (make-posn 180 80) 
         (make-posn 220 80) (make-posn 260 80) (make-posn 300 80) 
         (make-posn 340 80) (make-posn 380 80) (make-posn 420 80)
         (make-posn 100 110) (make-posn 140 110) (make-posn 180 110) 
         (make-posn 220 110) (make-posn 260 110) (make-posn 300 110) 
         (make-posn 340 110) (make-posn 380 110) (make-posn MAX-X 110)))

;; A List of Bullets (LoB) is one of 
;; - empty
;; - (cons Bullet LoB)

;;;; Template: lob-fn : LoB -> ???
#; (define (lob-fn lob)
     (cond
       [(empty? lob) ...]
       [(cons? lob) ... (bullet-fn (first lob)) ...
                    ... (lob-fn (rest lob)) ...]))

(define LOB-INVADER (cons (make-posn 100 250)
                          (cons (make-posn 260 300)
                                (cons (make-posn 380 350) empty))))
(define LOB-SPACESHIP (cons (make-posn 120 240)
                            (cons (make-posn 270 310)
                                  (cons (make-posn 390 360)
                                        (cons (make-posn 410 400) empty)))))
                                                    

(define-struct world (ship invaders ship-bullets invader-bullets))
;; A World is (make-world Ship LoI LoB LoB) 
;; INTERP: represent the ship, the current list of invaders, the inflight
;; spaceship bullets and the inflight invader bullets

;;;; Template: world-fn : World -> ???
#; (define (world-fn a-world)
     ... (ship-fn (world-ship a-world)) ...
     ... (loi-fn (world-invaders a-world)) ...
     ... (lob-fn (world-ship-bullets a-world)) ...
     ... (lob-fn (world-invader-bullets a-world)) ...)

(define WORLD-INIT (make-world SHIP-INIT INVADERS-INIT empty empty))
(define WORLD-TEST-1 (make-world
                       SHIP-INIT
                       (cons (make-posn 200 100)
                             (cons (make-posn 300 100)
                                   (cons (make-posn 400 100) empty)))
                       (cons (make-posn 250 200)
                             (cons (make-posn 200 -100)
                                   (cons (make-posn 195 95) empty)))
                       (cons (make-posn 200 200) (cons (make-posn 340 600)
                             (cons (make-posn 410 270)
                                   (cons (make-posn 120 730) empty))))))
(define WORLD-TEST-2 (make-world
                        SHIP-INIT
                        (cons (make-posn 300 100)
                              (cons (make-posn 400 100) empty))
                        (cons (make-posn 250 200) empty)
                              (cons (make-posn 410 270)
                                    (cons (make-posn 200 200) empty))))

;;;; Signature: world-draw : World -> Image 
;;;; Purpose: given a world, draw the world on the canvas

;;;; Examples
;; (world-draw WORLD-TEST-1)
;; => (place-image INVADER-BULLET-IMAGE 120 730
;;                 (place-image INVADER-BULLET-IMAGE 410 270
;;                              (place-image INVADER-BULLET-IMAGE 340 600
;;                               (place-image INVADER-BULLET-IMAGE 200 200
;;    (place-image SPACESHIP-BULLET-IMAGE 250 200
;;                 (place-image SPACESHIP-BULLET-IMAGE 200 -100
;;                              (place-image SPACESHIP-BULLET-IMAGE 195 95
;;    (place-image INVADER-IMAGE 400 100
;;                 (place-image INVADER-IMAGE 300 100
;;                              (place-image INVADER-IMAGE 200 100
;; (place-image SPACESHIP-IMAGE 250 480 BACKGROUND)))))))))))
;; (world-draw WORLD-TEST-2)
;; => (place-image INVADER-BULLET-IMAGE 200 200
;;                 (place-image INVADER-BULLET-IMAGE 410 270
;;                              (place-image SPACESHIP-BULLET-IMAGE 250 200
;;    (place-image INVADER-IMAGE 400 100
;;                 (place-image INVADER-IMAGE 300 100
;;                              (place-image SPACESHIP-IMAGE 250 480
;;                                           BACKGROUND))))))

;;;; Strategy: structural decomposition of a-world
(define (world-draw a-world)
  (invader-lob-draw (world-invader-bullets a-world)
            (spaceship-lob-draw (world-ship-bullets a-world)
            (loi-draw (world-invaders a-world)
                      (ship-draw (world-ship a-world))))))

;;;; Tests
(check-expect (world-draw WORLD-TEST-1)
 (place-image INVADER-BULLET-IMAGE 120 730
              (place-image INVADER-BULLET-IMAGE 410 270
                           (place-image INVADER-BULLET-IMAGE 340 600
                            (place-image INVADER-BULLET-IMAGE 200 200
 (place-image SPACESHIP-BULLET-IMAGE 250 200
              (place-image SPACESHIP-BULLET-IMAGE 200 -100
                           (place-image SPACESHIP-BULLET-IMAGE 195 95
 (place-image INVADER-IMAGE 400 100
              (place-image INVADER-IMAGE 300 100
                           (place-image INVADER-IMAGE 200 100
 (place-image SPACESHIP-IMAGE 250 480 BACKGROUND))))))))))))
(check-expect (world-draw WORLD-TEST-2)
 (place-image INVADER-BULLET-IMAGE 200 200
              (place-image INVADER-BULLET-IMAGE 410 270
                           (place-image SPACESHIP-BULLET-IMAGE 250 200
 (place-image INVADER-IMAGE 400 100
              (place-image INVADER-IMAGE 300 100
                           (place-image SPACESHIP-IMAGE 250 480
                                        BACKGROUND)))))))

;;;; Signature: ship-draw : Ship -> Image
;;;; Purpose: given a ship, draw it on the canvas

;;;; Examples
;; (ship-draw SHIP-INIT)
;; => (place-image SPACESHIP-IMAGE 250 480 BACKGROUND)
;; (ship-draw SHIP-1)
;; => (place-image SPACESHIP-IMAGE 440 240 BACKGROUND)
;; (ship-draw SHIP-2)
;; => (place-image SPACESHIP-IMAGE 80 220 BACKGROUND)

;;;; Strategy: structural decomposition of a-ship
(define (ship-draw a-ship)
  (place-image SPACESHIP-IMAGE (posn-x (ship-loc a-ship))
               (posn-y (ship-loc a-ship)) BACKGROUND))

;;;; Tests
(check-expect (ship-draw SHIP-INIT)
              (place-image SPACESHIP-IMAGE 250 480 BACKGROUND))
(check-expect (ship-draw SHIP-1)
              (place-image SPACESHIP-IMAGE 440 240 BACKGROUND))
(check-expect (ship-draw SHIP-2)
              (place-image SPACESHIP-IMAGE 80 220 BACKGROUND))

;;;; Signature: loi-draw : LoI Image -> Image
;;;; Purpose: given a list of invaders, and an image, draw the invaders on given
;;;;          image

;;;; Examples
;; (loi-draw empty BACKGROUND) => BACKGROUND
;; (loi-draw (cons (make-posn 300 300) empty) BACKGROUND)
;; => (place-image INVADER-IMAGE 300 300 BACKGROUND)
;; (loi-draw (cons (make-posn 300 300)
;;           (cons (make-posn 400 400) empty)) BACKGROUND)
;; => (place-image INVADER-IMAGE 300 300
;;    (place-image INVADER-IMAGE 400 400 BACKGROUND))

;;;; Strategy: structural decomposition of loi
(define (loi-draw loi bg)
  (cond
    [(empty? loi) bg]
    [(cons? loi) (loi-draw (rest loi) (invader-draw (first loi) bg))]))

;;;; Tests
(check-expect (loi-draw empty BACKGROUND) BACKGROUND)
(check-expect (loi-draw (cons (make-posn 300 300) empty)
                        BACKGROUND)
              (place-image INVADER-IMAGE 300 300 BACKGROUND))
(check-expect (loi-draw (cons (make-posn 300 300)
                              (cons (make-posn 400 400) empty))
                        BACKGROUND)
              (place-image INVADER-IMAGE 300 300
                           (place-image INVADER-IMAGE 400 400 BACKGROUND)))

;;;; Signature: invader-draw : Invader Image -> Image
;;;; Purpose: given an invader and an image, draw invader on image

;;;; Examples
;; (invader-draw (make-posn 200 200) BACKGROUND)
;; => (place-image INVADER-IMAGE 200 200 BACKGROUND)
;; (invader-draw (make-posn 300 300) BACKGROUND)
;; => (place-image INVADER-IMAGE 300 300 BACKGROUND)

;;;; Strategy
(define (invader-draw an-invader bg)
  (place-image INVADER-IMAGE (posn-x an-invader)
               (posn-y an-invader) bg))

;;;; Tests
(check-expect (invader-draw (make-posn 200 200) BACKGROUND)
              (place-image INVADER-IMAGE 200 200 BACKGROUND))
(check-expect (invader-draw (make-posn 300 300) BACKGROUND)
              (place-image INVADER-IMAGE 300 300 BACKGROUND))

;;;; Signature: spaceship-lob-draw : LoB Image -> Image
;;;; Purpose: given a list of spaceship bullets, and an image,
;;;;          draw the given list onto the given image.

;;;; Examples
;; (spaceship-lob-draw empty BACKGROUND) => BACKGROUND
;; (spaceship-lob-draw (cons (make-posn 300 300) empty) BACKGROUND)
;; => (place-image SPACESHIP-BULLET-IMAGE 300 300 BACKGROUND)
;; (spaceship-lob-draw (cons (make-posn 300 300)
;;           (cons (make-posn 400 400) empty)) BACKGROUND)
;; => (place-image SPACESHIP-BULLET-IMAGE 300 300
;;    (place-image SPACESHIP-BULLET-IMAGE 400 400 BACKGROUND))

;;;; Strategy: structural decomposition of lob
(define (spaceship-lob-draw lob bg)
  (cond
    [(empty? lob) bg]
    [(cons? lob) (spaceship-lob-draw
                  (rest lob)
                  (spaceship-bullet-draw (first lob) bg))]))

;;;; Tests
(check-expect (spaceship-lob-draw empty BACKGROUND) BACKGROUND)
(check-expect (spaceship-lob-draw (cons (make-posn 300 300) empty) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 300 300 BACKGROUND))
(check-expect (spaceship-lob-draw (cons (make-posn 300 300)
                                        (cons (make-posn 400 400) empty))
                                  BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 300 300
                           (place-image SPACESHIP-BULLET-IMAGE 400 400
                                        BACKGROUND)))

;;;; Signature: spaceship-bullet-draw : Bullet Image -> Image
;;;; Purpose: given a spaceship bullet, and an image, draw the
;;;;          given bullet onto image and return the new image

;;;; Examples
;; (spaceship-bullet-draw (make-posn 200 200) BACKGROUND)
;; => (place-image SPACESHIP-BULLET-IMAGE 200 200 BACKGROUND)
;; (spaceship-bullet-draw (make-posn 300 300) BACKGROUND)
;; => (place-image SPACESHIP-BULLET-IMAGE 300 300 BACKGROUND)

;;;; Strategy: structural decompostion of a-bullet
(define (spaceship-bullet-draw a-bullet bg)
  (place-image SPACESHIP-BULLET-IMAGE
               (posn-x a-bullet) (posn-y a-bullet) bg))

;;;; Tests
(check-expect (spaceship-bullet-draw (make-posn 200 200) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 200 200 BACKGROUND))
(check-expect (spaceship-bullet-draw (make-posn 300 300) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 300 300 BACKGROUND))

;;;; Signature: invader-lob-draw : LoB Image -> Image
;;;; Purpose: given a list of invader bullets, and an image,
;;;;          draw the given list onto the given image.

;;;; Examples
;; (invader-lob-draw empty BACKGROUND) => BACKGROUND
;; (invader-lob-draw (cons (make-posn 300 300) empty) BACKGROUND)
;; => (place-image INVADER-BULLET-IMAGE 300 300 BACKGROUND)
;; (invader-lob-draw (cons (make-posn 300 300)
;;           (cons (make-posn 400 400) empty)) BACKGROUND)
;; => (place-image INVADER-BULLET-IMAGE 300 300
;;    (place-image INVADER-BULLET-IMAGE 400 400 BACKGROUND))

;;;; Strategy: structural decomposition of lob
(define (invader-lob-draw lob bg)
  (cond
    [(empty? lob) bg]
    [(cons? lob) (invader-lob-draw
                  (rest lob)
                  (invader-bullet-draw (first lob) bg))]))

;;;; Tests
(check-expect (invader-lob-draw empty BACKGROUND) BACKGROUND)
(check-expect (invader-lob-draw (cons (make-posn 300 300) empty) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 300 300 BACKGROUND))
(check-expect (invader-lob-draw (cons (make-posn 300 300)
                                      (cons (make-posn 400 400) empty))
                                BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 300 300
                           (place-image INVADER-BULLET-IMAGE 400 400
                                        BACKGROUND)))

;;;; Signature: invader-bullet-draw : Bullet Image -> Image
;;;; Purpose: given a invader bullet, and an image, draw the
;;;;          given bullet onto image and return the new image

;;;; Examples
;; (invader-bullet-draw (make-posn 200 200) BACKGROUND)
;; => (place-image INVADER-BULLET-IMAGE 200 200 BACKGROUND)
;; (invader-bullet-draw (make-posn 300 300) BACKGROUND)
;; => (place-image INVADER-BULLET-IMAGE 300 300 BACKGROUND)

;;;; Strategy: structural decompostion of a-bullet
(define (invader-bullet-draw a-bullet bg)
  (place-image INVADER-BULLET-IMAGE
               (posn-x a-bullet) (posn-y a-bullet) bg))

;;;; Tests
(check-expect (invader-bullet-draw (make-posn 200 200) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 200 200 BACKGROUND))
(check-expect (invader-bullet-draw (make-posn 300 300) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 300 300 BACKGROUND))

;;;; Signature: move-spaceship : Ship -> Ship
;;;; Purpose: move the given ship in appropriate direction

;;;; Examples
;; (move-spaceship SHIP-INIT)
;; => (make-ship 'left (make-posn 240 480))
;; (move-spaceship SHIP-1)
;; => (make-ship 'right (make-posn 440 240))
;; (move-spaceship SHIP-2)
;; => (move-spaceship 'left (make-posn 80 220))

;;;; Strategy: structural decomposition of a-ship
(define (move-spaceship a-ship)
  (cond
    [(symbol=? 'left (ship-dir a-ship)) (move-spaceship-left a-ship)]
    [(symbol=? 'right (ship-dir a-ship)) (move-spaceship-right a-ship)]))

;;;; Tests
(check-expect (move-spaceship SHIP-INIT)
              (make-ship 'left (make-posn 240 480)))
(check-expect (move-spaceship SHIP-1)
              (make-ship 'right (make-posn 440 240)))
(check-expect (move-spaceship SHIP-2)
              (make-ship 'left (make-posn 80 220)))

;;;; Signature: move-spaceship-left : Ship -> Ship
;;;; Purpose: given a ship, return a new ship that has moved left by SHIP-SPEED
;;;;          units

;;;; Examples
;; (move-spaceship-left SHIP-INIT)
;; => (make-ship 'left (make-posn 240 480))
;; (move-spaceship-left SHIP-1)
;; => (make-ship 'right (make-posn 430 240))
;; (move-spaceship-left 'right SHIP-2)
;; => (make-ship 'left (make-posn 80 220))

;;;; Strategy: structural decomposition of a-ship
(define (move-spaceship-left a-ship)
  (cond
    [(> (posn-x (ship-loc a-ship)) (- MIN-X (/ INVADER-SIDE 2)))
     (make-ship (ship-dir a-ship) (make-posn (- (posn-x (ship-loc a-ship))
                                             SHIP-SPEED)
                                          (posn-y (ship-loc a-ship))))]
    [else a-ship]))  

;;;; Tests
(check-expect (move-spaceship-left SHIP-INIT)
              (make-ship 'left (make-posn 240 480)))
(check-expect (move-spaceship-left SHIP-1)
              (make-ship 'right (make-posn 430 240)))
(check-expect (move-spaceship-left SHIP-2)
              (make-ship 'left (make-posn 80 220)))

;;;; Signature: move-spaceship-right : Ship -> Ship
;;;; Purpose: given a ship, return a new ship that has moved right by SHIP-SPEED
;;;;          units

;;;; Examples
;; (move-spaceship-right SHIP-INIT)
;; => (make-ship 'left (make-posn 260 480))
;; (move-spaceship-right SHIP-1)
;; => (make-ship 'right (make-posn 440 240))
;; (move-spaceship-right SHIP-2)
;; => (make-ship 'left (make-posn 90 220))

;;;; Strategy: structural decomposition of a-ship
(define (move-spaceship-right a-ship)
  (cond
    [(< (posn-x (ship-loc a-ship)) (+ MAX-X (/ INVADER-SIDE 2)))
     (make-ship (ship-dir a-ship) (make-posn (+ SHIP-SPEED
                                             (posn-x (ship-loc a-ship)))
                                          (posn-y (ship-loc a-ship))))]
    [else a-ship]))

;;;; Tests
(check-expect (move-spaceship-right SHIP-INIT)
              (make-ship 'left (make-posn 260 480)))
(check-expect (move-spaceship-right SHIP-1)
              (make-ship 'right (make-posn 440 240)))
(check-expect (move-spaceship-right SHIP-2)
              (make-ship 'left (make-posn 90 220)))

;;;; Signature: move-spaceship-bullets : LoB -> LoB
;;;; Purpose: given a list of spaceship bullets, return a new list
;;;;          of bullets that have moved up by BULLET-SPEED units

;;;; Examples
;; (move-spaceship-bullets LOB-INVADER)
;; => (cons (make-posn 100 240) (cons (make-posn 260 290)
;;    (cons (make-posn 380 340) empty)))
;; (move-spaceship-bullets LOB-SPACESHIP)
;; => (cons (make-posn 120 230) (cons (make-posn 270 300)
;;    (cons (make-posn 390 350) (cons (make-posn 410 390 empty))))

;;;; Strategy: structural decomposition of lob
(define (move-spaceship-bullets lob)
  (cond
    [(empty? lob) lob]
    [(cons? lob) (cons (move-spaceship-bullet (first lob))
                       (move-spaceship-bullets (rest lob)))]))

;;;; Tests
(check-expect (move-spaceship-bullets LOB-INVADER)
              (cons (make-posn 100 240)
                    (cons (make-posn 260 290)
                          (cons (make-posn 380 340) empty))))
(check-expect (move-spaceship-bullets LOB-SPACESHIP)
              (cons (make-posn 120 230)
                    (cons (make-posn 270 300)
                          (cons (make-posn 390 350)
                                (cons (make-posn 410 390) empty)))))

;;;; Signature: move-spaceship-bullet : Bullet -> Bullet
;;;; Purpose: given a spaceship bullet, return a new bullet that has
;;;;          been shifted up by BULLET-SPEED units

;;;; Examples
;; (move-spaceship-bullet (make-posn 240 230))
;; => (make-posn 240 220)
;; (move-spaceship-bullet (make-posn 390 300))
;; => (make-posn 390 290)

;;;; Strategy: structural decomposition of a-bullet
(define (move-spaceship-bullet a-bullet)
  (make-posn (posn-x a-bullet)
               (- (posn-y a-bullet) BULLET-SPEED)))

;;;; Tests
(check-expect (move-spaceship-bullet (make-posn 240 230))
              (make-posn 240 220))
(check-expect (move-spaceship-bullet (make-posn 390 300))
              (make-posn 390 290))

;;;; Signature: move-invader-bullets : LoB -> LoB
;;;; Purpose: given a list of invader bullets, return a new list
;;;;          of bullets that have moved down by BULLET-SPEED units

;;;; Examples
;; (move-invader-bullets LOB-INVADER)
;; => (cons (make-posn 100 260) (cons (make-posn 260 310)
;;    (cons (make-posn 380 360) empty)))
;; (move-invader-bullets LOB-SPACESHIP)
;; => (cons (make-posn 120 250) (cons (make-posn 270 320)
;;    (cons (make-posn 390 370) (cons (make-posn 410 410) empty))))

;;;; Strategy: structural decomposition of lob
(define (move-invader-bullets lob)
  (cond
    [(empty? lob) lob]
    [(cons? lob) (cons (move-invader-bullet (first lob))
                       (move-invader-bullets (rest lob)))]))

;;;; Tests
(check-expect (move-invader-bullets LOB-INVADER)
              (cons (make-posn 100 260)
                    (cons (make-posn 260 310)
                          (cons (make-posn 380 360) empty))))
(check-expect (move-invader-bullets LOB-SPACESHIP)
              (cons (make-posn 120 250)
                    (cons (make-posn 270 320)
                          (cons (make-posn 390 370)
                                (cons (make-posn 410 410) empty)))))

;;;; Signature: move-invader-bullet : Bullet -> Bullet
;;;; Purpose: given an invader bullet, return a new bullet that has
;;;;          shifted down by BULLET-SPEED units

;;;; Examples
;; (move-invader-bullet (make-posn 240 230))
;; => (make-posn 240 240)
;; (move-invader-bullet (make-posn 390 300))
;; => (make-posn 390 310)

;;;; Strategy: structural decomposition of a-bullet
(define (move-invader-bullet a-bullet)
  (make-posn (posn-x a-bullet)
             (+ BULLET-SPEED (posn-y a-bullet))))

;;;; Tests
(check-expect (move-invader-bullet (make-posn 240 230))
              (make-posn 240 240))
(check-expect (move-invader-bullet (make-posn 390 300))
              (make-posn 390 310))

;;;; Signature: invaders-fire : LoB LoI -> LoB
;;;; Purpose: given a list of bullets, and a list of invaders,
;;;;          return a new list of bullets where a random invader
;;;;          fires a new bullet
;;;; WHERE: given list of invaders is non-empty

;;;; Examples
;; (invaders-fire empty INVADERS-INIT
;; => (local ((define index (+ 1 (random 36))))
;;    (cons (make-posn (posn-x (element-at index INVADERS-INIT))
;;                     (posn-y (element-at index INVADERS-INIT)))
;;          empty)))
;; (invaders-fire LOB-SPACESHIP INVADERS-INIT
;; => (local ((define index (+ 1 (random 36))))
;;    (cons (make-posn (posn-x (element-at index INVADERS-INIT))
;;                     (posn-y (element-at index INVADERS_INIT)))
;;          LOB-SPACESHIP)))
;; (invaders-fire INVADERS-INIT LOB-INVADER) => INVADERS-INIT

;;;; Strategy:
(define (invaders-fire lob loi)
  (cond
    [(>= (num-elements lob) MAX-INVADER-BULLETS) lob]
    [else (invaders-fire-helper lob loi (+ 1 (random (num-elements loi))))]))

;;;; Tests
(check-random (invaders-fire empty INVADERS-INIT)
              (local ((define index (+ 1 (random 36))))
                (cons (make-posn (posn-x (element-at index INVADERS-INIT))
                                 (posn-y (element-at index INVADERS-INIT)))
                      empty)))
(check-random (invaders-fire LOB-SPACESHIP INVADERS-INIT)
              (local ((define index (+ 1 (random 36))))
                (cons (make-posn (posn-x (element-at index INVADERS-INIT))
                                 (posn-y (element-at index INVADERS-INIT)))
                      LOB-SPACESHIP)))
(check-expect (invaders-fire INVADERS-INIT LOB-INVADER) INVADERS-INIT)

;;;; Signature: invaders-fire-helper : LoB LoI NonNegInteger -> LoB
;;;; Purpose: see invaders-fire. The randomly chosen invader is given by the
;;;;          final argument.

;;;; Examples
;; (invaders-fire-helper LOB-SPACESHIP INVADERS-INIT 23)
;; => (cons (make-posn 260 80) (cons (make-posn 120 240)
;;    (cons (make-posn 270 310) (cons (make-posn 390 360)
;;    (cons (make-posn 410 400) empty)))))
;; (invaders-fire-helper LOB-INVADER INVADERS-INIT 11)
;; => (cons (make-posn 140 50) (cons (make-posn 100 250)
;;    (cons (make-posn 260 300) (cons (make-posn 380 350) empty))))


;;;; Strategy: structural decomposition of loi
(define (invaders-fire-helper lob loi index)
  (cons (make-posn (posn-x (element-at index loi))
                   (posn-y (element-at index loi))) lob))

;;;; Tests
(check-expect (invaders-fire-helper LOB-SPACESHIP INVADERS-INIT 23)
              (cons (make-posn 260 80)
                    (cons (make-posn 120 240)
                          (cons (make-posn 270 310)
                                (cons (make-posn 390 360)
                                      (cons (make-posn 410 400) empty))))))
(check-expect (invaders-fire-helper LOB-INVADER INVADERS-INIT 11)
              (cons (make-posn 140 50)
                    (cons (make-posn 100 250)
                          (cons (make-posn 260 300)
                                (cons (make-posn 380 350) empty)))))

;;;; Signature: num-elements: LoB | LoI -> NonNegInteger
;;;; Purpose: given a list, return the number of elements in the list

;;;; Examples
;; (num-elements empty) => 0
;; (num-elements LOB-INVADER) => 3
;; (num-elements INVADERS-INIT) => 36

;;;; Strategy: structural decomposition of a-list
(define (num-elements a-list)
  (cond
    [(empty? a-list) 0]
    [(cons? a-list) (+ 1 (num-elements (rest a-list)))]))

;;;; Tests
(check-expect (num-elements empty) 0)
(check-expect (num-elements LOB-INVADER) 3)
(check-expect (num-elements INVADERS-INIT) 36)

;;;; Signature: element-at: NonNegInteger LoB | LoI -> Bullet | Invader
;;;; Purpose: given a list and an index, return element at given index
;;;; WHERE: given index is <= (num-elements list)

;;;; Examples
;; (element-at 23 INVADERS-INIT) => (make-posn 260 80)
;; (element-at 2 LOB-SPACESHIP) => (make-posn 270 310)

;;;; Strategy: structural decomposition of a-list
(define (element-at index a-list)
  (cond
    [(= index 1) (first a-list)]
    [else (element-at (- index 1) (rest a-list))]))

;;;; Tests
(check-expect (element-at 23 INVADERS-INIT) (make-posn 260 80))
(check-expect (element-at 2 LOB-SPACESHIP) (make-posn 270 310))

;;;; Signature: remove-hits-and-out-of-bounds : World -> World
;;;; Purpose: given a world, return a new world with all hit invaders
;;;;          and all out-of-bounds bullets removed

;;;; Examples
;; (remove-hits-and-out-of-bounds WORLD-INIT) => WORLD-INIT
;; (remove-hits-and-out-of-bounds WORLD-TEST-1) => WORLD-TEST-2

;;;; Strategy: structural decomposition of a-world
(define (remove-hits-and-out-of-bounds a-world)
  (make-world (world-ship a-world)
              (update-invaders (world-invaders a-world)
                               (world-ship-bullets a-world))
              (update-bullets (world-ship-bullets a-world)
                              (world-invaders a-world))
              (update-bullets (world-invader-bullets a-world) empty)))

;;;; Tests
(check-expect (remove-hits-and-out-of-bounds WORLD-INIT) WORLD-INIT)
(check-expect (remove-hits-and-out-of-bounds WORLD-TEST-1) WORLD-TEST-2)

;;;; Signature: update-invaders : LoI LoB -> LoI
;;;; Purpose: given a list of invaders, and a list of bullets, return a new
;;;;          list of invaders which contain only those that have not been
;;;;          hit by any of the bullets

;;;; Examples
;; (update-invaders (cons (make-posn 240 240) (cons (make-posn 310 210)
;;                  (cons (make-posn 100 400) empty)))
;;                  empty)
;; => (cons (make-posn 240 240) (cons (make-posn 310 210)
;;    (cons (make-posn 100 400) empty)))
;; (update-invaders empty empty) => empty
;; (update-invaders empty LOB-SPACESHIP) => empty)
;; (update-invaders (cons (make-posn 115 240) (cons (make-posn 310 210)
;;                  empty)) LOB-SPACESHIP)
;; => (cons (make-posn 310 210) empty)

;;;; Strategy:
(define (update-invaders loi lob)
  (cond
    [(empty? loi) empty]
    [(cons? loi)
     (cond
       [(hit? (first loi) lob) (update-invaders (rest loi) lob)]
       [else (cons (first loi) (update-invaders (rest loi) lob))])]))

;;;; Tests
(check-expect (update-invaders (cons (make-posn 240 240)
                                     (cons (make-posn 310 210)
                                           (cons (make-posn 100 400) empty)))
                               empty)
              (cons (make-posn 240 240)
                    (cons (make-posn 310 210)
                          (cons (make-posn 100 400) empty))))
(check-expect (update-invaders empty empty) empty)
(check-expect (update-invaders empty LOB-SPACESHIP) empty)
(check-expect (update-invaders (cons (make-posn 115 240)
                                     (cons (make-posn 310 210) empty))
                               LOB-SPACESHIP)
              (cons (make-posn 310 210) empty))

;;;; Signature: hit? : Invader LoB -> Boolean
;;;; Purpose: given a list of bullets, and an invader, return #true if
;;;;          any of the bullets hit the invader. Else, return #false

;;;; Examples
;; (hit? (make-posn 120 240) empty) => #false
;; (hit? (make-posn 270 310) LOB-SPACESHIP) => #true
;; (hit? (make-posn 260 310) LOB-SPACESHIP) => #true
;; (hit? (make-posn 250 310) LOB-SPACESHIP) => #false
;; (hit? (make-posn 80 230) LOB-INVADER) => #false

;;;; Strategy: structural decomposition of lob
(define (hit? an-invader lob)
  (cond
    [(empty? lob) #false]
    [(cons? lob)
     (cond
       [(and (<= (abs (- (posn-x an-invader) (posn-x (first lob))))
                 (+ BULLET-RADIUS (/ INVADER-SIDE 2)))
             (<= (abs (- (posn-y an-invader) (posn-y (first lob))))
                 (+ BULLET-RADIUS (/ INVADER-SIDE 2)))) #true]
       [else (hit? an-invader (rest lob))])]))

;;;; Tests
(check-expect (hit? (make-posn 120 240) empty) #false)
(check-expect (hit? (make-posn 270 310) LOB-SPACESHIP) #true)
(check-expect (hit? (make-posn 260 310) LOB-SPACESHIP) #true)
(check-expect (hit? (make-posn 250 310) LOB-SPACESHIP) #false)
(check-expect (hit? (make-posn 80 230) LOB-INVADER) #false)

;;;; Signature: update-bullets: LoB LoI -> LoB
;;;; Purpose: given a list of bullets and a list of invaders,
;;;;          remove all bullets which are out of bounds or have
;;;;          hit and invader, and return new list

;;;; Examples
;; (update-bullets empty empty) => empty
;; (update-bullets LOB-SPACESHIP empty)
;; => (cons (make-posn 410 400) (cons (make-posn 390 360)
;;    (cons (make-posn 270 310) (cons (make-posn 120 240) empty))))
;; (update-bullets empty INVADERS-INIT) => empty
;; (update-bullets LOB-SPACESHIP (cons (make-posn 200 200)
;;                               (cons (make-posn 380 360) empty)))
;; => (cons (make-posn 410 400) (cons (make-posn 270 310)
;;    (cons (make-posn 120 240) empty)))
;; (update-bullets (cons (make-posn 230 730) LOB-SPACESHIP) empty)
;; => (cons (make-posn 410 400) (cons (make-posn 390 360)
;;    (cons (make-posn 270 310) (cons (make-posn 120 240) empty))))
;; (update-bullets (cons (make-posn 230 730) LOB-SPACESHIP)
;;                 (cons (make-posn 200 200)
;;                 (cons (make-posn 380 360) empty)))
;; => (cons (make-posn 410 400) (cons (make-posn 270 310)
;;    (cons (make-posn 120 240) empty)))

;;;; Strategy: structural decomposition of loi
(define (update-bullets lob loi)
  (update-bullets-helper lob loi empty))

;;;; Tests
(check-expect (update-bullets empty empty) empty)
(check-expect (update-bullets LOB-SPACESHIP empty)
              (cons (make-posn 410 400)
                    (cons (make-posn 390 360)
                          (cons (make-posn 270 310)
                                (cons (make-posn 120 240) empty)))))
(check-expect (update-bullets empty INVADERS-INIT) empty)
(check-expect (update-bullets LOB-SPACESHIP
                              (cons (make-posn 200 200)
                                    (cons (make-posn 380 360) empty)))
              (cons (make-posn 410 400)
                    (cons (make-posn 270 310)
                          (cons (make-posn 120 240) empty))))
(check-expect (update-bullets (cons (make-posn 230 730) LOB-SPACESHIP) empty)
              (cons (make-posn 410 400)
                    (cons (make-posn 390 360)
                          (cons (make-posn 270 310)
                                (cons (make-posn 120 240) empty)))))
(check-expect (update-bullets (cons (make-posn 230 730) LOB-SPACESHIP)
                              (cons (make-posn 200 200)
                                    (cons (make-posn 380 360) empty)))
              (cons (make-posn 410 400)
                    (cons (make-posn 270 310)
                          (cons (make-posn 120 240) empty))))

;;;; Signature: update-bullets-helper : LoB LoI LoB -> LoB
;;;; Purpose: see update-bullets. The last argument is an accumulator.

;;;; Definition
(define (update-bullets-helper lob loi acc)
  (cond
    [(empty? lob) (remove-out-of-bounds acc)]
    [(cons? lob)
     (cond
       [(bullet-hit? (first lob) loi)
        (update-bullets-helper (rest lob) loi acc)]
       [else (update-bullets-helper (rest lob) loi (cons (first lob) acc))])]))

;;;; Signature: bullet-hit? Bullet LoI -> Boolean
;;;; Purpose: given a bullet, and a list of invaders, see if the bullet
;;;;          hit an invader

;;;; Examples
;; (bullet-hit? (make-posn 100 240) empty) => #false
;; (bullet-hit? (make-posn 100 240) LOB-SPACESHIP) => #false
;; (bullet-hit? (make-posn 110 240) LOB-SPACESHIP) => #true
;; (bullet-hit? (make-posn 130 110) INVADERS-INIT) => #true

;;;; Strategy: structural decomposition of loi
(define (bullet-hit? a-bullet loi)
  (cond
    [(empty? loi) #false]
    [(cons? loi)
     (cond
       [(and (<= (abs (- (posn-x a-bullet) (posn-x (first loi))))
                 (+ BULLET-RADIUS (/ INVADER-SIDE 2)))
             (<= (abs (- (posn-y a-bullet) (posn-y (first loi))))
                 (+ BULLET-RADIUS (/ INVADER-SIDE 2)))) #true]
       [else (bullet-hit? a-bullet (rest loi))])]))

;;;; Tests
(check-expect (bullet-hit? (make-posn 100 240) empty) #false)
(check-expect (bullet-hit? (make-posn 100 240) LOB-SPACESHIP) #false)
(check-expect (bullet-hit? (make-posn 110 240) LOB-SPACESHIP) #true)
(check-expect (bullet-hit? (make-posn 130 110) INVADERS-INIT) #true)

;;;; Signature: remove-out-of-bounds: LoB -> LoB
;;;; Purpose: Given a list of bullets, return a new list where bullets
;;;;          that have gone out of bounds have been removed

;;;; Examples
;; (remove-out-of-bounds empty) => empty
;; (remove-out-of-bounds (cons (make-posn 200 570) empty)) => empty
;; (remove-out-of-bounds (cons (make-posn 200 400) (cons (make-posn 230 530)
;;                       (cons (make-posn 470 110) empty))
;; => (cons (make-posn 200 400) (cons (make-posn 470 110) empty))

;;;; Strategy: structural decomposition of lob
(define (remove-out-of-bounds lob)
  (cond
    [(empty? lob) empty]
    [(cons? lob)
     (cond
       [(within-bounds? (first lob)) (cons (first lob)
                                           (remove-out-of-bounds (rest lob)))]
       [else (remove-out-of-bounds (rest lob))])]))

;;;; Tests
(check-expect (remove-out-of-bounds empty) empty)
(check-expect (remove-out-of-bounds (cons (make-posn 200 570) empty)) empty)
(check-expect (remove-out-of-bounds (cons (make-posn 200 400)
                                          (cons (make-posn 230 530)
                                                (cons (make-posn 470 110)
                                                      empty))))
              (cons (make-posn 200 400) (cons (make-posn 470 110) empty)))

;;;; Signature: within-bounds? : Bullet -> Boolean
;;;; Purpose: given a bullet, return #true if it is still within bounds, else
;;;;          return #false

;;;; Examples
;; (within-bounds? (make-posn 510 200)) => #false
;; (within-bounds? (make-posn 400 200)) => #true
;; (within-bounds? (make-posn -230 20)) => #false
;; (within-bounds? (make-posn 0 0)) => #true
;; (within-bounds? (make-posn 500 500)) => #true

;;;; Strategy:
(define (within-bounds? a-bullet)
  (cond
    [(and (and (>= (posn-x a-bullet) 0) (<= (posn-x a-bullet) WIDTH))
          (and (>= (posn-y a-bullet) 0) (<= (posn-y a-bullet) HEIGHT))) #true]
    [else #false]))

;;;; Tests
(check-expect (within-bounds? (make-posn 510 200)) #false)
(check-expect (within-bounds? (make-posn 400 200)) #true)
(check-expect (within-bounds? (make-posn -230 20)) #false)
(check-expect (within-bounds? (make-posn 0 0)) #true)
(check-expect (within-bounds? (make-posn 500 500)) #true)

;;;; Signature: ship-hit? : Ship LoB -> Boolean
;;;; Purpose: given a ship and a list of bullets, return #true if the
;;;;          ship has been hit, else return #false

;;;; Examples
;; (ship-hit? SHIP-INIT empty) => #false
;; (ship-hit? SHIP-2 (cons (make-posn 200 240) empty)) => #false
;; (ship-hit? SHIP-1 (cons (make-posn 430 235)
;;                  (cons (make-posn 200 240) empty))) => #true

;;;; Strategy: structural decomposition of lob
(define (ship-hit? a-ship lob)
  (cond
    [(empty? lob) #false]
    [(cons? lob)
     (cond
       [(and (<= (abs (- (posn-x (ship-loc a-ship)) (posn-x (first lob))))
                 (+ BULLET-RADIUS (/ SHIP-WIDTH 2)))
             (<= (abs (- (posn-y (ship-loc a-ship)) (posn-y (first lob))))
                 (+ BULLET-RADIUS (/ SHIP-HEIGHT 2)))) #true]
       [else (ship-hit? a-ship (rest lob))])]))    

;;;; Tests
(check-expect (ship-hit? SHIP-INIT empty) #false)
(check-expect (ship-hit? SHIP-2 (cons (make-posn 200 240) empty)) #false)
(check-expect (ship-hit? SHIP-1 (cons (make-posn 430 235)
                                     (cons (make-posn 200 240) empty))) #true)

;;;; Signature: update-world : World -> World
;;;; Purpose: given a world, return a new world after unit time
;;;;          has passed

;;;; Examples
;; (update-world WORLD-INIT)
;; => (local ((define index (+ 1 (random 36))))
;;    (make-world (make-ship 'left (make-posn 240 480))
;;                INVADERS-INIT empty
;;                (cons (make-posn (posn-x (element-at index INVADERS-INIT))
;;                                 (posn-y (element-at index INVADERS-INIT))
;;                      empty))
;; (update-world WORLD-TEST-2)
;; => (local ((define index (+ 1 (random 2)))
;;                          (define INVADERS-TEST (cons (make-posn 300 100)
;;                                                     (cons (make-posn 400 100)
;;                                                            empty))))
;;                    (make-world (make-ship 'left (make-posn 240 480))
;;                               INVADERS-TEST (cons (make-posn 250 190) empty)
;;                                (cons (make-posn 200 210)
;;                                      (cons (make-posn 410 280)
;;                                            (cons (make-posn
;;                    (posn-x (element-at index INVADERS-TEST))
;;                    (posn-y (element-at index INVADERS-TEST))) empty)))))

;;;; Strategy:
(define (update-world a-world)
  (remove-hits-and-out-of-bounds
   (make-world (move-spaceship (world-ship a-world))
               (world-invaders a-world) 
               (move-spaceship-bullets (world-ship-bullets a-world))
               (invaders-fire
                (move-invader-bullets (world-invader-bullets a-world))
                (world-invaders a-world)))))

;;;; Tests
(check-random (update-world WORLD-INIT)
              (local ((define index (+ 1 (random 36))))
                (make-world (make-ship 'left (make-posn 240 480))
                            INVADERS-INIT empty
                            (cons (make-posn (posn-x
                                              (element-at index INVADERS-INIT))
                                             (posn-y
                                              (element-at index INVADERS-INIT)))
                                  empty))))
(check-random (update-world WORLD-TEST-2)
              (local ((define index (+ 1 (random 2)))
                      (define INVADERS-TEST (cons (make-posn 300 100)
                                                  (cons (make-posn 400 100)
                                                        empty))))
                (make-world (make-ship 'left (make-posn 240 480))
                            INVADERS-TEST (cons (make-posn 250 190) empty)
                            (cons (make-posn 200 210)
                                  (cons (make-posn 410 280)
                                        (cons (make-posn
                (posn-x (element-at index INVADERS-TEST))
                (posn-y (element-at index INVADERS-TEST))) empty))))))

;;;; Signature: fire-or-change-direction : World KeyEvent -> World
;;;; Purpose: given a key-event, fire a spaceship if key-event is space, else
;;;;          if keyevent is left or right, change spaceship to that direction

;;;; Examples
;; (fire-or-change-direction WORLD-INIT "left") => WORLD-INIT
;; (fire-or-change-direction WORLD-INIT "right")
;; => (make-world (make-ship 'right (make-posn 250 480))
;;                INVADERS-INIT empty empty)
;; (fire-or-change-direction WORLD-INIT " ")
;; => (make-world (make-ship 'left (make-posn 250 480))
;;                INVADERS-INIT (cons (make-posn 250 480) empty) empty)
;; (fire-or-change-direction WORLD-INIT "q") => WORLD-INIT
;; (fire-or-change-direction (make-world
;;                           (make-ship 'right (make-posn 250 480))
;;                           INAVDERS-INIT empty empty) "left") => WORLD-INIT
;; (fire-or-change-direction (make-world
;;                           (make-ship 'right (make-posn 250 480))
;;                           INVADERS-INIT empty empty) "right")
;; => (make-world (make-ship 'right (make-posn 250 480))
;;                INVADERS-INIT empty empty)
;; (fire-or-change-direction (make-world (make-ship 'left (make-posn 250 480))
;;                           INVADERS-INIT (cons (make-posn 200 300)
;;                                         (cons (make-posn 300 400)
;;                                         (cons (make-posn 400 450) empty)))
;;                           empty) " ")
;; => (make-world (make-ship 'left (make-posn 250 480)) INVADERS-INIT
;;                (cons (make-posn 200 300) (cons (make-posn 300 400)
;;                (cons (make-posn 400 450) empty))) empty)

;;;; Strategy
(define (fire-or-change-direction a-world key-event)
  (cond
    [(key=? key-event "left") (change-direction-to-left a-world)]
    [(key=? key-event "right") (change-direction-to-right a-world)]
    [(key=? key-event " ") (spaceship-fire a-world)]
    [else a-world]))

;;;; Tests
(check-expect (fire-or-change-direction WORLD-INIT "left") WORLD-INIT)
(check-expect (fire-or-change-direction WORLD-INIT "right")
              (make-world (make-ship 'right (make-posn 250 480))
                          INVADERS-INIT empty empty))
(check-expect (fire-or-change-direction WORLD-INIT " ")
              (make-world (make-ship 'left (make-posn 250 480))
                          INVADERS-INIT (cons (make-posn 250 480) empty)
                          empty))
(check-expect (fire-or-change-direction WORLD-INIT "q") WORLD-INIT)
(check-expect (fire-or-change-direction
               (make-world (make-ship 'right (make-posn 250 480))
                           INVADERS-INIT empty empty) "left") WORLD-INIT)
(check-expect (fire-or-change-direction
               (make-world (make-ship 'right (make-posn 250 480))
                           INVADERS-INIT empty empty) "right")
              (make-world (make-ship 'right (make-posn 250 480)) INVADERS-INIT
                          empty empty))
(check-expect (fire-or-change-direction
               (make-world (make-ship 'left (make-posn 250 480)) INVADERS-INIT
                           (cons (make-posn 200 300)
                                 (cons (make-posn 300 400)
                                       (cons (make-posn 400 450) empty))) empty)
               " ") (make-world (make-ship 'left (make-posn 250 480))
                                INVADERS-INIT
                                (cons (make-posn 200 300)
                                      (cons (make-posn 300 400)
                                            (cons (make-posn 400 450) empty)))
                                empty))


;;;; Signature: change-direction-to-left : World -> World
;;;; Purpose: given a world, change the direction of its ship
;;;;          to the left direction

;;;; Examples
;; (change-direction-to-left WORLD-INIT) => WORLD-INIT
;; (change-to-direction-to-left (make-world (make-ship 'right
;;                                                     (make-posn 250 480))
;;                                          INVADERS-INIT empty empty))
;; => WORLD-INIT

;;;; Strategy: structural decomposition of a-world
(define (change-direction-to-left a-world)
  (cond
       [(symbol=? (ship-dir (world-ship a-world)) 'left) a-world]
       [else (make-world (toggle-direction (world-ship a-world))
                         (world-invaders a-world)
                         (world-ship-bullets a-world)
                         (world-invader-bullets a-world))]))

;;;; Tests
(check-expect (change-direction-to-left WORLD-INIT) WORLD-INIT)
(check-expect (change-direction-to-left
               (make-world (make-ship 'right (make-posn 250 480)) INVADERS-INIT
                           empty empty))
              WORLD-INIT)

;;;; Signature: change-direction-to-right : World -> World
;;;; Purpose: given a world, change the direction of its ship
;;;;          to the right direction

;;;; Examples
;; (change-direction-to-right WORLD-INIT)
;; => (make-world (make-ship 'right (make-posn 250 480)) INVADERS-INIT
;;                empty empty)
;; (change-to-direction-to-right (make-world (make-ship 'right
;;                                                      (make-posn 250 480))
;;                                           INVADERS-INIT empty empty)
;; => (make-world (make-ship 'left (make-posn 250 480)) INVADERS-INIT empty
;;                empty)


;;;; Strategy: structural decomposition of a-world
(define (change-direction-to-right a-world)
  (cond
       [(symbol=? (ship-dir (world-ship a-world)) 'right) a-world]
       [else (make-world (toggle-direction (world-ship a-world))
                         (world-invaders a-world)
                         (world-ship-bullets a-world)
                         (world-invader-bullets a-world))]))

;;;; Tests
(check-expect (change-direction-to-right WORLD-INIT)
              (make-world (make-ship 'right (make-posn 250 480)) INVADERS-INIT
                          empty empty))
(check-expect (change-direction-to-right
               (make-world (make-ship 'right (make-posn 250 480)) INVADERS-INIT
                           empty empty))
              (make-world (make-ship 'right (make-posn 250 480)) INVADERS-INIT
                          empty empty))


;;;; Signature: spaceship-fire : World -> World
;;;; Purpose: given a world, check if maximum number of bullets
;;;;          have been fired from the spaceship. If yes, return
;;;;          the same world, else fire one more bullet

;;;; Examples
;; (spaceship-fire WORLD-INIT)
;; => (make-world (make-ship 'left (make-posn 250 480)) INVADERS-INIT
;;    (cons (make-posn 250 480) empty) empty)
;; (spaceship-fire (make-world (make-ship 'left (make-posn 250 480))
;;                             INVADERS-INIT (cons (make-posn 300 300) empty)
;;                             empty))
;; => (make-world (make-ship 'left (make-posn 250 480)) INVADERS-INIT
;;    (cons (make-posn 250 480) (cons (make-posn 300 300) empty)) empty)
;; (spaceship-fire (make-world (make-ship 'left (make-posn 250 480))
;;                             INVADERS-INIT
;;                             (cons (make-posn 100 300)
;;                             (cons (make-posn 300 300)
;;                             (cons (make-posn 400 300) empty))) empty))
;; => (make-world (make-ship 'left (make-posn 250 480)) INVADERS-INIT
;;    (cons (make-posn 100 300) (cons (make-posn 300 300)
;;    (cons (make-posn 400 300) empty))) empty)

;;;; Strategy: structural decomposition of a-world
(define (spaceship-fire a-world)
  (cond
    [(= (num-elements (world-ship-bullets a-world)) MAX-SHIP-BULLETS)
        a-world]
    [else (make-world (world-ship a-world) (world-invaders a-world)
                      (cons (ship-loc (world-ship a-world))
                            (world-ship-bullets a-world))
                      (world-invader-bullets a-world))]))

;;;; Tests
(check-expect (spaceship-fire WORLD-INIT)
              (make-world (make-ship 'left (make-posn 250 480)) INVADERS-INIT
                          (cons (make-posn 250 480) empty) empty))
(check-expect (spaceship-fire (make-world (make-ship 'left (make-posn 250 480))
                                          INVADERS-INIT
                                          (cons (make-posn 300 300) empty)
                                          empty))
              (make-world (make-ship 'left (make-posn 250 480)) INVADERS-INIT
                          (cons (make-posn 250 480)
                                (cons (make-posn 300 300) empty)) empty))
(check-expect (spaceship-fire (make-world (make-ship 'left (make-posn 250 480))
                                          INVADERS-INIT
                                          (cons (make-posn 100 300)
                                                (cons (make-posn 300 300)
                                                      (cons (make-posn 400 300)
                                                            empty))) empty))
              (make-world (make-ship 'left (make-posn 250 480)) INVADERS-INIT
                          (cons (make-posn 100 300)
                                (cons (make-posn 300 300)
                                      (cons (make-posn 400 300) empty))) empty))

;;;; Signature: toggle-direction : Ship -> Ship
;;;; Purpose: given a ship, change the ship's direction

;;;; Examples
;; (toggle-direction SHIP-INIT) => (make-ship 'right (make-posn 250 480))
;; (toggle-direction (make-ship 'left (make-posn 200 300)))
;; => (make-ship 'right (make-posn 200 300))

;;;; Strategy
(define (toggle-direction a-ship)
  (cond
    [(symbol=? (ship-dir a-ship) 'left)
     (make-ship 'right (make-posn (posn-x (ship-loc a-ship))
                                  (posn-y (ship-loc a-ship))))]
    [else (make-ship 'left (make-posn (posn-x (ship-loc a-ship))
                                      (posn-y (ship-loc a-ship))))]))

;;;; Tests
(check-expect (toggle-direction SHIP-INIT)
              (make-ship 'right (make-posn 250 480)))
(check-expect (toggle-direction (make-ship 'right (make-posn 200 300)))
              (make-ship 'left (make-posn 200 300)))
  
;;;; Signature: won? : World -> Boolean
;;;; Purpose: given a world, return #true if all invaders have been
;;;;          destroyed. Else, return #false

;;;; Examples
;; (won? WORLD-INIT) => #false
;; (won? (make-world (make-ship 'left (make-posn 250 480)) empty empty empty)
;; => #true
;; (won? WORLD-TEST-2) => #false

;;;; Strategy:
(define (won? a-world)
  (cond
    [(= (num-elements (world-invaders a-world)) 0) #true]
    [else #false]))

;;;; Tests
(check-expect (won? WORLD-INIT) #false)
(check-expect (won? (make-world (make-ship 'left (make-posn 250 480))
                                empty empty empty)) #true)
(check-expect (won? WORLD-TEST-2) #false)

;;;; Signature: stop? : World -> Boolean
;;;; Purpose: given a world, check if the game has ended

;;;; Examples
;; (stop? WORLD-INIT) => #false
;; (stop? (make-world SHIP-INIT INVADERS-INIT empty
;;                    (cons (make-posn 240 480) empty))) => #true
;; (stop? WORLD-TEST-2) => #false

;;;; Strategy:
(define (stop? a-world)
  (cond
    [(or (ship-hit? (world-ship a-world) (world-invader-bullets a-world))
         (won? a-world)) #true]
    [else #false]))

;;;; Tests
(check-expect (stop? WORLD-INIT) #false)
(check-expect (stop? (make-world SHIP-INIT INVADERS-INIT empty
                                 (cons (make-posn 240 480) empty))) #true)
(check-expect (stop? WORLD-TEST-2) #false)

;;;; Signature: last-scene : World -> Image
;;;; Purpose: Display appropriate end game message depending on whether the
;;;;          player won or lost.

;;;; Examples
;; (last-scene WORLD-INIT)
;; => (place-image (text "Invaders Win!" 36 "red") (/ WIDTH 2)
;;                 (/ HEIGHT 2) BACKGROUND)
;; (last-scene (make-world SHIP-INIT INVADERS-INIT empty
;;                         (cons (make-posn 240 480) empty)))
;; => (place-image (text "Invaders Win!" 36 "red") (/ WIDTH 2)
;;                 (/ HEIGHT 2) BACKGROUND)
;; (last-scene (make-world SHIP-INIT empty empty empty))
;; => (place-image (text "You Win!" 36 "indigo") (/ WIDTH 2)
;;                 (/ HEIGHT 2) BACKGROUND)

;;;; Strategy:
(define (last-scene a-world)
  (cond
    [(won? a-world) (place-image (text "You Win!" 36 "indigo")
                                 (/ WIDTH 2) (/ HEIGHT 2)
                                 BACKGROUND)]
    [else (place-image (text "Invaders Win!" 36 "red")
                       (/ WIDTH 2) (/ HEIGHT 2) BACKGROUND)]))

;;;; Tests
(check-expect (last-scene WORLD-INIT)
              (place-image (text "Invaders Win!" 36 "red") (/ WIDTH 2)
                           (/ HEIGHT 2) BACKGROUND))
(check-expect (last-scene (make-world SHIP-INIT INVADERS-INIT empty
                                      (cons (make-posn 240 480) empty)))
              (place-image (text "Invaders Win!" 36 "red") (/ WIDTH 2)
                           (/ HEIGHT 2) BACKGROUND))
(check-expect (last-scene (make-world SHIP-INIT empty empty empty))
              (place-image (text "You Win!" 36 "indigo") (/ WIDTH 2)
                           (/ HEIGHT 2) BACKGROUND))

(big-bang WORLD-INIT (on-tick update-world 0.1) (on-draw world-draw)
          (on-key fire-or-change-direction) (stop-when stop? last-scene))
