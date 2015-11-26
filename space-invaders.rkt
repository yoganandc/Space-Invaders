;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname assignment-8) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)

;;;; ------------------ CONSTANTS ------------------

(define WIDTH 500) 
(define HEIGHT 500)
(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define MAX-SHIP-BULLETS 3)
(define MAX-INVADER-BULLETS 10)

(define SHIP-WIDTH 25)
(define SHIP-HEIGHT 15)
(define SHIP-POSX 250)
(define SHIP-POSY 480)
(define SPACESHIP-IMAGE (rectangle SHIP-WIDTH SHIP-HEIGHT 'solid 'black))

(define INVADER-SIDE 20)
(define INVADER-IMAGE (square INVADER-SIDE 'solid 'red))

(define BULLET-RADIUS 2)
(define SPACESHIP-BULLET-IMAGE (circle BULLET-RADIUS 'solid 'black))
(define INVADER-BULLET-IMAGE (circle BULLET-RADIUS 'solid 'red))

(define SHIP-SPEED 10)
(define BULLET-SPEED 10)
(define INVADER-SPEED 5)

(define MAX-X 420)
(define MIN-X 100)

(define TICKS 10)
(define POINTS-PER-INVADER 5)

;;;; ------------------ DATA DEFINITIONS ------------------

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

(define-struct ship (dir loc rem-lives))
;; A Ship is (make-ship Direction Location NonNegInteger) 
;; INTERP: represent the spaceship with its current direction 
;;         and movement and remaining lives

;;;; Template: ship-fn : Ship -> ???
#; (define (ship-fn a-ship)
     ... (direction-fn (ship-dir a-ship)) ...
     ... (location-fn (ship-loc a-ship))
     ... (ship-rem-lives a-ship) ...)

;; A List of Invaders (LoI) is one of 
;; - empty 
;; - (cons Invader LoI)

;;;; Template: loi-fn : LoI -> ???
#; (define (loi-fn loi)
     (cond
       [(empty? loi) ...]
       [(cons? loi) ... (invader-fn (first loi)) ...
                    ... (loi-fn (rest loi)) ...]))

(define-struct invaders [locations ticks])
;; An Invaders is a (make-invaders LoI PosInteger)
;; INTERP: represents the invaders with the list of their locations,
;;         and the number of ticks to be counted before the invaders
;;         move down by INVADER-SPEED units.

;;;; Template: invaders-fn : Invaders -> ???
#; (define (invaders-fn an-invaders)
     ... (loi-fn (invaders-locations an-invaders)) ...
     ... (invaders-ticks an-invaders) ...)

;; A List of Bullets (LoB) is one of 
;; - empty
;; - (cons Bullet LoB)

;;;; Template: lob-fn : LoB -> ???
#; (define (lob-fn lob)
     (cond
       [(empty? lob) ...]
       [(cons? lob) ... (bullet-fn (first lob)) ...
                    ... (lob-fn (rest lob)) ...]))

(define-struct world (ship invaders ship-bullets invader-bullets score))
;; A World is (make-world Ship Invaders LoB LoB NonNegInteger) 
;; INTERP: represent the ship, the current list of invaders, the inflight
;;         spaceship bullets and the inflight invader bullets, and the current
;;         score.

;;;; Template: world-fn : World -> ???
#; (define (world-fn a-world)
     ... (ship-fn (world-ship a-world)) ...
     ... (invaders-fn (world-invaders a-world)) ...
     ... (lob-fn (world-ship-bullets a-world)) ...
     ... (lob-fn (world-invader-bullets a-world))
     ... (world-score a-world) ...)

;;;; ------------------ INIT CONSTANTS ------------------

(define SHIP-INIT (make-ship 'left (make-posn SHIP-POSX SHIP-POSY) 2))
(define INVADERS-LOCATIONS
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
(define INVADERS-INIT (make-invaders INVADERS-LOCATIONS TICKS))
(define WORLD-INIT (make-world SHIP-INIT INVADERS-INIT empty empty 0))

;;;; ------------------ TEST-RELATED CONSTANTS ------------------

(define SHIP-TEST (make-ship 'right (make-posn 400 480) 1))
(define SHIP-1 (make-ship 'right (make-posn 440 240) 2))
(define SHIP-2 (make-ship 'left (make-posn 80 220) 0))
(define LOB-INVADER (cons (make-posn 100 250)
                          (cons (make-posn 260 300)
                                (cons (make-posn 380 350) empty))))
(define LOB-SPACESHIP (cons (make-posn 120 240)
                            (cons (make-posn 270 310)
                                  (cons (make-posn 390 360)
                                        (cons (make-posn 410 400) empty)))))
(define WORLD-TEST-1 (make-world
                      SHIP-INIT
                      (make-invaders (cons (make-posn 200 100)
                            (cons (make-posn 300 100)
                                  (cons (make-posn 400 100) empty))) 10)
                      (cons (make-posn 250 200)
                            (cons (make-posn 200 -100)
                                  (cons (make-posn 195 95) empty)))
                      (cons (make-posn 200 200) (cons (make-posn 340 600)
                                                      (cons (make-posn 410 270)
                            (cons (make-posn 120 730) empty)))) 80))
(define WORLD-TEST-2 (make-world
                      SHIP-INIT
                      (make-invaders (cons (make-posn 300 100)
                            (cons (make-posn 400 100) empty)) 5)
                      (cons (make-posn 250 200) empty)
                      (cons (make-posn 410 270)
                            (cons (make-posn 200 200) empty)) 120))
(define WORLD-TEST-3 (make-world SHIP-INIT INVADERS-INIT
                                 empty (list (make-posn 250 475)) 100))
(define WORLD-TEST-4 (make-world SHIP-INIT INVADERS-INIT
                                 (list (make-posn 300 300)
                                       (make-posn 400 400))
                                 (list (make-posn 200 200)
                                       (make-posn 245 480)) 40))




;;;; ------------------ RENDER WORLD ------------------




;;;; Signature: rem-lives-draw : NonNegInteger -> Image
;;;; Purpose: given the number of remaining lives, return an image
;;;;          with the number of remaining lives displayed on the lower
;;;;          left hand corner.

;;;; Examples
;; (rem-lives-draw 0)
;; => (place-image/align (text "Lives: 0" 20 "blue")
;;    5 WIDTH 'left 'bottom BACKGROUND))
;; (rem-lives-draw 2)
;; => (place-image/align (text "Lives: 2" 20 "blue")
;;    5 WIDTH 'left 'bottom BACKGROUND))

(define (rem-lives-draw rem-lives)
  (place-image/align
   (text (string-append "Lives: " (number->string rem-lives)) 20 "blue")
   5 WIDTH 'left 'bottom BACKGROUND))

;;;; Tests
(check-expect (rem-lives-draw 0)
              (place-image/align (text "Lives: 0" 20 "blue")
                                 5 WIDTH 'left 'bottom BACKGROUND))
(check-expect (rem-lives-draw 2)
              (place-image/align (text "Lives: 2" 20 "blue")
                                 5 WIDTH 'left 'bottom BACKGROUND))

;;;; Signature: ship-draw : Ship -> Image
;;;; Purpose: given a ship, draw it on the canvas

;;;; Examples
;; (ship-draw SHIP-INIT)
;; => (place-image SPACESHIP-IMAGE 250 480
;;    (place-image/align (text "Lives: 2" 20 "blue")
;;    5 WIDTH 'left 'bottom BACKGROUND))
;; (ship-draw SHIP-TEST)
;; => (place-image SPACESHIP-IMAGE 400 480
;;    (place-image/align (text "Lives: 1" 20 "blue")
;;    5 WIDTH 'left 'bottom BACKGROUND))

(define (ship-draw a-ship)
  (place-image SPACESHIP-IMAGE (posn-x (ship-loc a-ship))
               (posn-y (ship-loc a-ship))
               (rem-lives-draw (ship-rem-lives a-ship))))

;;;; Tests
(check-expect (ship-draw SHIP-INIT)
              (place-image SPACESHIP-IMAGE 250 480
                           (place-image/align (text "Lives: 2" 20 "blue")
                                              5 WIDTH 'left 'bottom
                                              BACKGROUND)))
(check-expect (ship-draw SHIP-TEST)
              (place-image SPACESHIP-IMAGE 400 480
                           (place-image/align (text "Lives: 1" 20 "blue")
                                              5 WIDTH 'left 'bottom
                                              BACKGROUND)))

;;;; Signature: invader-draw : Invader Image -> Image
;;;; Purpose: given an invader and an image, draw invader on image

;;;; Examples
;; (invader-draw (make-posn 200 200) BACKGROUND)
;; => (place-image INVADER-IMAGE 200 200 BACKGROUND)
;; (invader-draw (make-posn 300 300) BACKGROUND)
;; => (place-image INVADER-IMAGE 300 300 BACKGROUND)

(define (invader-draw an-invader bg)
  (place-image INVADER-IMAGE (posn-x an-invader)
               (posn-y an-invader) bg))

;;;; Tests
(check-expect (invader-draw (make-posn 200 200) BACKGROUND)
              (place-image INVADER-IMAGE 200 200 BACKGROUND))
(check-expect (invader-draw (make-posn 300 300) BACKGROUND)
              (place-image INVADER-IMAGE 300 300 BACKGROUND))

;;;; Signature: loi-draw : LoI Image -> Image
;;;; Purpose: given a list of invaders and an image, draw the invaders on given
;;;;          image

;;;; Examples
;; (loi-draw empty BACKGROUND) => BACKGROUND
;; (loi-draw (cons (make-posn 300 300) empty) BACKGROUND)
;; => (place-image INVADER-IMAGE 300 300 BACKGROUND)
;; (loi-draw (cons (make-posn 300 300)
;;           (cons (make-posn 400 400) empty)) BACKGROUND)
;; => (place-image INVADER-IMAGE 300 300
;;    (place-image INVADER-IMAGE 400 400 BACKGROUND))

(define (loi-draw loi bg)
  (foldl invader-draw bg loi))

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

;;;; Signature: spaceship-bullet-draw : Bullet Image -> Image
;;;; Purpose: given a spaceship bullet, and an image, draw the
;;;;          given bullet onto image and return the new image

;;;; Examples
;; (spaceship-bullet-draw (make-posn 200 200) BACKGROUND)
;; => (place-image SPACESHIP-BULLET-IMAGE 200 200 BACKGROUND)
;; (spaceship-bullet-draw (make-posn 300 300) BACKGROUND)
;; => (place-image SPACESHIP-BULLET-IMAGE 300 300 BACKGROUND)

(define (spaceship-bullet-draw a-bullet bg)
  (place-image SPACESHIP-BULLET-IMAGE
               (posn-x a-bullet) (posn-y a-bullet) bg))

;;;; Tests
(check-expect (spaceship-bullet-draw (make-posn 200 200) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 200 200 BACKGROUND))
(check-expect (spaceship-bullet-draw (make-posn 300 300) BACKGROUND)
              (place-image SPACESHIP-BULLET-IMAGE 300 300 BACKGROUND))

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

(define (spaceship-lob-draw lob bg)
  (foldl spaceship-bullet-draw bg lob))

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

;;;; Signature: invader-bullet-draw : Bullet Image -> Image
;;;; Purpose: given a invader bullet, and an image, draw the
;;;;          given bullet onto image and return the new image

;;;; Examples
;; (invader-bullet-draw (make-posn 200 200) BACKGROUND)
;; => (place-image INVADER-BULLET-IMAGE 200 200 BACKGROUND)
;; (invader-bullet-draw (make-posn 300 300) BACKGROUND)
;; => (place-image INVADER-BULLET-IMAGE 300 300 BACKGROUND)

(define (invader-bullet-draw a-bullet bg)
  (place-image INVADER-BULLET-IMAGE
               (posn-x a-bullet) (posn-y a-bullet) bg))

;;;; Tests
(check-expect (invader-bullet-draw (make-posn 200 200) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 200 200 BACKGROUND))
(check-expect (invader-bullet-draw (make-posn 300 300) BACKGROUND)
              (place-image INVADER-BULLET-IMAGE 300 300 BACKGROUND))

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

(define (invader-lob-draw lob bg)
  (foldl invader-bullet-draw bg lob))

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

;;;; Signature: score-draw : NonNegInteger Image -> Image
;;;; Purpose: given a score, and an image, return a new image with the score
;;;;          displayed on the top right corner.

;;;;Examples
;; (score-draw 100 BACKGROUND)
;; => (place-image/align (text "Score: 100" 20 "indigo")
;;                       495 0 'right 'top BACKGROUND)
;; (score-draw 80 (loi-draw INVADERS-LOCATIONS BACKGROUND))
;; => (place-image/align (text "Score: 80" 20 "indigo")
;;                       495 0 'right 'top
;;                       (loi-draw INVADERS-LOCATIONS BACKGROUND))

(define (score-draw a-score bg)
  (place-image/align (text (string-append "Score: " (number->string a-score))
                           20 "indigo") (- WIDTH 5) 0 'right 'top bg))

;;;; Tests
(check-expect (score-draw 100 BACKGROUND)
              (place-image/align (text "Score: 100" 20 "indigo")
                                 495 0 'right 'top BACKGROUND))
(check-expect (score-draw 80 (loi-draw INVADERS-LOCATIONS BACKGROUND))
              (place-image/align (text "Score: 80" 20 "indigo")
                                 495 0 'right 'top
                                 (loi-draw INVADERS-LOCATIONS BACKGROUND)))

;;;; Signature: world-draw : World -> Image 
;;;; Purpose: given a world, draw the world on the canvas

;;;; Examples
;; (world-draw WORLD-TEST-1)
;; => (place-image/align (text "Score: 80" 20 "indigo") 495 0 'right 'top
;;    (place-image INVADER-BULLET-IMAGE 120 730
;;                 (place-image INVADER-BULLET-IMAGE 410 270
;;                              (place-image INVADER-BULLET-IMAGE 340 600
;;                              (place-image INVADER-BULLET-IMAGE 200 200
;;    (place-image SPACESHIP-BULLET-IMAGE 250 200
;;                 (place-image SPACESHIP-BULLET-IMAGE 200 -100
;;                              (place-image SPACESHIP-BULLET-IMAGE 195 95
;;    (place-image INVADER-IMAGE 400 100
;;                 (place-image INVADER-IMAGE 300 100
;;                              (place-image INVADER-IMAGE 200 100
;; (place-image SPACESHIP-IMAGE 250 480
;;              (place-image/align (text "Lives: 2" 20 "blue")
;;                                 5 500 'left 'bottom BACKGROUND)))))))))))))
;; (world-draw WORLD-TEST-2)
;; => (place-image/align (text "Score: 120" 20 "indigo") 495 0 'right 'top
;;    (place-image INVADER-BULLET-IMAGE 200 200
;;                 (place-image INVADER-BULLET-IMAGE 410 270
;;                              (place-image SPACESHIP-BULLET-IMAGE 250 200
;;    (place-image INVADER-IMAGE 400 100
;;                 (place-image INVADER-IMAGE 300 100
;;                              (place-image SPACESHIP-IMAGE 250 480
;;    (place-image/align (text "Lives: 2" 20 "blue") 5 500 'left 'bottom)))))))

(define (world-draw a-world)
  (score-draw (world-score a-world)
              (invader-lob-draw (world-invader-bullets a-world)
                                (spaceship-lob-draw
                                 (world-ship-bullets a-world)
                                 (loi-draw
                                  (invaders-locations (world-invaders a-world))
                                  (ship-draw
                                   (world-ship a-world)))))))

;;;; Tests
(check-expect (world-draw WORLD-TEST-1)
              (place-image/align
               (text "Score: 80" 20 "indigo") 495 0 'right 'top
                                 (place-image INVADER-BULLET-IMAGE 120 730
                                              (place-image INVADER-BULLET-IMAGE
                                                           410 270
 (place-image INVADER-BULLET-IMAGE 340 600
              (place-image INVADER-BULLET-IMAGE 200 200
                           (place-image SPACESHIP-BULLET-IMAGE 250 200
 (place-image SPACESHIP-BULLET-IMAGE 200 -100
              (place-image SPACESHIP-BULLET-IMAGE 195 95
                           (place-image INVADER-IMAGE 400 100
                                        (place-image INVADER-IMAGE 300 100
 (place-image INVADER-IMAGE 200 100
              (place-image SPACESHIP-IMAGE 250 480
                           (place-image/align (text "Lives: 2" 20 "blue")
                                              5 500 'left 'bottom
                                              BACKGROUND))))))))))))))
(check-expect (world-draw WORLD-TEST-2)
              (place-image/align
               (text "Score: 120" 20 "indigo") 495 0 'right 'top
               (place-image INVADER-BULLET-IMAGE 200 200
                            (place-image INVADER-BULLET-IMAGE 410 270
 (place-image SPACESHIP-BULLET-IMAGE 250 200
              (place-image INVADER-IMAGE 400 100
                           (place-image INVADER-IMAGE 300 100
 (place-image SPACESHIP-IMAGE 250 480
              (place-image/align (text "Lives: 2" 20 "blue")
                                 5 500 'left 'bottom BACKGROUND)))))))))



               
;;;; ------------------ MOVE SPACESHIP ------------------




;;;; Signature: move-spaceship-left : Ship -> Ship
;;;; Purpose: given a ship, return a new ship that has moved left by SHIP-SPEED
;;;;          units

;;;; Examples
;; (move-spaceship-left SHIP-INIT)
;; => (make-ship 'left (make-posn 240 480) 2)
;; (move-spaceship-left SHIP-1)
;; => (make-ship 'right (make-posn 430 240) 2)
;; (move-spaceship-left 'right SHIP-2)
;; => (make-ship 'left (make-posn 80 220) 0)

(define (move-spaceship-left a-ship)
  (cond
    [(> (posn-x (ship-loc a-ship)) (- MIN-X (/ INVADER-SIDE 2)))
     (make-ship (ship-dir a-ship) (make-posn (- (posn-x (ship-loc a-ship))
                                                SHIP-SPEED)
                                             (posn-y (ship-loc a-ship)))
                (ship-rem-lives a-ship))]
    [else a-ship]))

;;;; Tests
(check-expect (move-spaceship-left SHIP-INIT)
              (make-ship 'left (make-posn 240 480) 2))
(check-expect (move-spaceship-left SHIP-1)
              (make-ship 'right (make-posn 430 240) 2))
(check-expect (move-spaceship-left SHIP-2)
              (make-ship 'left (make-posn 80 220) 0))

;;;; Signature: move-spaceship-right : Ship -> Ship
;;;; Purpose: given a ship, return new ship that has moved right by SHIP-SPEED
;;;;          units

;;;; Examples
;; (move-spaceship-right SHIP-INIT)
;; => (make-ship 'left (make-posn 260 480) 2)
;; (move-spaceship-right SHIP-1)
;; => (make-ship 'right (make-posn 440 240) 2)
;; (move-spaceship-right SHIP-2)
;; => (make-ship 'left (make-posn 90 220) 0)

(define (move-spaceship-right a-ship)
  (cond
    [(< (posn-x (ship-loc a-ship)) (+ MAX-X (/ INVADER-SIDE 2)))
     (make-ship (ship-dir a-ship) (make-posn (+ SHIP-SPEED
                                                (posn-x (ship-loc a-ship)))
                                             (posn-y (ship-loc a-ship)))
                (ship-rem-lives a-ship))]
    [else a-ship]))

;;;; Tests
(check-expect (move-spaceship-right SHIP-INIT)
              (make-ship 'left (make-posn 260 480) 2))
(check-expect (move-spaceship-right SHIP-1)
              (make-ship 'right (make-posn 440 240) 2))
(check-expect (move-spaceship-right SHIP-2)
              (make-ship 'left (make-posn 90 220) 0))

;;;; Signature: move-spaceship : Ship -> Ship
;;;; Purpose: move the given ship in appropriate direction

;;;; Examples
;; (move-spaceship SHIP-INIT)
;; => (make-ship 'left (make-posn 240 480) 2)
;; (move-spaceship SHIP-1)
;; => (make-ship 'right (make-posn 440 240) 2)
;; (move-spaceship SHIP-2)
;; => (move-spaceship 'left (make-posn 80 220) 0)

(define (move-spaceship a-ship)
  (cond
    [(symbol=? 'left (ship-dir a-ship)) (move-spaceship-left a-ship)]
    [(symbol=? 'right (ship-dir a-ship)) (move-spaceship-right a-ship)]))

;;;; Tests
(check-expect (move-spaceship SHIP-INIT)
              (make-ship 'left (make-posn 240 480) 2))
(check-expect (move-spaceship SHIP-1)
              (make-ship 'right (make-posn 440 240) 2))
(check-expect (move-spaceship SHIP-2)
              (make-ship 'left (make-posn 80 220) 0))




;;;; ------------------ MOVE BULLETS ------------------




;;;; Signature: move-spaceship-bullet : Bullet -> Bullet
;;;; Purpose: given a spaceship bullet, return a new bullet that has
;;;;          been shifted up by BULLET-SPEED units

;;;; Examples
;; (move-spaceship-bullet (make-posn 240 230))
;; => (make-posn 240 220)
;; (move-spaceship-bullet (make-posn 390 300))
;; => (make-posn 390 290)

(define (move-spaceship-bullet a-bullet)
  (make-posn (posn-x a-bullet)
             (- (posn-y a-bullet) BULLET-SPEED)))

;;;; Tests
(check-expect (move-spaceship-bullet (make-posn 240 230))
              (make-posn 240 220))
(check-expect (move-spaceship-bullet (make-posn 390 300))
              (make-posn 390 290))

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

(define (move-spaceship-bullets lob)
  (map move-spaceship-bullet lob))

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

;;;; Signature: move-invader-bullet : Bullet -> Bullet
;;;; Purpose: given an invader bullet, return a new bullet that has
;;;;          shifted down by BULLET-SPEED units

;;;; Examples
;; (move-invader-bullet (make-posn 240 230))
;; => (make-posn 240 240)
;; (move-invader-bullet (make-posn 390 300))
;; => (make-posn 390 310)

(define (move-invader-bullet a-bullet)
  (make-posn (posn-x a-bullet)
             (+ BULLET-SPEED (posn-y a-bullet))))

;;;; Tests
(check-expect (move-invader-bullet (make-posn 240 230))
              (make-posn 240 240))
(check-expect (move-invader-bullet (make-posn 390 300))
              (make-posn 390 310))

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

(define (move-invader-bullets lob)
  (map move-invader-bullet lob))

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




;;;; ------------------ FIRE RANDOM INVADER BULLET ------------------




;;;; Signature: num-elements: LoB | LoI -> NonNegInteger
;;;; Purpose: given a list, return the number of elements in the list

;;;; Examples
;; (num-elements empty) => 0
;; (num-elements LOB-INVADER) => 3
;; (num-elements INVADERS-LOCATIONS) => 36

(define (num-elements a-list)
  (cond
    [(empty? a-list) 0]
    [(cons? a-list) (+ 1 (num-elements (rest a-list)))]))

;;;; Tests
(check-expect (num-elements empty) 0)
(check-expect (num-elements LOB-INVADER) 3)
(check-expect (num-elements INVADERS-LOCATIONS) 36)

;;;; Signature: element-at: NonNegInteger LoB | LoI -> Bullet | Invader
;;;; Purpose: given a list and an index, return element at given index
;;;; WHERE: given index is <= (num-elements list)

;;;; Examples
;; (element-at 23 INVADERS-LOCATIONS) => (make-posn 260 80)
;; (element-at 2 LOB-SPACESHIP) => (make-posn 270 310)

(define (element-at index a-list)
  (cond
    [(= index 1) (first a-list)]
    [else (element-at (- index 1) (rest a-list))]))

;;;; Tests
(check-expect (element-at 23 INVADERS-LOCATIONS) (make-posn 260 80))
(check-expect (element-at 2 LOB-SPACESHIP) (make-posn 270 310))

;;;; Signature: invaders-fire-helper : LoB LoI NonNegInteger -> LoB
;;;; Purpose: see invaders-fire. The randomly chosen invader is given by the
;;;;          final argument.

;;;; Examples
;; (invaders-fire-helper LOB-SPACESHIP INVADERS-LOCATIONS 23)
;; => (cons (make-posn 260 80) (cons (make-posn 120 240)
;;    (cons (make-posn 270 310) (cons (make-posn 390 360)
;;    (cons (make-posn 410 400) empty)))))
;; (invaders-fire-helper LOB-INVADER INVADERS-LOCATIONS 11)
;; => (cons (make-posn 140 50) (cons (make-posn 100 250)
;;    (cons (make-posn 260 300) (cons (make-posn 380 350) empty))))

(define (invaders-fire-helper lob loi index)
  (cons (make-posn (posn-x (element-at index loi))
                   (posn-y (element-at index loi))) lob))

;;;; Tests
(check-expect (invaders-fire-helper LOB-SPACESHIP INVADERS-LOCATIONS 23)
              (cons (make-posn 260 80)
                    (cons (make-posn 120 240)
                          (cons (make-posn 270 310)
                                (cons (make-posn 390 360)
                                      (cons (make-posn 410 400) empty))))))
(check-expect (invaders-fire-helper LOB-INVADER INVADERS-LOCATIONS 11)
              (cons (make-posn 140 50)
                    (cons (make-posn 100 250)
                          (cons (make-posn 260 300)
                                (cons (make-posn 380 350) empty)))))

;;;; Signature: invaders-fire : LoB LoI -> LoB
;;;; Purpose: given a list of bullets, and a list of invaders,
;;;;          return a new list of bullets where a random invader
;;;;          fires a new bullet
;;;; WHERE: given list of invaders is non-empty

;;;; Examples
;; (invaders-fire empty INVADERS-LOCATIONS
;; => (local ((define index (+ 1 (random 36))))
;;    (cons (make-posn (posn-x (element-at index INVADERS-LOCATIONS))
;;                     (posn-y (element-at index INVADERS-LOCATIONS)))
;;          empty)))
;; (invaders-fire LOB-SPACESHIP INVADERS-LOCATIONS
;; => (local ((define index (+ 1 (random 36))))
;;    (cons (make-posn (posn-x (element-at index INVADERS-LOCATIONS))
;;                     (posn-y (element-at index INVADERS_LOCATIONS)))
;;          LOB-SPACESHIP)))
;; (invaders-fire INVADERS-LOCATIONS LOB-INVADER) => INVADERS-LOCATIONS

(define (invaders-fire lob loi)
  (cond
    [(>= (num-elements lob) MAX-INVADER-BULLETS) lob]
    [else (invaders-fire-helper lob loi (+ 1 (random (num-elements loi))))]))

;;;; Tests
(check-random (invaders-fire empty INVADERS-LOCATIONS)
              (local ((define index (+ 1 (random 36))))
                (cons (make-posn (posn-x (element-at index INVADERS-LOCATIONS))
                                 (posn-y (element-at index INVADERS-LOCATIONS)))
                      empty)))
(check-random (invaders-fire LOB-SPACESHIP INVADERS-LOCATIONS)
              (local ((define index (+ 1 (random 36))))
                (cons (make-posn (posn-x (element-at index INVADERS-LOCATIONS))
                                 (posn-y (element-at index INVADERS-LOCATIONS)))
                      LOB-SPACESHIP)))
(check-expect (invaders-fire INVADERS-LOCATIONS LOB-INVADER) INVADERS-LOCATIONS)




;;;; ------------------ UDPATE INVADERS ------------------




;;;; Signature: bullet-invader-collision? : Posn -> [Posn -> Boolean]
;;;; Purpose: given a posn representing an invader or bullet, return a function
;;;;          that takes in a posn (either a bullet or invader) and returns
;;;;          #true if the given bullet collided with the invader. Else,
;;;;          return #false.
(define (bullet-invader-collision? posn1)
  (lambda (posn2)
    (cond
      [(and (<= (abs (- (posn-x posn1) (posn-x posn2)))
                (+ BULLET-RADIUS (/ INVADER-SIDE 2)))
            (<= (abs (- (posn-y posn1) (posn-y posn2)))
                (+ BULLET-RADIUS (/ INVADER-SIDE 2)))) #true]
      [else #false])))

;;;; Tests
(check-expect ((bullet-invader-collision? (make-posn 200 200))
               (make-posn 300 300)) #false)
(check-expect ((bullet-invader-collision? (make-posn 250 250))
               (make-posn 260 260)) #true)
(check-expect ((bullet-invader-collision? (make-posn 400 400))
               (make-posn 410 400)) #true)

;;;; Signature: invader-not-hit? : LoB -> [Invader -> Boolean]
;;;; Purpose: given a list of bullets, return a function that takes in an
;;;;          invader and returns #true if none of the bullets in given list
;;;;          have collided with the given invader. Else, returns #false.
(define (invader-not-hit? lob)
  (lambda (an-invader)
    (not (ormap (bullet-invader-collision? an-invader) lob))))

;;;; Tests
(check-expect ((invader-not-hit? LOB-SPACESHIP) (make-posn 120 250))
              #false)
(check-expect ((invader-not-hit? LOB-INVADER) (make-posn 370 360))
              #false)
(check-expect ((invader-not-hit? LOB-INVADER) (make-posn 240 240))
              #true)

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

(define (update-invaders loi lob)
  (filter (invader-not-hit? lob) loi))

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




;;;; ------------------ MOVE INVADERS ------------------




;;;; Signature: move-invader : Invader -> Invader
;;;; Purpose: given an invader, move it down by INVADERS-SPEED
;;;;          units and return the new invader

;;;; Examples
;; (move-invader (make-posn 200 200)) => (make-posn 200 210)
;; (move-invader (make-posn 300 250)) => (make-posn 300 260)
;; (move-invader (make-posn 10 20)) => (make-posn 10 30)

(define (move-invader an-invader)
  (make-posn (posn-x an-invader)
             (+ 10 (posn-y an-invader))))

;;;; Tests
(check-expect (move-invader (make-posn 200 200)) (make-posn 200 210))
(check-expect (move-invader (make-posn 300 250)) (make-posn 300 260))
(check-expect (move-invader (make-posn 10 20)) (make-posn 10 30))

;;;; Signature: move-loi : LoI -> LoI
;;;; Purpose: given a list of invaders, return a new list of invaders
;;;;          with all invaders having moved down by INVADERS-SPEED units

;;;; Examples
;; (move-loi LOB-INVADER)
;; => (list (make-posn 100 260) (make-posn 260 310) (make-posn 380 360))
;; (move-loi LOB-SPACESHIP)
;; => (list (make-posn 120 250) (make-posn 270 320)
;;          (make-posn 390 370) (make-posn 410 410))

(define (move-loi loi)
  (map move-invader loi))

;;;; Tests
(check-expect (move-loi LOB-INVADER)
              (list (make-posn 100 260) (make-posn 260 310)
                    (make-posn 380 360)))
(check-expect (move-loi LOB-SPACESHIP)
              (list (make-posn 120 250) (make-posn 270 320)
                    (make-posn 390 370) (make-posn 410 410)))

;;;; Signature: move-invaders : Invaders -> Invaders
;;;; Purpose: given an invaders, move all the invaders down by
;;;;          INVADERS-SPEED unit if the tick is zero, else count
;;;;          down by one. Return the new invaders.

;;;; Examples
;; (move-invaders (make-invaders empty 0)) => (make-invaders empty TICKS)
;; (move-invaders (make-invaders LOB-INVADERS 9)
;; => (make-invaders LOB-INVADERS 8)
;; (move-invaders (make-invaders LOB-INVADERS 0)
;; => (make-invaders (list (make-posn 100 260) (make-posn 260 310)
;;                         (make-posn 380 360)) 10)

(define (move-invaders an-invaders)
  (cond
    [(= 0 (invaders-ticks an-invaders))
     (make-invaders
      (move-loi (invaders-locations an-invaders)) TICKS)]
    [else (make-invaders
           (invaders-locations an-invaders)
           (- (invaders-ticks an-invaders) 1))]))

;;;; Tests
(check-expect (move-invaders (make-invaders empty 0))
              (make-invaders empty TICKS))
(check-expect (move-invaders (make-invaders LOB-INVADER 9))
              (make-invaders LOB-INVADER 8))
(check-expect (move-invaders (make-invaders LOB-INVADER 0))
              (make-invaders (list (make-posn 100 260) (make-posn 260 310)
                                   (make-posn 380 360)) 10))




;;;; ------------------ UDPATE SPACESHIP BULLETS ------------------




;;;; Signature: within-bounds? : Bullet -> Boolean
;;;; Purpose: given a bullet, return #true if it is still within bounds, else
;;;;          return #false

;;;; Examples
;; (within-bounds? (make-posn 500 500)) => #true
;; (within-bounds? (make-posn 0 0)) => #true
;; (within-bounds? (make-posn 480 380)) => #true
;; (within-bounds? (make-posn 501 399)) => #false
;; (within-bounds? (make-posn 2 503)) => #false

(define (within-bounds? a-bullet)
  (cond
    [(and (and (>= (posn-x a-bullet) 0) (<= (posn-x a-bullet) WIDTH))
          (and (>= (posn-y a-bullet) 0) (<= (posn-y a-bullet) HEIGHT))) #true]
    [else #false]))

;;;; Tests
(check-expect (within-bounds? (make-posn 500 500)) #true)
(check-expect (within-bounds? (make-posn 0 0)) #true)
(check-expect (within-bounds? (make-posn 480 380)) #true)
(check-expect (within-bounds? (make-posn 501 399)) #false)
(check-expect  (within-bounds? (make-posn 2 503)) #false)

;;;; Signature: remove-out-of-bounds: LoB -> LoB
;;;; Purpose: Given a list of bullets, return a new list where bullets
;;;;          that have gone out of bounds have been removed

;;;; Examples
;; (remove-out-of-bounds empty) => empty
;; (remove-out-of-bounds (cons (make-posn 200 570) empty)) => empty
;; (remove-out-of-bounds (cons (make-posn 200 400) (cons (make-posn 230 530)
;;                       (cons (make-posn 470 110) empty))
;; => (cons (make-posn 200 400) (cons (make-posn 470 110) empty))

(define (remove-out-of-bounds lob)
  (filter within-bounds? lob))

;;;; Tests
(check-expect (remove-out-of-bounds empty) empty)
(check-expect (remove-out-of-bounds (cons (make-posn 200 570) empty)) empty)
(check-expect (remove-out-of-bounds (cons (make-posn 200 400)
                                          (cons (make-posn 230 530)
                                                (cons (make-posn 470 110)
                                                      empty))))
              (cons (make-posn 200 400) (cons (make-posn 470 110) empty)))

;;;; Signature: bullet-not-hit-invader? : LoI -> [Bullet -> Boolean]
;;;; Purpose: given a list of invaders, return a function that takes in a bullet
;;;;          and returns #true if the bullet did not hit any of the invaders
;;;;          given in the list. Else, the function returns #false.
(define (bullet-not-hit-invader? loi)
  (lambda (a-bullet)
    (not (ormap (bullet-invader-collision? a-bullet) loi))))

;;;; Tests
(check-expect ((bullet-not-hit-invader? INVADERS-LOCATIONS) (make-posn 140 20))
              #false)
(check-expect ((bullet-not-hit-invader? INVADERS-LOCATIONS) (make-posn 140 140))
              #true)
(check-expect ((bullet-not-hit-invader? LOB-SPACESHIP) (make-posn 110 230))
              #false)

;;;; Signature: update-spaceship-bullets: LoB LoI -> LoB
;;;; Purpose: given a list of bullets and a list of invaders,
;;;;          remove all bullets which are out of bounds or have
;;;;          hit and invader, and return new list

;;;; Examples
;; (update-spaceship-bullets empty empty) => empty
;; (update-spaceship-bullets LOB-SPACESHIP empty)
;; => (cons (make-posn 120 240) (cons (make-posn 270 310)
;;    (cons (make-posn 390 360) (cons (make-posn 410 400) empty))))
;; (update-spaceship-bullets empty INVADERS-INIT) => empty
;; (update-spaceship-bullets LOB-SPACESHIP (cons (make-posn 200 200)
;;                               (cons (make-posn 380 360) empty)))
;; => (cons (make-posn 120 240) (cons (make-posn 270 310)
;;    (cons (make-posn 410 400) empty)))
;; (update-spaceship-bullets (cons (make-posn 230 730) LOB-SPACESHIP) empty)
;; => (cons (make-posn 120 240) (cons (make-posn 270 310)
;;    (cons (make-posn 390 360) (cons (make-posn 410 400) empty))))
;; (update-spaceship-bullets (cons (make-posn 230 730) LOB-SPACESHIP)
;;                 (cons (make-posn 200 200)
;;                 (cons (make-posn 380 360) empty)))
;; => (cons (make-posn 120 240) (cons (make-posn 270 310)
;;    (cons (make-posn 410 400) empty)))

(define (update-spaceship-bullets lob loi)
  (remove-out-of-bounds (filter (bullet-not-hit-invader? loi) lob)))

;;;; Tests
(check-expect (update-spaceship-bullets empty empty) empty)
(check-expect (update-spaceship-bullets LOB-SPACESHIP empty)
              (cons (make-posn 120 240)
                    (cons (make-posn 270 310)
                          (cons (make-posn 390 360)
                                (cons (make-posn 410 400) empty)))))
(check-expect (update-spaceship-bullets empty INVADERS-INIT) empty)
(check-expect (update-spaceship-bullets LOB-SPACESHIP
                              (cons (make-posn 200 200)
                                    (cons (make-posn 380 360) empty)))
              (cons (make-posn 120 240)
                    (cons (make-posn 270 310)
                          (cons (make-posn 410 400) empty))))
(check-expect (update-spaceship-bullets (cons (make-posn 230 730)
                                              LOB-SPACESHIP) empty)
              (cons (make-posn 120 240)
                    (cons (make-posn 270 310)
                          (cons (make-posn 390 360)
                                (cons (make-posn 410 400) empty)))))
(check-expect (update-spaceship-bullets (cons (make-posn 230 730) LOB-SPACESHIP)
                              (cons (make-posn 200 200)
                                    (cons (make-posn 380 360) empty)))
              (cons (make-posn 120 240)
                    (cons (make-posn 270 310)
                          (cons (make-posn 410 400) empty))))




;;;; ------------------ UDPATE INVADER BULLETS ------------------




;;;; Signature: bullet-not-hit-ship? : Ship -> [Bullet -> Boolean]
;;;; Purpose: given a ship, return a function that returns #false if the given
;;;;          ship and given bullet collided. Else, return #true.
(define (bullet-not-hit-ship? a-ship)
  (lambda (a-bullet)
    (cond
      [(and (<= (abs (- (posn-x (ship-loc a-ship)) (posn-x a-bullet)))
                (+ BULLET-RADIUS (/ SHIP-WIDTH 2)))
            (<= (abs (- (posn-y (ship-loc a-ship)) (posn-y a-bullet)))
                (+ BULLET-RADIUS (/ SHIP-HEIGHT 2)))) #false]
      [else #true])))

;;;; Tests
(check-expect ((bullet-not-hit-ship? SHIP-INIT) (make-posn 240 475)) #false)
(check-expect ((bullet-not-hit-ship? SHIP-1) (make-posn 200 300)) #true)
(check-expect ((bullet-not-hit-ship? SHIP-2) (make-posn 80 220)) #false)

;;;; Signature: update-invader-bullets : LoB Ship -> LoB
;;;; Purpose: given a list of invader bullets, return the list of invader
;;;;          bullets that have not gone out of bounds or hit the given ship

;;;; Examples
;; (update-invader-bullets empty SHIP-INIT) => empty
;; (update-invader-bullets (list (make-posn 200 400) (make-posn 100 150)
;;                               (make-posn 80 220) (make-posn 300 510)) SHIP-2)
;; => (list (make-posn 200 400) (make-posn 100 150))
;; (update-invader-bullets (list (make-posn 300 300)
;;                               (make-posn 200 230)) SHIP-1)
;; => (list (make-posn 300 300) (make-posn 200 230))

(define (update-invader-bullets lob a-ship)
  (remove-out-of-bounds (filter (bullet-not-hit-ship? a-ship) lob)))

;;;; Tests
(check-expect (update-invader-bullets (list (make-posn 200 400)
                                            (make-posn 100 150)
                                            (make-posn 80 220)
                                            (make-posn 300 510)) SHIP-2)
              (list (make-posn 200 400) (make-posn 100 150)))
(check-expect (update-invader-bullets (list (make-posn 300 300)
                                            (make-posn 200 230)) SHIP-1)
              (list (make-posn 300 300) (make-posn 200 230)))
(check-expect (update-invader-bullets empty SHIP-INIT) empty)




;;;; ------------------ UDPATE REMAINING LIVES ------------------




;;;; Signature: bullet-hit-ship? : Ship -> [Bullet -> Boolean]
;;;; Purpose: given a ship, return a function that takes in a bullet
;;;;          and returns #true if the bullet and ship hit each other.
;;;;          Else, return #false.
(define (bullet-hit-ship? a-ship)
  (lambda (a-bullet)
    (cond
      [((bullet-not-hit-ship? a-ship) a-bullet) #false]
      [else #true])))

;;;; Tests
(check-expect ((bullet-hit-ship? SHIP-INIT) (make-posn 240 475)) #true)
(check-expect ((bullet-hit-ship? SHIP-1) (make-posn 200 300)) #false)
(check-expect ((bullet-hit-ship? SHIP-2) (make-posn 80 220)) #true)

;;;; Signature: ship-hit? : Ship LoB -> Boolean
;;;; Purpose: given a ship and a list of bullets, return #true if the
;;;;          ship has been hit, else return #false

;;;; Examples
;; (ship-hit? SHIP-INIT empty) => #false
;; (ship-hit? SHIP-2 (cons (make-posn 200 240) empty)) => #false
;; (ship-hit? SHIP-1 (cons (make-posn 430 235)
;;                  (cons (make-posn 200 240) empty))) => #true

(define (ship-hit? a-ship lob)
  (ormap (bullet-hit-ship? a-ship) lob))

;;;; Tests
(check-expect (ship-hit? SHIP-INIT empty) #false)
(check-expect (ship-hit? SHIP-2 (cons (make-posn 200 240) empty)) #false)
(check-expect (ship-hit? SHIP-1 (cons (make-posn 430 235)
                                     (cons (make-posn 200 240) empty))) #true)

;;;; Signature: remove-life-if-hit : World -> World
;;;; Purpose: given a world, if the ship in world is hit by any of the bullets
;;;;          in given list, return a new world which has a ship with one life
;;;;          removed. Else, return the same ship

;;;; Examples
;; (remove-life-if-hit WORLD-INIT) => WORLD-INIT
;; (remove-life-if-hit WORLD-TEST-3)
;; => (make-world (make-ship 'left (make-posn 250 480) 1)
;;                INVADERS-INIT empty (list (make-posn 250 475)) 100)
;; (remove-life-if-hit WORLD-TEST-4)
;; => (make-world (make-ship 'left (make-posn 250 480) 1)
;;                INVADERS-INIT (list (make-posn 300 300) (make-posn 400 400))
;;                (list (make-posn 200 200) (make-posn 245 480)) 40)

(define (remove-life-if-hit a-world)
  (cond
    [(ship-hit? (world-ship a-world) (world-invader-bullets a-world))
     (make-world (make-ship (ship-dir (world-ship a-world))
                            (ship-loc (world-ship a-world))
                            (- (ship-rem-lives (world-ship a-world)) 1))
                 (world-invaders a-world)
                 (world-ship-bullets a-world)
                 (world-invader-bullets a-world)
                 (world-score a-world))]
    [else a-world]))

;;;; Tests
(check-expect (remove-life-if-hit WORLD-TEST-3)
              (make-world (make-ship 'left (make-posn 250 480) 1)
                          INVADERS-INIT empty (list (make-posn 250 475)) 100))
(check-expect (remove-life-if-hit WORLD-TEST-4)
              (make-world (make-ship 'left (make-posn 250 480) 1)
                          INVADERS-INIT (list (make-posn 300 300)
                                              (make-posn 400 400))
                          (list (make-posn 200 200) (make-posn 245 480)) 40))
(check-expect (remove-life-if-hit WORLD-INIT) WORLD-INIT)




;;;; ------------------ UPDATE SCORE ------------------




;;;; Signature: points-for-hit-or-miss : LoB ->
;;;;                                    [Invader NonNegInteger -> NonNegInteger]
;;;; Purpose: given a list of bullets, return a function that consumes an
;;;;          invader and an intital score and returns score with five points
;;;;          added if the invader was hit by any of the bullets in the given
;;;;          list. Else, returns the given score.
(define (points-for-hit-or-miss lob)
  (lambda (an-invader acc)
    (cond
      [((invader-not-hit? lob) an-invader) acc]
      [else (+ POINTS-PER-INVADER acc)])))

;;;; Tests
(check-expect ((points-for-hit-or-miss LOB-SPACESHIP)
               (make-posn 120 240) 5) 10)
(check-expect ((points-for-hit-or-miss LOB-INVADER)
               (make-posn 200 200) 20) 20)
(check-expect ((points-for-hit-or-miss LOB-INVADER)
               (make-posn 380 360) 35) 40)

;;;; Signature: update-score-helper : NonNegInteger LoI LoB -> NonNegInteger
;;;; Purpose: given a score, list of invaders, and a list of bullets, return the
;;;;          new score which adds five points for each invader hit to the
;;;;          initial score.
(define (update-score-helper a-score loi lob)
  (foldl (points-for-hit-or-miss lob) a-score loi))

;;;; Tests
(check-expect (update-score-helper 20 INVADERS-LOCATIONS LOB-SPACESHIP) 20)
(check-expect (update-score-helper 50 INVADERS-LOCATIONS
                                   (list (make-posn 140 80)
                                         (make-posn 420 50)
                                         (make-posn 220 110)
                                         (make-posn 400 400)
                                         (make-posn 100 100))) 70)
(check-expect (update-score-helper 110 INVADERS-LOCATIONS
                                   (list (make-posn 300 300)
                                         (make-posn 250 250)
                                         (make-posn 180 110))) 115)

;;;; Signature: update-score : World -> World
;;;; Purpose: given a world, update score to reflect if any of the invaders
;;;;          have been hit.
(define (update-score a-world)
  (make-world (world-ship a-world)
              (world-invaders a-world)
              (world-ship-bullets a-world)
              (world-invader-bullets a-world)
              (update-score-helper (world-score a-world)
                                   (invaders-locations (world-invaders a-world))
                                   (world-ship-bullets a-world))))

;;;; Tests
(check-expect (update-score WORLD-INIT) WORLD-INIT)
(check-expect (update-score (make-world SHIP-INIT INVADERS-INIT LOB-SPACESHIP
                                        LOB-INVADER 20))
              (make-world SHIP-INIT INVADERS-INIT LOB-SPACESHIP LOB-INVADER 20))
(check-expect (update-score (make-world SHIP-INIT INVADERS-INIT
                                        (list (make-posn 140 80)
                                              (make-posn 420 50)
                                              (make-posn 220 110)
                                              (make-posn 400 400)
                                              (make-posn 100 100))
                                        LOB-INVADER 50))
              (make-world SHIP-INIT INVADERS-INIT (list (make-posn 140 80)
                                                        (make-posn 420 50)
                                                        (make-posn 220 110)
                                                        (make-posn 400 400)
                                                        (make-posn 100 100))
                          LOB-INVADER 70))
(check-expect (update-score (make-world SHIP-INIT INVADERS-INIT
                                        (list (make-posn 300 300)
                                              (make-posn 250 250)
                                              (make-posn 180 110))
                                        LOB-INVADER 110))
              (make-world SHIP-INIT INVADERS-INIT (list (make-posn 300 300)
                                                        (make-posn 250 250)
                                                        (make-posn 180 110))
                          LOB-INVADER 115))



;;;; ------------------ UPDATE WORLD ------------------




;;;; Signature: remove-hits-and-out-of-bounds : World -> World
;;;; Purpose: given a world, return a new world with all hit invaders
;;;;          and all hit and out-of-bounds bullets removed
(define (remove-hits-and-out-of-bounds a-world)
  (make-world (world-ship a-world)
              (make-invaders (update-invaders
                              (invaders-locations (world-invaders a-world))
                              (world-ship-bullets a-world))
                             (invaders-ticks (world-invaders a-world)))
              (update-spaceship-bullets (world-ship-bullets a-world)
                                        (invaders-locations
                                         (world-invaders a-world)))
              (update-invader-bullets (world-invader-bullets a-world)
                                      (world-ship a-world))
              (world-score a-world)))

;;;; Tests
(check-expect (remove-hits-and-out-of-bounds WORLD-INIT) WORLD-INIT)
(check-expect (remove-hits-and-out-of-bounds WORLD-TEST-1)
              (make-world SHIP-INIT
                          (make-invaders (list (make-posn 300 100)
                                               (make-posn 400 100)) 10)
                          (list (make-posn 250 200))
                          (list (make-posn 200 200) (make-posn 410 270)) 80))

;;;; Signature: update-world : World -> World
;;;; Purpose: given a world, return a new world after unit time
;;;;          has passed
(define (update-world a-world)
  (remove-hits-and-out-of-bounds
   (update-score
    (remove-life-if-hit
     (make-world (move-spaceship (world-ship a-world))
                 (move-invaders (world-invaders a-world)) 
                 (move-spaceship-bullets (world-ship-bullets a-world))
                 (invaders-fire
                  (move-invader-bullets (world-invader-bullets a-world))
                  (invaders-locations (world-invaders a-world)))
                 (world-score a-world))))))

;;;; Tests
(check-random (update-world WORLD-INIT)
              (local ((define index (+ 1 (random 36))))
                (make-world (make-ship 'left (make-posn 240 480) 2)
                            (make-invaders INVADERS-LOCATIONS 9)
                            empty
                            (list
                             (make-posn
                              (posn-x (element-at index INVADERS-LOCATIONS))
                              (posn-y (element-at index INVADERS-LOCATIONS))))
                            0)))
(check-random (update-world WORLD-TEST-2)
              (local ((define index (+ 1 (random 2)))
                      (define INVADERS-TEST (list (make-posn 300 100)
                                                  (make-posn 400 100))))
                (make-world (make-ship 'left (make-posn 240 480) 2)
                            (make-invaders INVADERS-TEST 4)
                            (list (make-posn 250 190))
                            (list
                             (make-posn
                              (posn-x (element-at index INVADERS-TEST))
                              (posn-y (element-at index INVADERS-TEST)))
                             (make-posn 410 280)
                             (make-posn 200 210)) 120)))




;;;; ------------------ HANDLE KEY EVENTS ------------------




;;;; Signature: toggle-direction : Ship -> Ship
;;;; Purpose: given a ship, change the ship's direction

;;;; Examples
;; (toggle-direction SHIP-INIT) => (make-ship 'right (make-posn 250 480) 2)
;; (toggle-direction (make-ship 'left (make-posn 200 300) 1))
;; => (make-ship 'right (make-posn 200 300) 1)

(define (toggle-direction a-ship)
  (cond
    [(symbol=? (ship-dir a-ship) 'left)
     (make-ship 'right (make-posn (posn-x (ship-loc a-ship))
                                  (posn-y (ship-loc a-ship)))
                (ship-rem-lives a-ship))]
    [else (make-ship 'left (make-posn (posn-x (ship-loc a-ship))
                                      (posn-y (ship-loc a-ship)))
                     (ship-rem-lives a-ship))]))

;;;; Tests
(check-expect (toggle-direction SHIP-INIT)
              (make-ship 'right (make-posn 250 480) 2))
(check-expect (toggle-direction (make-ship 'right (make-posn 200 300) 1))
              (make-ship 'left (make-posn 200 300) 1))

;;;; Signature: change-direction-to-left : World -> World
;;;; Purpose: given a world, change the direction of its ship
;;;;          to the left direction

;;;; Examples
;; (change-direction-to-left WORLD-INIT) => WORLD-INIT
;; (change-to-direction-to-left (make-world (make-ship 'right
;;                                                     (make-posn 250 480) 2)
;;                                          INVADERS-INIT empty empty 0))
;; => WORLD-INIT

(define (change-direction-to-left a-world)
  (cond
    [(symbol=? (ship-dir (world-ship a-world)) 'left) a-world]
    [else (make-world (toggle-direction (world-ship a-world))
                      (world-invaders a-world)
                      (world-ship-bullets a-world)
                      (world-invader-bullets a-world)
                      (world-score a-world))]))

;;;; Tests
(check-expect (change-direction-to-left WORLD-INIT) WORLD-INIT)
(check-expect (change-direction-to-left
               (make-world (make-ship 'right (make-posn 250 480) 2)
                           INVADERS-INIT
                           empty empty 0))
              WORLD-INIT)

;;;; Signature: change-direction-to-right : World -> World
;;;; Purpose: given a world, change the direction of its ship
;;;;          to the right direction

;;;; Examples
;; (change-direction-to-right WORLD-INIT)
;; => (make-world (make-ship 'right (make-posn 250 480) 2) INVADERS-INIT
;;                empty empty 0)
;; (change-to-direction-to-right (make-world (make-ship 'right
;;                                                      (make-posn 250 480) 1)
;;                                           INVADERS-INIT empty empty 100)
;; => (make-world (make-ship 'left (make-posn 250 480) 1) INVADERS-INIT empty
;;                empty 100)

(define (change-direction-to-right a-world)
  (cond
    [(symbol=? (ship-dir (world-ship a-world)) 'right) a-world]
    [else (make-world (toggle-direction (world-ship a-world))
                      (world-invaders a-world)
                      (world-ship-bullets a-world)
                      (world-invader-bullets a-world)
                      (world-score a-world))]))

;;;; Tests
(check-expect (change-direction-to-right WORLD-INIT)
              (make-world (make-ship 'right (make-posn 250 480) 2) INVADERS-INIT
                          empty empty 0))
(check-expect (change-direction-to-right
               (make-world (make-ship 'right (make-posn 250 480) 1)
                           INVADERS-INIT
                           empty empty 100))
              (make-world (make-ship 'right (make-posn 250 480) 1) INVADERS-INIT
                          empty empty 100))

;;;; Signature: spaceship-fire : World -> World
;;;; Purpose: given a world, check if maximum number of bullets
;;;;          have been fired from the spaceship. If yes, return
;;;;          the same world, else fire one more bullet

;;;; Examples
;; (spaceship-fire WORLD-INIT)
;; => (make-world (make-ship 'left (make-posn 250 480) 2) INVADERS-INIT
;;    (cons (make-posn 250 480) empty) empty 0)
;; (spaceship-fire (make-world (make-ship 'left (make-posn 250 480) 2)
;;                             INVADERS-INIT (cons (make-posn 300 300) empty)
;;                             empty 100))
;; => (make-world (make-ship 'left (make-posn 250 480) 2) INVADERS-INIT
;;    (cons (make-posn 250 480) (cons (make-posn 300 300) empty)) empty 100)
;; (spaceship-fire (make-world (make-ship 'left (make-posn 250 480) 1)
;;                             INVADERS-INIT
;;                             (cons (make-posn 100 300)
;;                             (cons (make-posn 300 300)
;;                             (cons (make-posn 400 300) empty))) empty 20))
;; => (make-world (make-ship 'left (make-posn 250 480) 1) INVADERS-INIT
;;    (cons (make-posn 100 300) (cons (make-posn 300 300)
;;    (cons (make-posn 400 300) empty))) empty 20)

(define (spaceship-fire a-world)
  (cond
    [(= (num-elements (world-ship-bullets a-world)) MAX-SHIP-BULLETS)
     a-world]
    [else (make-world (world-ship a-world) (world-invaders a-world)
                      (cons (ship-loc (world-ship a-world))
                            (world-ship-bullets a-world))
                      (world-invader-bullets a-world)
                      (world-score a-world))]))

(check-expect (spaceship-fire WORLD-INIT)
              (make-world (make-ship 'left (make-posn 250 480) 2) INVADERS-INIT
                          (cons (make-posn 250 480) empty) empty 0))
(check-expect (spaceship-fire (make-world (make-ship 'left (make-posn 250 480)
                                                     2)
                                          INVADERS-INIT
                                          (cons (make-posn 300 300) empty)
                                          empty 100))
              (make-world (make-ship 'left (make-posn 250 480) 2) INVADERS-INIT
                          (cons (make-posn 250 480)
                                (cons (make-posn 300 300) empty)) empty 100))
(check-expect (spaceship-fire (make-world (make-ship 'left (make-posn 250 480)
                                                     1)
                                          INVADERS-INIT
                                          (cons (make-posn 100 300)
                                                (cons (make-posn 300 300)
                                                      (cons (make-posn 400 300)
                                                            empty))) empty 20))
              (make-world (make-ship 'left (make-posn 250 480) 1) INVADERS-INIT
                          (cons (make-posn 100 300)
                                (cons (make-posn 300 300)
                                      (cons (make-posn 400 300) empty))) empty
                                                                         20))

;;;; Signature: fire-or-change-direction : World KeyEvent -> World
;;;; Purpose: given a key-event, fire a spaceship if key-event is space, else
;;;;          if keyevent is left or right, change spaceship to that direction

;;;; Examples
;; (fire-or-change-direction WORLD-INIT "left") => WORLD-INIT
;; (fire-or-change-direction WORLD-INIT "right")
;; => (make-world (make-ship 'right (make-posn 250 480) 2)
;;                INVADERS-INIT empty empty 0)
;; (fire-or-change-direction WORLD-INIT " ")
;; => (make-world (make-ship 'left (make-posn 250 480) 2)
;;                INVADERS-INIT (cons (make-posn 250 480) empty) empty 0)
;; (fire-or-change-direction WORLD-INIT "q") => WORLD-INIT
;; (fire-or-change-direction (make-world
;;                           (make-ship 'right (make-posn 250 480) 2)
;;                           INAVDERS-INIT empty empty 0) "left") => WORLD-INIT
;; (fire-or-change-direction (make-world
;;                           (make-ship 'right (make-posn 250 480) 2)
;;                           INVADERS-INIT empty empty 100) "right")
;; => (make-world (make-ship 'right (make-posn 250 480) 2)
;;                INVADERS-INIT empty empty 100)
;; (fire-or-change-direction (make-world (make-ship 'left (make-posn 250 480) 1)
;;                           INVADERS-INIT (cons (make-posn 200 300)
;;                                         (cons (make-posn 300 400)
;;                                         (cons (make-posn 400 450) empty)))
;;                           empty 120) " ")
;; => (make-world (make-ship 'left (make-posn 250 480) 1) INVADERS-INIT
;;                (cons (make-posn 200 300) (cons (make-posn 300 400)
;;                (cons (make-posn 400 450) empty))) empty 120)
(define (fire-or-change-direction a-world key-event)
  (cond
    [(key=? key-event "left") (change-direction-to-left a-world)]
    [(key=? key-event "right") (change-direction-to-right a-world)]
    [(key=? key-event " ") (spaceship-fire a-world)]
    [else a-world]))

;;;; Tests
(check-expect (fire-or-change-direction WORLD-INIT "left") WORLD-INIT)
(check-expect (fire-or-change-direction WORLD-INIT "right")
              (make-world (make-ship 'right (make-posn 250 480) 2)
                          INVADERS-INIT empty empty 0))
(check-expect (fire-or-change-direction WORLD-INIT " ")
              (make-world (make-ship 'left (make-posn 250 480) 2)
                          INVADERS-INIT (cons (make-posn 250 480) empty)
                          empty 0))
(check-expect (fire-or-change-direction WORLD-INIT "q") WORLD-INIT)
(check-expect (fire-or-change-direction
               (make-world (make-ship 'right (make-posn 250 480) 2)
                           INVADERS-INIT empty empty 0) "left") WORLD-INIT)
(check-expect (fire-or-change-direction
               (make-world (make-ship 'right (make-posn 250 480) 2)
                           INVADERS-INIT empty empty 100) "right")
              (make-world (make-ship 'right (make-posn 250 480) 2) INVADERS-INIT
                          empty empty 100))
(check-expect (fire-or-change-direction
               (make-world (make-ship 'left (make-posn 250 480) 1) INVADERS-INIT
                           (cons (make-posn 200 300)
                                 (cons (make-posn 300 400)
                                       (cons (make-posn 400 450) empty)))
                           empty 120)
               " ") (make-world (make-ship 'left (make-posn 250 480) 1)
                                INVADERS-INIT
                                (cons (make-posn 200 300)
                                      (cons (make-posn 300 400)
                                            (cons (make-posn 400 450) empty)))
                                empty 120))




;;;; ------------------ STOP CONDITIONS ------------------




;;;; Signature: invader-reached-bottom? : Invader -> Boolean
;;;; Purpose: given an invader, return #true if the invader has reached the
;;;;          bottom of the screen. Else, return #false.

;;;; Examples
;; (invader-reached-bottom? (make-posn 200 300)) => #false
;; (invader-reached-bottom? (make-posn 400 470)) => #true
;; (invader-reached-bottom? (make-posn 120 250)) => #false
;; (invader-reached-bottom? (make-posn 100 490)) => #true

(define (invader-reached-bottom? an-invader)
  (cond
    [(<= (abs (- (posn-y an-invader) SHIP-POSY))
         (+ (/ SHIP-HEIGHT 2) (/ INVADER-SIDE 2))) #true]
    [else #false]))

;;;; Tests
(check-expect (invader-reached-bottom? (make-posn 200 300)) #false)
(check-expect (invader-reached-bottom? (make-posn 400 470)) #true)
(check-expect (invader-reached-bottom? (make-posn 120 250)) #false)
(check-expect (invader-reached-bottom? (make-posn 100 490)) #true)

;;;; Signature: reached-bottom? : LoI -> Boolean
;;;; Purpose: given a list of invaders, return #true if the invaders
;;;;          have reached bottom of the screen. Else, return #false.

;;;; Examples
;; (reached-bottom? INVADERS-LOCATIONS) => #false
;; (reached-bottom? (list (make-posn 200 200)
;; (make-posn 300 300) (make-posn 400 480))) => #true
;; (reached-bottom LOB-INVADER) => #false

(define (reached-bottom? loi)
  (ormap invader-reached-bottom? loi))

;;;; Tests
(check-expect (reached-bottom? INVADERS-LOCATIONS) #false)
(check-expect (reached-bottom? (list (make-posn 200 200)
                                     (make-posn 300 300)
                                     (make-posn 400 480))) #true)
(check-expect (reached-bottom? LOB-INVADER) #false)

;;;; Signature: won? : World -> Boolean
;;;; Purpose: given a world, return #true if all invaders have been
;;;;          destroyed. Else, return #false

;;;; Examples
;; (won? WORLD-INIT) => #false
;; (won? (make-world (make-ship 'left (make-posn 250 480) 1) 
;;                   (make-invaders empty 4) empty empty 100)) => #true
;; (won? WORLD-TEST-2) => #false

(define (won? a-world)
  (cond
    [(= (num-elements (invaders-locations (world-invaders a-world))) 0) #true]
    [else #false]))

;;;; Tests
(check-expect (won? WORLD-INIT) #false)
(check-expect (won? (make-world (make-ship 'left (make-posn 250 480) 1)
                                (make-invaders empty 4) empty empty 100)) #true)
(check-expect (won? WORLD-TEST-2) #false)

;;;; Signature: stop? : World -> Boolean
;;;; Purpose: given a world, check if the game has ended

;;;; Examples
;; (stop? WORLD-INIT) => #false
;; (stop? (make-world SHIP-INIT (make-invaders empty 6)
;;                    LOB-SPACESHIP LOB-INVADER 180)) => #true
;; (stop? (make-world (make-ship 'right (make-posn 300 480) -1)
;;                    INVADERS-INIT LOB-SPACESHIP LOB-INVADER 0)) => #true
;; (stop? (make-world SHIP-INIT (make-invaders (list (make-posn 300 480)) 3)
;;                    LOB-SPACESHIP LOB-INVADER 175)) => #true

(define (stop? a-world)
  (cond
    [(or (< (ship-rem-lives (world-ship a-world)) 0)
         (won? a-world)
         (reached-bottom? (invaders-locations (world-invaders a-world)))) #true]
    [else #false]))

;;;; Tests
(check-expect (stop? WORLD-INIT) #false)
(check-expect (stop? (make-world SHIP-INIT (make-invaders empty 6)
                                 LOB-SPACESHIP LOB-INVADER 180)) #true)
(check-expect (stop? (make-world (make-ship 'right (make-posn 300 480) -1)
                                 INVADERS-INIT LOB-SPACESHIP LOB-INVADER 0))
              #true)
(check-expect (stop? (make-world SHIP-INIT (make-invaders
                                            (list (make-posn 300 480)) 3)
                                 LOB-SPACESHIP LOB-INVADER 175)) #true)

;;;; Signature: last-scene : World -> Image
;;;; Purpose: Display appropriate end game message depending on whether the
;;;;          player won or lost.

;;;; Examples
;; (last-scene WORLD-INIT)
;; => (place-image (text "Invaders Win! Score: 0" 36 red) 250 250 BACKGROUND)
;; (last-scene (make-world SHIP-INIT (make-invaders empty 6)
;;                         LOB-SPACESHIP LOB-INVADER 180))
;; => (place-image (text "You Win!! Score: 180" 36 "indigo") 250 250 BACKGROUND)
;; (last-scene (make-world (make-ship 'right (make-posn 300 480) -1)
;;                         INVADERS-INIT LOB-SPACESHIP LOB-INVADER 0))
;; => (place-image (text "Invaders Win! Score: 0" 36 "red") 250 250 BACKGROUND)
;; (last-scene (make-world SHIP-INIT (make-invaders
;;                         (list (make-posn 300 480)) 3)
;;                         LOB-SPACESHIP LOB-INVADER 175))
;; => (place-image (text "Invaders Win! Score: 175" 36 "red") 250 250
;;                 BACKGROUND)

(define (last-scene a-world)
  (cond
    [(won? a-world)
     (place-image (text (string-append "You Win!! Score: "
                                       (number->string (world-score a-world)))
                        36 "indigo") (/ WIDTH 2) (/ HEIGHT 2) BACKGROUND)]
    [else
     (place-image (text (string-append "Invaders Win! Score: "
                                       (number->string (world-score a-world)))
                        36 "red")
                  (/ WIDTH 2) (/ HEIGHT 2) BACKGROUND)]))

;;;; Tests
(check-expect (last-scene WORLD-INIT)
              (place-image (text "Invaders Win! Score: 0" 36 "red") 250 250
                           BACKGROUND))
(check-expect (last-scene (make-world SHIP-INIT (make-invaders empty 6)
                                      LOB-SPACESHIP LOB-INVADER 180))
              (place-image (text "You Win!! Score: 180" 36 "indigo") 250 250
                           BACKGROUND))
(check-expect (last-scene (make-world (make-ship 'right (make-posn 300 480) -1)
                                      INVADERS-INIT LOB-SPACESHIP
                                      LOB-INVADER 0))
              (place-image (text "Invaders Win! Score: 0" 36 "red") 250 250
                           BACKGROUND))
(check-expect (last-scene (make-world SHIP-INIT (make-invaders
                                                 (list (make-posn 300 480)) 3)
                                      LOB-SPACESHIP LOB-INVADER 175))
              (place-image (text "Invaders Win! Score: 175" 36 "red") 250 250
                           BACKGROUND))

;;;; Signature: run : PosReal -> World
;;;; Purpose: given a speed, start big-bang with on-tick set to given
;;;;          speed. Returns the last world generated by big-bang.
(define (run speed)
  (big-bang WORLD-INIT (on-tick update-world speed) (to-draw world-draw)
            (on-key fire-or-change-direction) (stop-when stop? last-scene)))
