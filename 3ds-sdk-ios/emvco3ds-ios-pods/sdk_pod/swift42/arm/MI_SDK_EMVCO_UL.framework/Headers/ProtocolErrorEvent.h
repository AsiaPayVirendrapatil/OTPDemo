#import <Foundation/Foundation.h>

#import "ErrorMessage.h"

@interface ProtocolErrorEvent : NSObject

@property (nonatomic, retain) ErrorMessage *errorMessage;
@property (nonatomic, retain) NSString *sdkTransactionID;

- (id) init:(NSString *)sdkTransID errorMessage:(ErrorMessage *)errMessage;

@end
