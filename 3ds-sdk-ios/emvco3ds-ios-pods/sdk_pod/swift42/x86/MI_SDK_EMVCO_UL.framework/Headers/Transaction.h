#import "AuthenticationRequestParameters.h"
#import "ChallengeParameters.h"
#import "ChallengeStatusReceiver.h"
#import "ProgressDialog.h"

@protocol Transaction

- (AuthenticationRequestParameters *) getAuthenticationRequestParameters;

- (void) doChallenge:(ChallengeParameters *)challengeParameters
challengeStatusReceiver:(id<ChallengeStatusReceiver>)challengeStatusReceiver
             timeOut:(int)timeOut;

- (id<ProgressDialog>) getProgressView;

- (void) close;
@end
