@protocol ChallengeStatusReceiver;
@protocol MessageHandlerDelegate;
@protocol TransactionResultReceiver;
@protocol ProgressDialog;

@protocol MerchantTransaction <ChallengeStatusReceiver, MessageHandlerDelegate>

- (void) checkout:(NSDictionary *)parameters
transactionResultReceiver:(id<TransactionResultReceiver>)transactionResultReceiver
             timeOut:(int)timeOut;

- (id<ProgressDialog>) getProgressView;

- (void) close;

@end
