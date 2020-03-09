@protocol TransactionResultReceiver

- (void) completed:(NSDictionary *)transactionStatus;

- (void) cancelled;

- (void) error:(int)errorCode description:(NSString *)description details:(NSString *)details;

@end
