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
; (defaut m 'init
;           '((init ((c more)))
;             (more ((a more)
;                    (d more)
;                    (r end)))
;             (end  (accept))))

; first implementation on page 4

(require "lib/util.arc")

(= machine
  '((init ((c more)))
    (more ((a more)
           (d more)
           (r end)))
    (end)))

(def run (machine init-state str)
  (def walker (state str)
    (if (empty str) ; why "cond" not "if"?
      t
      (withs (i (car str)
              transitions (alref machine state)
              new-state (alref transitions i))
        (if new-state
          (walker new-state (cdr str))
          '()))))
  (walker init-state str))


; examples:
; (run machine 'init '(c a d a d d r)) -> t
; (run machine 'init '(c a d a d d r r)) -> nil
            
; second implementation -- page 6 (fig 1)
; TODO abstract state/label/target with macro
(= ma
   (withr (init (fn (str)
                  (if (empty str)
                    t
                    (case (car str) 
                      c (more (cdr str)))))
           more (fn (str)
                  (if (empty str)
                    t
                    (case (car str)
                      a (more (cdr str))
                      d (more (cdr str))
                      r (end  (cdr str)))))
           end  (fn (str)
                  (if (empty str)
                    t
                    (case (car str)
                      t nil))))
     init))

; examples:
; (m '(c a d a d d r)) -> t
; (m '(c a d a d d r r)) -> nil


; call: (mktransition '(a more)
; expansion:
; (a (more (cdr str)))
(def mktransition (tn) (list (car tn) (list (last tn) '(cdr str))))

; call:
; (mktransitions '((a more)
;                  (d more)
;                  (r end)))
; expansion:
; (a (more (cdr str))
;  d (more (cdr str))
;  r (end  (cdr str)))
(def mktransitions (ts)
  (accum accfn ; accum helps splice the result of mktransition
    (each x (map1 mktransition ts)
      (accfn (car x))
      (accfn (last x)))))

; call:
; (mkrule '(more (a more) (d more) (r end)))
; expansion:
;  more (fn (str)
;         (if (empty str)
;           t
;           (case (car str)
;             a (more (cdr str))
;             d (more (cdr str))
;             r (end  (cdr str)))))
(mac mkrule (r)
  (let i r
    `(list (car ,i) (fn (str)
                      (if (empty str) t
                        (case (car str)
                          ,@(mktransitions (cdr i))))))))

; example call:
; (automaton 'init
;            '((init (c more))
;              (more (a more)
;                    (d more)
;                    (r end))
;              (end)))
(mac automaton (i r) `(withr/p ,(map1 [mkrule _] r) ,i))

; todo implement this?
(mac defaut (name auto) 
  `(= ,name (automaton ,auto))) 

;(defaut ca*dr (str (o step)) init
;        init (c more)
;        more (a more)
;             (d more)
;             (r end)
;        end)



; thoughts on lazy evaluation:
; str is a lazy list of states of resource
; at each state there is an action
; the action updates the rsrc
; the fsm takes the next state from the str
; the next state is lazily computed using rsrc at that time
