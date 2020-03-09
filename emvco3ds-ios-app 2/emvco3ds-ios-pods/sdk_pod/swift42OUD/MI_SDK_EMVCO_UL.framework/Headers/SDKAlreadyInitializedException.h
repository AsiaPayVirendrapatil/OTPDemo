#import <Foundation/Foundation.h>

@interface SDKAlreadyInitializedException : NSError

@property (nonatomic, retain) NSString* message;

- (id) init:(NSString *)errorMessage;

@end
