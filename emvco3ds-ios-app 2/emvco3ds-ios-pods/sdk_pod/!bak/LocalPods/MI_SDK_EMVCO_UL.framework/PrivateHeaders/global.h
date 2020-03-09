#import <Foundation/Foundation.h>

#import "Logger.h"

#if ENABLE_DEBUG_MODE
#define MI_SDK_DEBUG
#else
#undef MI_SDK_DEBUG
#endif

#ifdef MI_SDK_DEBUG
#define SDKLogD(...) [Logger debug:[[self class] description] message:__VA_ARGS__]
#else
#define SDKLogD(...) /* */
#endif

#define SDKLogI(...) [Logger info:[[self class] description] message:__VA_ARGS__]
#define SDKLogW(...) [Logger warn:[[self class] description] message:__VA_ARGS__]
#define SDKLogE(...) [Logger error:[[self class] description] message:__VA_ARGS__]
