#import <Foundation/Foundation.h>

static const int EMVCO_3DS20_MAX_BUFFER_SIZE = 1000 * 1000;

@interface Logger : NSObject {
@protected
}
+ (void) debug:(NSString *)name message:(NSString *)format, ...;
+ (void) info:(NSString *)name message:(NSString *)format, ...;
+ (void) warn:(NSString *)name message:(NSString *)format, ...;
+ (void) error:(NSString *)name message:(NSString *)format, ...;
+ (NSMutableString *) getBuffer;
+ (void) createNewBuffer;
+ (NSString *)tail:(int)sizeLimit;
@end
