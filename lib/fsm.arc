; Finite State Machine Library
; by Brian J Rubinton
; based on http://cs.brown.edu/~sk/Publications/Papers/Published/sk-automata-macros/paper.pdf
;
;
; GOAL:
; automaton init
;   init : c -> more
;   more : a -> more
;          d -> more
;          r -> end
;   end  :
;
; (def machine
;   '((init ((c more)))
;     (more ((a more)
;            (d more)
;            (r end)))
;     (end)))

; first implementation on page 4

(require "lib/util.arc")

(= machine
  '((init ((c more)))
    (more ((a more)
           (d more)
           (r end)))
    (end)))

(def run (machine init-state stream)
  (def walker (state stream)
    (if (empty stream) ; why "cond" not "if"?
      t
      (withs (i (car stream)
              transitions (alref machine state)
              new-state (alref transitions i))
        (if new-state
          (walker new-state (cdr stream))
          '()))))
  (walker init-state stream))


; examples:
; (run machine 'init '(c a d a d d r)) -> t
; (run machine 'init '(c a d a d d r r)) -> nil
            
; second implementation -- page 6 (fig 1)
; TODO abstract state/label/target with macro
(= m
   (withr (init (fn (stream)
                  (if (empty stream)
                    t
                    (case (car stream) 
                      c (more (cdr stream)))))
           more (fn (stream)
                  (if (empty stream)
                    t
                    (case (car stream)
                      a (more (cdr stream))
                      d (more (cdr stream))
                      r (end  (cdr stream)))))
           end  (fn (stream)
                  (if (empty stream)
                    t
                    (case (car stream)
                      t nil))))
     init))

; examples:
; (m '(c a d a d d r)) -> t
; (m '(c a d a d d r r)) -> nil



; example call:
; (automaton init
;           (init (c more))
;           (more (a more)
;                 (d more)
;                 (r end))
;           (end accept))
(mac automaton (i r)
  `(withr (expand-rules ,r)
    ,i))

; example call:
; (expand-rules (init (c more))
;               (more (a more)
;                     (d more)
;                     (r end))
;               (end accept))
(mac expand-rules (rs)
  `(map1 [rule-ex _] ,rs))

; (rule-ex 'more '(a more) '(d more) '(r end))
; TODO align input/output to be compatible with expand-transitions
(def rule-ex (r)
  `((car ,r) (fn (stream)
     (if (empty stream)
       t
       (case (car stream)
         (expand-transitions (cdr ,r)))))))

; call:
; (expand-transitions (a more)
;                     (d more)
;                     (r end))
;
; expansion:
; (a (more (cdr stream))
;  d (more (cdr stream))
;  r (end  (cdr stream)))
(mac expand-transitions (transition)
  `(map1 [transition-ex _] ,transition))
; find a way to pull out the first item for each, second item for each, and populate a list with the correct number of elements  

(def transition-ex (transition)
  `((caar ,transition) ((cadar ,transition) (cdr stream))))

;(mac defaut (aut) t)

;(defaut ca*dr (stream (o step)) init
;        init (c more)
;        more (a more)
;             (d more)
;             (r end)
;        end)


; thoughts on lazy evaluation:
; stream is a lazy list of states of resource
; at each state there is an action
; the action updates the rsrc
; the fsm takes the next state from the stream
; the next state is lazily computed using rsrc at that time
