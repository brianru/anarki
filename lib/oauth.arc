; OAuth 2.0 client library, in Arc
 
(require "lib/web.arc")
(require "lib/json.ss") ; replace with http://hacks.catdancer.ws/json2.arc

; primary interface to oauth library
(mac auth (request resource)
  ; ensure resource is active, if not, return error message
  ; first modify request to include oauth details from resource
  ; then evaluate request
  t)

(mac auth! (request resource)
  ; ensure resource is active, (active! resource)
  ; then perform same steps as (auth req res)
  t)

; Resources are state machines.
;   nil  inactive  active  expired
;
; Resources are unique to their data-endpoint and provider.
;   state
;   data-endpoint
;   auth-code
;   auth-token
;   provider
;
; Each resource has a provider.
;   auth-code-endpoint
;   auth-token-endpoint
;   client-token
;   client-secret
(deftem provider
   client-token   nil
   client-secret  nil
   auth-code-endpoint  nil ; rename to auth-code-endpoint?
   auth-token-endpoint nil) ; rename to auth-auth-token-endpoint?

; should this memoize each authenticated request?
(deftem (resource provider)
   state nil
   auth-code nil
   auth-token nil)

; STATEFUL?
; maintain tables of providers and resources
; (def load (providers resources) nil)
;

; What is the user interface for granting oauth?
; Click a link made by (req-auth-code-uri res).
; If authenticated previously, immediately return token with redirect.
; If logged in to provider, click authenticate. Redirect to redirect_uri.
; If not logged in, log in, click authenticate. Redirect to redirect_uri.
(def req-auth-code-uri (resource) 
  (+ (mkheader resource!auth-code-endpoint
               '((token resource!client-token)
                 (secret resource!client-secret)
                 (redirect "httpOMGWTFBBQ"))
               "GET"))
  ; provider will send message to auth-callback after user action if necessary,
  ; o/w contains token
  t)

(defop auth-callback (stuff)
  ; if contains error, update resource state
  ; else, update resource auth-code and call (req-auth-token resource)
  t)

(def req-auth-token (resource) 
  ; send request to auth-token-endpoint
  ; parse response
  ;   if successful, update resource state
  ;   else update resource state with error
  t)

(mac activep (resource) `(is ,resource!state 'active))
(mac expirep (resource) `(is ,resource!state 'expired))

(def active! (resource)
  (if (not (activep resource))
      (activate resource)))

; OAuth 2.0 Authentication Code Grant (aka Web) Flow

(def reactivate (resource) t)
(def kill (resource) t)

; Integration Testing
;
;   launch server
;   have pages perform oauth tasks when visited
;   redirect to callback-uri (designated defop)
;
; Google’s OAuth 2.0 Playground: 
;   https://developers.google.com/oauthplayground/

