#import <Foundation/Foundation.h>

@interface SDKNotInitializedException : NSError

@property (nonatomic, retain) NSString* message;

- (id) init:(NSString *)errorMessage;

@end
