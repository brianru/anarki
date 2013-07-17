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

; (run machine 'init '(c a d a d d r))
; (run machine 'init '(c a d a d d r r))
            
; (run machine init-state stream)
; stream is a lazy list of states of resource
; at each state there is an action
; the action updates the rsrc
; the fsm takes the next state from the stream
; the next state is lazily computed using rsrc at that time
