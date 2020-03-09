#import <Foundation/Foundation.h>

#import "ErrorMessage.h"

@interface RuntimeErrorEvent : NSObject

@property (nonatomic, retain) NSString *errorCode;
@property (nonatomic, retain) NSString *errorMessage;

- (id) init:(NSString *)errCode errorMessage:(NSString *)errMessage;

@end
