; Unit tests for finite state machine library
; by Brian J Rubinton

(require "lib/unit-test.arc")
(require "lib/fsm.arc")

(register-test
  '(suite "fsm.arc"
    ("automaton macro"
      (macex1 '(automaton init ((init (+ 1 1)
                                  (c more))
                                (more (+ 2 2)
                                  (a more)
                                  (d more)
                                  (r end))
                                (end  (+ 3 3) 
                                  accept))))
      (withr/p ((init (fn (str) 
                        (+ 1 1)
                        (case (car str)
                          c (more (cdr str)))))
                (more (fn (str)
                        (+ 2 2)
                        (case (car str)
                          a (more (cdr str))
                          d (more (cdr str))
                          r (end  (cdr str)))))
                (end  (fn (str)
                        (+ 3 3)
                        (case (car str)
                          nil t))))
        init))

    ("mkrule with 1 transition"
      (mkrule '(init nil (c more)))
      (init (fn (str)
              nil
              (case (car str)
                c (more (cdr str))))))

    ("rule-ex with 3 transitions"
      (mkrule '(more nil (a more) (d more) (r end)))
      (more (fn (str)
              nil
              (case (car str)
                a (more (cdr str))
                d (more (cdr str))
                r (end  (cdr str))))))

    ("make end state"
      (mkrule '(end nil accept))
      (end (fn (str) nil
             (case (car str)
               nil t))))

    ("make transitions (body of case block"
      ; use macex1 because accfn is bound to a unique name
      (mktns '((a more) (d more) (r end)))
      (a (more (cdr str))
       d (more (cdr str))
       r (end  (cdr str))))))

(run-all-tests)

