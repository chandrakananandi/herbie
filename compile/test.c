#include <tgmath.h>
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <gmp.h>
#include <mpfr.h>

#ifndef NARGS
#define NARGS 1
#endif

void setup_mpfr();

float f_if(float);
float f_id(float);
float f_il(float);
float f_of(float);
float f_od(float);
float f_ol(float);
float f_im(float);

unsigned long long int ulp(float x, float y) {
        unsigned int xx = *((unsigned int*) &x);
        xx = xx < 0 ? INT_MIN - xx : xx;

        unsigned int yy = *((unsigned int*)&y);
        yy = yy < 0 ? INT_MIN - yy : yy;

        return xx >= yy ? xx - yy : yy - xx;
}

float rand_float() {
        unsigned int c0 = rand()&0xffff;
        unsigned int c1 = rand()&0xffff;
        unsigned int c = ((c1<<16) | c0);
        return *(float*)&c;
}

float *get_random(int nums) {
        int i;
        float *arr = malloc(sizeof(float) * nums * NARGS);
        for (i = 0; i < nums * NARGS; i++) {
                arr[i] = rand_float();
        }
        return arr;
}

#define SETUP()                                 \
        clock_t start, end, zero;               \
        int i, j;                               \
        unsigned long long int max = 0;         \
        double total = 0;                       \
        float *rands, *out, *correct;           \
        setup_mpfr();

#define CALIBRATE(iter)                                         \
        start = clock();                                        \
        for (i = 0; i < iter; i++) {                            \
                for (j = 0; j < NARGS; j++) {                   \
                        out[i] += 1 / rands[NARGS*i + j];       \
                }                                               \
        }                                                       \
        end = clock();                                          \
        zero = end - start;                                     \
        printf("cal: time %lu\n", zero / 100);

#if NARGS == 1
#define TEST(type, iter)                                                \
        start = clock();                                                \
        for (i = 0; i < iter; i++) {                                    \
                out[i] = f_##type (rands[i]);                           \
        }                                                               \
        end = clock();                                                  \
        printf("%s: time %lu\n", #type, (end - start - zero) / 100);
#elif nargs == 2
#define test(type, iter)                                                \
        start = clock();                                                \
        for (i = 0; i < iter; i++) {                                    \
                out[i] = f_##type (rands[2*i], rands[2*i + 1]);         \
        }                                                               \
        end = clock();                                                  \
        printf("%s: time %lu\n", #type, (end - start - zero) / 100);
#elif nargs == 3
#define test(type, iter)                                                \
        start = clock();                                                \
        for (i = 0; i < iter; i++) {                                    \
                out[i] = f_##type (rands[3*i], rands[3*i + 1], rands[3*i + 2]); \
        }                                                               \
        end = clock();                                                  \
        printf("%s: time %lu\n", #type, (end - start - zero) / 100);
#elif nargs == 4
#define test(type, iter)                                                \
        start = clock();                                                \
        for (i = 0; i < iter; i++) {                                    \
                out[i] = f_##type (rands[4*i], rands[4*i + 1], rands[4*i + 2], rands[4*i + 3]); \
        }                                                               \
        end = clock();                                                  \
        printf("%s: time %lu\n", #type, (end - start - zero) / 100);
#elif nargs == 5
#define test(type, iter)                                                \
        start = clock();                                                \
        for (i = 0; i < iter; i++) {                                    \
                out[i] = f_##type (rands[5*i], rands[5*i + 1], rands[5*i + 2], \
                                   rands[5*i + 3], rands[5*i + 4]);     \
        }                                                               \
        end = clock();                                                  \
        printf("%s: time %lu\n", #type, (end - start - zero) / 100);
#elif nargs == 6
#define test(type, iter)                                                \
        start = clock();                                                \
        for (i = 0; i < iter; i++) {                                    \
                out[i] = f_##type (rands[6*i], rands[6*i + 1], rands[6*i + 2], \
                                   rands[6*i + 3], rands[6*i + 4], rands[6*i + 5]); \
        }                                                               \
        end = clock();                                                  \
        printf("%s: time %lu\n", #type, (end - start - zero) / 100);
#else
#define test(type, iter) abort();
#endif

#define CHECK(type, iter)                                               \
        max = total = 0;                                                \
        for (i = 0; i < iter; i++) {                                    \
                if (correct[i] == correct[i]) {                         \
                        unsigned long long int error = ulp(out[i], correct[i]); \
                        if (error > max) max = error;                   \
                        total += log(error + 1.0) / iter / log(2);      \
                }                                                       \
        }                                                               \
        printf("%s: max %f avg %f\n", #type, log(max + 1.0) / log(2), total);

#define SAMPLE(iter) \
        srand(time(NULL)); \
        rands = get_random(iter); \
        out = malloc(sizeof(float) * iter);

#define SAVE(iter) \
        correct = malloc(sizeof(float) * iter); \
        memcpy((void *) correct, (void *) out, sizeof(float) * iter)

int main(int argc, char** argv) {
        SETUP();
        
        int iter = 1000000;
        if (argc > 1) iter = atoi(argv[1]);

        SAMPLE(iter);
        CALIBRATE(iter);

        TEST(im, iter);
        SAVE(iter);

        TEST(if, iter);
        CHECK(if, iter);

        TEST(id, iter);
        CHECK(id, iter);

        TEST(il, iter);
        CHECK(il, iter);

        TEST(of, iter);
        CHECK(of, iter);

        TEST(od, iter);
        CHECK(od, iter);

        TEST(ol, iter);
        CHECK(ol, iter);

        return 0;
        
}
