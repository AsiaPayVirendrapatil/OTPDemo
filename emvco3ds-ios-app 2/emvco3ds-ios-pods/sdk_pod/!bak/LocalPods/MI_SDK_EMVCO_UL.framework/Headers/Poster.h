#import <Foundation/Foundation.h>

@protocol Poster<NSObject>

- (void) doPost:(nullable NSData *)request completionHandler:(nullable void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

@end
