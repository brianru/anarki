; Testing the OAuth 2.0 client library
; by Brian J Rubinton

(require "lib/unit-test.arc")
(require "lib/oauth.arc")

(= c-token*  "a10fae451113286074f3"
   c-secret* "7c8073f503da82a658f4ddd312ff7a30cfd98cd7"
   a-code-endpoint* "https://github.com/login/oauth/authorize"
   a-token-endpoint* "https://github.com/login/oauth/access_token"
   a-code* "ebd6373f4f1d38fb6a9b"
   sample-rsrc* (inst 'resource
                      'client-token c-token*
                      'client-secret c-secret*
                      'auth-code-endpoint a-code-endpoint*
                      'auth-token-endpoint a-token-endpoint*))

(register-test
  '(suite "OAuth 2.0 client library"
    ("generate auth code uri"
      (req-auth-code-uri 
        (inst 'resource
              'client-token c-token*
              'client-secret c-secret*
              'auth-code-endpoint a-code-endpoint*
              'auth-token-endpoint a-token-endpoint*
              'state nil
              'auth-code nil
              'auth-token nil))
      "https://github.com:443/login/oauth/authorize?client_id=a10fae451113286074f3")
    
    ("test acquire auth-code (success)"
      (even 2) ; todo mkreq to http://localhost:8080/auth?code=4ea78c9d268fcefabdce 
               ;      then verify the code was parsed corretly
      "omgwtfbbq")

    ("test generate auth-token request"
      (req-auth-token-uri
        (inst 'resource
              'client-token c-token*
              'client-secret c-secret*
              'auth-code-endpoint "https://github.com/login/oauth/authorize"
              'auth-token-endpoint "https://github.com/login/oauth/access_token"
              'state nil
              'auth-code "ebd6373f4f1d38fb6a9b"
              'auth-token nil))
      "https://github.com:443/login/oauth/access_token?client_id=a10fae451113286074f3&client_secret=7c8073f503da82a658f4ddd312ff7a30cfd98cd7&code=ebd6373f4f1d38fb6a9b")
    
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

(run-all-tests)
