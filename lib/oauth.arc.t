; Testing the OAuth 2.0 client library

; start a simple server
; defop /data/
; call /data/ and get response?

(require "lib/unit-test.arc")
(require "lib/oauth.arc")

(register-test
  '(suite "OAuth 2.0 client library"c
    ("generate auth code uri"
      (req-auth-code-uri 
        (inst 'resource
              'client-token 1
              'client-secret 2
              'auth-code-endpoint 3
              'auth-token-endpoint 4
              'state
              'auth-code
              'auth-token))
      nil)
    
    ("test acquire auth-code"
      (even 2)
      nil)
    
    ("test acquire auth-token"
      (even 2)
      nil)

    ("test demo api request"
      (even 2)
      nil)))
