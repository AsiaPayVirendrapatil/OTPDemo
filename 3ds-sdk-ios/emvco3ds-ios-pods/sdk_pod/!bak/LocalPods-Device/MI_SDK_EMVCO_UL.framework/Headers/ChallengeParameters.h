#import <Foundation/Foundation.h>

@interface ChallengeParameters : NSObject {
}
@property (nonatomic, retain) NSString *threeDSServerTransactionID;
@property (nonatomic, retain) NSString *acsTransactionID;
@property (nonatomic, retain) NSString *acsRefNumber;
@property (nonatomic, retain) NSString *acsSignedContent;
@property (nonatomic, retain) NSString *threeDSRequestorAppURL;

+ (ChallengeParameters *) createCopy:(ChallengeParameters *)origParams;

@end
