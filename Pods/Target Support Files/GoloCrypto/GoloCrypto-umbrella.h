#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GoloCrypto.h"
#import "base58.h"
#import "crypto.h"
#import "hasher.h"
#import "memzero.h"
#import "options.h"
#import "ripemd160.h"
#import "sha2.h"

FOUNDATION_EXPORT double GoloCryptoVersionNumber;
FOUNDATION_EXPORT const unsigned char GoloCryptoVersionString[];

