; Unit tests for finite state machine library
; by Brian J Rubinton

(require "lib/unit-test.arc")
(require "lib/fsm.arc")

(register-test
  '(suite "fsm.arc"
    ("automaton macro"
      (macex1 '(automaton 'init '((init (c more))
                                  (more (a more)
                                        (d more)
                                        (r end))
                                  (end accept))))
      (withr/p (expand-rules
                (quote ((init (c more))
                        (more (a more)
                              (d more)
                              (r end))
                        (end accept))))
        (quote init)))

    ("expand-rules macro"
      (macex '(expand-rules
               '((init (c more))
                 (more (a more)
                       (d more)
                       (r end))
                 (end accept))))
      (map1 (make-br-fn (rule-ex _)) (quote ((init (c more))
                                             (more (a more)
                                                   (d more)
                                                   (r end))
                                             (end)))))

    ("rule-ex with 1 transition"
      (macex '(rule-ex '(init (c more))))
      (list (car (quote (init (c more)))) (fn (stream) (if (empty stream) nil
                                                         (case (car stream)
                                                           (expand-transitions (cdr (quote (init (c more))))))))))

    ("rule-ex with 3 transitions"
      (macex '(rule-ex '(more (a more) (d more) (r end))))
      (list (car (quote (more (a more) (d more) (r end)))) (fn (stream)
                                                             (if (empty stream) nil
                                                               (case (car stream)
                                                                 (expand-transitions (cdr (quote (more (a more) (d more) (r end))))))))))

    ("expand-transitions"
      ; use macex1 because accfn is bound to a unique name
      (macex1 '(expand-transitions '((a more) (d more) (r end))))
      (accum accfn
        (each x (map1 (make-br-fn (transition-ex _)) (quote ((a more) (d more) (r end))))
          (accfn (car x))
          (accfn (last x)))))

    ("transition-ex"
      (macex '(transition-ex '(a more)))
      (list (car (quote (a more))) (list (last (quote (a more))) (quote (cdr stream)))))))

(run-all-tests)
