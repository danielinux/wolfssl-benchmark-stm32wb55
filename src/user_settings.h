/* user_settings.h : custom configuration for wolfcrypt/wolfSSL */

#ifndef USER_SETTINGS_H
#define USER_SETTINGS_H

#ifdef __cplusplus
extern "C" {
#endif

/* System */
#define CUSTOM_RAND_GENERATE random_uint32
#define CUSTOM_RAND_TYPE uint32_t
#define NO_WRITEV
#define NO_DEV_RANDOM
#define NO_FILESYSTEM
#define NO_WOLFSSL_MEMORY
#define NO_MAIN_DRIVER
#define NO_SIG_WRAPPER
#define NO_OLD_RNGNAME

/* Uncomment the next two lines to enable wolfSSL debug */
 #define DEBUG_WOLFSSL
 #define WOLFSSL_LOG_PRINTF

/* Single precision math */
#define WOLFSSL_SP_MATH
#define WOLFSSL_SP_SMALL
#define SP_WORD_SIZE 32
#define WOLFSSL_SP

#define BENCH_EMBEDDED


#define WOLFCRYPT_ONLY

#define HAVE_AES_DECRYPT
#define HAVE_AESGCM
#define GCM_SMALL
#define HAVE_AESCCM
#define WOLFSSL_AES_COUNTER
#define WOLFSSL_AES_DIRECT

/* Align on 32-bit (exc. native,
 * don't modify default alignment.)
 */
#define WOLFSSL_GENERAL_ALIGNMENT 4

#define TFM_ARM
#define SINGLE_THREADED

/* Global settings */
#define SMALL_SESSION_CACHE
//#define WOLFSSL_DH_CONST
#define WOLFSSL_NO_DH
#define WORD64_AVAILABLE
#define TFM_TIMING_RESISTANT
#define USE_CERT_BUFFERS_2048
#define NO_RC4

/* Modules */

//#define WOLFSSL_DTLS

#define HAVE_FFDHE_2048

#define HAVE_CHACHA

#define HAVE_POLY1305
#define HAVE_ONE_TIME_AUTH

#define HAVE_CURVE25519
#define CURVE25519_SMALL

#define HAVE_ED25519
#define ED25519_SMALL

#undef NO_AES
#undef NO_CMAC



#define USE_SLOW_SHA
#define USE_SLOW_SHA2


#define HAVE_SHA
#define HAVE_SHA384
#define HAVE_SHA512
#define WOLFSSL_SHA384
#define WOLFSSL_SHA512
#define USE_SLOW_SHA512

//#define WOLFSSL_SHA3

#define HAVE_ECC
#define FP_ECC
#define WOLFSSL_HAVE_SP_ECC
#define WOLFSSL_HAVE_SP_ECC
#define ECC_TIMING_RESISTANT
#define HAVE_SUPPORTED_CURVES

//#define HAVE_BLAKE2B

//#define HAVE_CAMELLIA
//#define HAVE_IDEA

//#define HAVE_HC128

//#define HAVE_PKCS7

#define WOLFSSL_STATIC_PSK
#define WOLFSSL_DH_CONST


#define HAVE_RSA
#define RSA_LOW_MEM
#define WC_RSA_BLINDING
#define WOLFSSL_STATIC_RSA
#define WOLFSSL_HAVE_SP_DH
#define WOLFSSL_HAVE_SP_RSA


#define NO_DSA
#define NO_DES3


#define NO_MD4

#define NO_RABBIT

#define NO_SIG_WRAPPER


#define CUSTOM_RAND_GENERATE random_uint32
#define CUSTOM_RAND_TYPE uint32_t

#ifdef MODULE_WOLFSSL_TLS13
#define HAVE_TLS13
#define WOLFSSL_TLS13
#define BUILD_TLS_AES_128_GCM_SHA256
#endif

#ifdef __cplusplus
}
#endif


#endif /* USER_SETTINGS_H */
