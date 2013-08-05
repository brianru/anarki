; Testing the OAuth 2.0 client library

; start a simple server
; defop /data/
; call /data/ and get response?

(require "lib/unit-test.arc")
(require "lib/oauth.arc")

(= c-token*  "a10fae451113286074f3"
   c-secret* "7c8073f503da82a658f4ddd312ff7a30cfd98cd7")

(register-test
  '(suite "OAuth 2.0 client library"c
    ("generate auth code uri"
      (req-auth-code-uri 
        (inst 'resource
              'client-token c-token*
              'client-secret c-secret*
              'auth-code-endpoint "https://github.com/login/oauth/authorize"
              'auth-token-endpoint "https://github.com/login/oauth/access_token"
              'state nil
              'auth-code nil
              'auth-token nil))
      "https://github.com:443/login/oauth/authorize?client_id=a10fae451113286074f3")
    
    ("test acquire auth-code (success)"
      (do
        (serve1)
        (system (string "open " (req-auth-code-uri sample-rsrc*))))
        ; send request to redirect_uri* with sample auth code
      "omgwtfbbq") ; TODO assert something about the resource state and auth-code
    ; (system (string "open" (req-auth-code-uri "localhost:8080/oauth/" '(code omgwtfbbq))))

    ("test generate auth-token request"
      (req-auth-token
        (inst 'resource
              'client-token c-token*
              'client-secret c-secret*
              'auth-code-endpoint "https://github.com/login/oauth/authorize"
              'auth-token-endpoint "https://github.com/login/oauth/access_token"
              'state nil
              'auth-code "ebd6373f4f1d38fb6a9b"
              'auth-token nil))
      nil) ; verify response contains token
    
    ("test acquire auth-token"
      (even 2)
      nil)
  
    ("test generate authreq"
      (even 2)
      nil)

    ("test acquire auth resource"
      (even 2)
      nil)

    ("test demo api request"
      (even 2)
      nil)))
