#import <Foundation/Foundation.h>

@interface CompletionEvent : NSObject

@property (nonatomic, retain) NSString *sdkTransactionID;
@property (nonatomic, retain) NSString *transactionStatus;

- (id) init:(NSString *)sdkTransID transactionStatus:(NSString *)transStatus;

@end
