#lang racket

(provide (all-defined-out)
        _posit8 _posit16 _posit32 _posit64 _posit128
         posit8? posit16? posit32? posit64? posit128?
         _quire8 _quire16 _quire32
         quire8? quire16? quire32?
         uint32->posit8 uint32->posit16 uint32->posit32
         uint64->posit8 uint64->posit16 uint64->posit32
         int32->posit8 int32->posit16 int32->posit32
         int64->posit8 int64->posit16 int64->posit32
         posit8->uint32 posit8->uint64 posit8->int32 posit8->int64
         posit8->posit16 posit8->posit32
         posit8-round-to-int posit8-add posit8-sub posit8-mul
         posit8-mulAdd posit8-div posit8-sqrt
         posit8-eq? posit8-le? posit8-lt?
         create-quire8 create-quire16 create-quire32
         quire8-fdp-add quire8-fdp-sub quire8->posit8
         posit8->double double->posit8
         posit16->uint32 posit16->uint64 posit16->int32 posit16->int64
         posit16->posit8 posit16->posit32
         posit16-round-to-int posit16-add posit16-sub posit16-mul
         posit16-mulAdd posit16-div posit16-sqrt
         posit16-eq? posit16-le? posit16-lt?
         quire16-fdp-add quire16-fdp-sub quire16->posit16
         quire16-twos-complement
         posit16->double float->posit16 double->posit16
         posit32->uint32 posit32->uint64 posit32->int32 posit32->int64
         posit32->posit8 posit32->posit16
         posit32-round-to-int posit32-add posit32-sub posit32-mul
         posit32-mulAdd posit32-div posit32-sqrt
         posit32-eq? posit32-le? posit32-lt?
         quire32-fdp-add quire32-fdp-sub quire32->posit32
         quire32-twos-complement
         posit32->double float->posit32 double->posit32
         double->quire8 double->quire16 double->quire32
         quire8->double quire16->double quire32->double)
         

(require math/bigfloat racket/lazy-require)
(lazy-require [softposit-rkt (_posit8 _posit16 _posit32 _posit64 _posit128
         posit8? posit16? posit32? posit64? posit128?
         _quire8 _quire16 _quire32
         quire8? quire16? quire32?
         uint32->posit8 uint32->posit16 uint32->posit32
         uint64->posit8 uint64->posit16 uint64->posit32
         int32->posit8 int32->posit16 int32->posit32
         int64->posit8 int64->posit16 int64->posit32
         posit8->uint32 posit8->uint64 posit8->int32 posit8->int64
         posit8->posit16 posit8->posit32
         posit8-round-to-int posit8-add posit8-sub posit8-mul
         posit8-mulAdd posit8-div posit8-sqrt
         posit8-eq? posit8-le? posit8-lt?
         create-quire8 create-quire16 create-quire32
         quire8-fdp-add quire8-fdp-sub quire8->posit8
         posit8->double double->posit8
         posit16->uint32 posit16->uint64 posit16->int32 posit16->int64
         posit16->posit8 posit16->posit32
         posit16-round-to-int posit16-add posit16-sub posit16-mul
         posit16-mulAdd posit16-div posit16-sqrt
         posit16-eq? posit16-le? posit16-lt?
         quire16-fdp-add quire16-fdp-sub quire16->posit16
         quire16-twos-complement
         posit16->double float->posit16 double->posit16
         posit32->uint32 posit32->uint64 posit32->int32 posit32->int64
         posit32->posit8 posit32->posit16
         posit32-round-to-int posit32-add posit32-sub posit32-mul
         posit32-mulAdd posit32-div posit32-sqrt
         posit32-eq? posit32-le? posit32-lt?
         quire32-fdp-add quire32-fdp-sub quire32->posit32
         quire32-twos-complement
         posit32->double float->posit32 double->posit32
         double->quire8 double->quire16 double->quire32
         quire8->double quire16->double quire32->double)])
;; This file makes racket bindings for all the posit functions

(struct big-posit8 (v))
(struct big-posit16 (v))
(struct big-posit32 (v))

(define (bf-double->posit8 x) (big-posit8 x))
(define (bf-posit8->double x) (big-posit8-v x))
(define (bf-posit8-add x y) (big-posit8 (bf+ (big-posit8-v x) (big-posit8-v y))))
(define (bf-posit8-sub x y) (big-posit8 (bf- (big-posit8-v x) (big-posit8-v y))))
(define (bf-posit8-mul x y) (big-posit8 (bf* (big-posit8-v x) (big-posit8-v y))))
(define (bf-posit8-div x y) (big-posit8 (bf/ (big-posit8-v x) (big-posit8-v y))))
(define (bf-posit8-sqrt x) (big-posit8 (bfsqrt (big-posit8-v x))))

(define (bf-double->posit16 x) (big-posit16 x))
(define (bf-posit16->double x) (big-posit16-v x))
(define (bf-posit16-add x y) (big-posit16 (bf+ (big-posit16-v x) (big-posit16-v y))))
(define (bf-posit16-sub x y) (big-posit16 (bf- (big-posit16-v x) (big-posit16-v y))))
(define (bf-posit16-mul x y) (big-posit16 (bf* (big-posit16-v x) (big-posit16-v y))))
(define (bf-posit16-div x y) (big-posit16 (bf/ (big-posit16-v x) (big-posit16-v y))))
(define (bf-posit16-sqrt x) (big-posit16 (bfsqrt (big-posit16-v x))))

(define (bf-double->posit32 x) (big-posit32 x))
(define (bf-posit32->double x) (big-posit32-v x))
(define (bf-posit32-add x y) (big-posit32 (bf+ (big-posit32-v x) (big-posit32-v y))))
(define (bf-posit32-sub x y) (big-posit32 (bf- (big-posit32-v x) (big-posit32-v y))))
(define (bf-posit32-mul x y) (big-posit32 (bf* (big-posit32-v x) (big-posit32-v y))))
(define (bf-posit32-div x y) (big-posit32 (bf/ (big-posit32-v x) (big-posit32-v y))))
(define (bf-posit32-sqrt x) (big-posit32 (bfsqrt (big-posit32-v x))))

(struct big-quire8 (v))
(struct big-quire16 (v))
(struct big-quire32 (v))

(define (bf-quire8->double x) (quire8->double (big-quire8-v x)))
(define (bf-quire16->double x) (quire16->double (big-quire16-v x)))
(define (bf-quire32->double x) (quire32->double (big-quire32-v x)))

(define (bf-double->quire8 x) (big-quire8 x))
(define (bf-double->quire16 x) (big-quire16 x))
(define (bf-double->quire32 x) (big-quire32 x))

(define (bf-quire8-fdp-add x y z) (big-quire8
                                     (bf+ (big-quire8-v x)
                                          (bf* (big-posit8-v y) (big-posit8-v z)))))
(define (bf-quire8-fdp-sub x y z) (big-quire8
                                     (bf- (big-quire8-v x)
                                          (bf* (big-posit8-v y) (big-posit8-v z)))))

(define (bf-quire16-fdp-add x y z) (big-quire16
                                     (bf+ (big-quire16-v x)
                                          (bf* (big-posit16-v y) (big-posit16-v z)))))
(define (bf-quire16-fdp-sub x y z) (big-quire16
                                     (bf- (big-quire16-v x)
                                          (bf* (big-posit16-v y) (big-posit16-v z)))))

(define (bf-quire32-fdp-add x y z) (big-quire32
                                     (bf+ (big-quire32-v x)
                                          (bf* (big-posit32-v y) (big-posit32-v z)))))
(define (bf-quire32-fdp-sub x y z) (big-quire32
                                     (bf- (big-quire32-v x)
                                          (bf* (big-posit32-v y) (big-posit32-v z)))))
