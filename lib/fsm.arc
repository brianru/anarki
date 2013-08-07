; Finite State Machine Library
; by Brian J Rubinton
;
; based on http://cs.brown.edu/~sk/Publications/Papers/Published/sk-automata-macros/paper.pdf
; with help from the Arc Community: http://arclanguage.org/item?id=17916
;
; Features
;
;   - Explicit accept transition (implicit reject transitions.
;     - States act like a whitelist for inputs.
;   - States evaluate a specified expression each time the state is visited.
;   - "defaut" convenience macro for defining and binding automatons.
;
; todo
;   - lazy stream compatibility -- pending lazy stream library
;   - generalize input handler
;   - entry/exit actions associated with states, as well as
;     action every time state's function is called
;   - if i use caselet, can this be used for mealy machines by passing the funcs a 2nd arg?
;     - if the 2nd arg is optional, can the code remain concise?
;
; Deterministic Finite Automata
;   - state depends on input, no output
;   - functions associated with each state must not affect state
;
; Moore Machine
;   - state depends on input, output depends on state
;   - functions associated with each state create their own state

(def mktn (tn)
  (if (is type.tn 'cons) (list car.tn (list last.tn '(cdr str)))
      (is tn 'accept)    (list nil t)))

(def mktns (tns)
  (accum accfn
    (each x (map1 mktn tns)
      (accfn car.x) (accfn last.x))))

(def mkrule (r)
  (list (car r) `(fn (str) ,(cadr r)
                   (case (car str)
                     ,@(mktns (cddr r))))))

(mac automaton (i rs)
  `(withr/p ,(map1 [mkrule _] rs) ,i))

(mac defaut (n i rs)
  `(= ,n (automaton ,i ,rs)))

