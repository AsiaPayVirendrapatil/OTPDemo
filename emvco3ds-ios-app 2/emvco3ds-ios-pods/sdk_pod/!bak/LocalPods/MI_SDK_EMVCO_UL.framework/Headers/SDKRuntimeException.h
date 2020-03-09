#import <Foundation/Foundation.h>

@interface SDKRuntimeException : NSError

@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSString* errorCode;
@property (nonatomic, retain) NSError* cause;

- (id) init:(NSString *)errorMessage errorCode:(NSString *)errCode cause:(NSError *)errorCause;

@end
