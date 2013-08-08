; OAuth 2.0 client library, in Arc
; by Brian J Rubinton
 
(require "lib/web.arc")
;(require "lib/fsm.arc")
(require "lib/json2.arc")

(= redirect_path* "oauth"
   redirect_uri* "localhost:8080/oauth")

(deftem provider
   client-token   nil
   client-secret  nil
   auth-code-endpoint  nil
   auth-token-endpoint nil)

(deftem (resource provider)
   state nil
   auth-code nil
   auth-token nil)

(def req-auth-code-uri (resource) 
  (mkuri resource!auth-code-endpoint (list "client_id" resource!client-token)))

; example: http://localhost:8080/?code=ebd6373f4f1d38fb6a9b
(defop auth-code (req)
  (aif (arg req 'code)
    (pr it)
    (pr arg req 'error)))

(def req-auth-token-uri (resource)
  (mkuri resource!auth-token-endpoint
         (list     "client_id" resource!client-token
               "client_secret" resource!client-secret
                        "code" resource!auth-code)))

(def req-auth-token (resource) 
  (mkreq resource!auth-token-endpoint
         '(redirect_uri  redirect_uri*
           code          resource!auth-code
           client_id     resource!client_id
           client_secret resource!client_secret)
          "POST"))
  ; send request to auth-token-endpoint
  ; parse response
  ;   if successful, update resource state
  ;   else update resource state with error

(def req-resource (resource)
  t)

; Google’s OAuth 2.0 Playground: 
;   https://developers.google.com/oauthplayground/

