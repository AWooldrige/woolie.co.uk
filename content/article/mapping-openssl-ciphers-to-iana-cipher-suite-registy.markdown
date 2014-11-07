---
title: Mapping OpenSSL Cipher Suite Names to Official Names and RFCs
created_at: 2014-11-06 16:48:00 +0000
kind: article
---
OpenSSL, and a lot of software that uses it
([httpd](http://httpd.apache.org/docs/current/mod/mod_ssl.html#sslciphersuite),
[nginx](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_ciphers)
etc) have their own cipher suite names. To map from the OpenSSL cipher suite
name, such as:

    ECDHE-ECDSA-AES256-SHA384

### 1) Look up the ID
Use the OpenSSL `ciphers(1)` tool to look up the cryptographic suite selector
code (2 hex values used to represent that cipher suite on the wire) for that
suite name.

For example with the suite name above:

    $ openssl ciphers -V | grep 'ECDHE-ECDSA-AES256-SHA384' | awk '{ print $1 }'

    0xC0,0x24


### 3) Cross reference with IANA list
Look that ID up in the [IANA list of TLS
parameters](http://www.iana.org/assignments/tls-parameters/tls-parameters.xhtml#tls-parameters-4).

For the ID above you can find it was defined in
[RFC5289](http://www.iana.org/go/rfc5289), and has the name:

    TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384


-----


## Notes
 * The '`-V`' argument is only available with OpenSSL later than 1.0.0. Check
   your version with: `openssl version`
 * This mapping is also available in the OpenSSL `ciphers(1)` manual page. See:
   `man ciphers`. I prefer the cross referencing to IANA method above as you
   can easily find the RFC that introduced it.


## More Detail On Cipher Suite Names
Official (RFC specified) cipher suite names follow the convention:

    TLS_<key exchange and authentication algorithms>_WITH_<bulk cipher and message authentication algorithms>

For example `TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384` when broken down
specifies a cipher suite combining the following:

 * `ECDHE_ECDSA` - Key exchange using the [Elliptic curve Diffie-Hellman](http://en.wikipedia.org/wiki/Elliptic_curve_Diffie%E2%80%93Hellman) (ECDHE)
   protocol with authentication provided by [Elliptic Curve Digital Signature
   Algorithm](http://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm)
   (ECDSA) keys.
 * `AES_256_CBC` - Encryption provided by the [Advanced Encryption
   Standard](http://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
   algorithm using 256 bit keys and chained by TLS in [cipher-block chaining
   mode](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher-block_chaining_.28CBC.29) (CBC).
 * `SHA384` - Hash based message authentication code generated using the
   [Secure Hash Algorithm](http://en.wikipedia.org/wiki/Secure_Hash_Algorithm)
   2 with 384 bits length of hash output.

OpenSSL can also help with this breakdown:

    $ openssl ciphers -V | grep 'ECDHE-ECDSA-AES256-SHA384'

    0xC0,0x24 - ECDHE-ECDSA-AES256-SHA384 TLSv1.2 Kx=ECDH     Au=ECDSA Enc=AES(256)  Mac=SHA384

See the key exchange (kx), authentication (Au), encoding (Enc) and message
authentication code (Mac) fields.
