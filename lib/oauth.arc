; Oauth 2.0 library
; 
; ---------------------------------------------------------------------------------
;    layers        || vocabulary
; =================================================================================
;    resources     || authurl, authcreds, authtoken, targeturl, targetvalue(cached)
; ---------------------------------------------------------------------------------
;    parsers       || token, username, password, json objects
; ---------------------------------------------------------------------------------
;    http requests || get, post
; ---------------------------------------------------------------------------------


(require "lib/web.arc")

(deftem resource auth-endpoint nil
                 token-endpoint nil
                 auth-user nil
                 auth-code nil
                 auth-token (request-token auth-endpoint auth-user)
                 value-endpoint nil
                 value (request-value value-endpoint auth-token auth-user)) ;memoized

; am I thinking about this the right way?
; funcitonal programming means all functions should be idempotent, right?
; what does this mean for maintaining state?

;these are destructive, they update rsrc!auth-token 
(def activate-resource (rsrc)
  (do 
    (aif (no rsrc!auth-token) ;does this work?
      (set it (request-token rsrc)))
    (set rsrc!value (retrieve-resource rsrc))))

(def deactivate-resource (r) ____)

(def retrieve-resource (r) ____)

(def statusp (r) ___)

(def astatusp (r) ____) ;anaphoric, use "it" to refer to resource

; webflow authentication
; 1) direct user to host's page to grant us access, retrieve CODE in return
; 2) request token from host using CODE, clientid, clientsecret
; 3) use token to request data from host

(def request-access (rsrc)
  (mkreq rsrc!auth-endpoint)
  ; set code to rsrc!auth-code)

(def request-token (rsrc) 
  (mkreq     rsrc!token-endpoint
    '("user" rsrc!auth-user
      "code" rsrc!auth-code)))

(def retrieve-value (rsrc)
  (parse-response (mkreq      rsrc!value-endpoint
                    '("token" rsrc!auth-token
                       "user" rsrc!auth-user))))

(def parse-response (raw) ___)




