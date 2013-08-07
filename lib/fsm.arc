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

