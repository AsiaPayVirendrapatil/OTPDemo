#import <Foundation/Foundation.h>

@class ChallengeSession;

@protocol UIController
- (void) beginCommunicating:(ChallengeSession *)challengeSession;
- (void) endCommunicating;
- (void) beginChallengeProcess:(ChallengeSession *)challengeSession;
- (void) handleChallenge:(ChallengeSession *) challengeSession;
- (void) endChallengeProcess:(ChallengeSession *)challengeSession;
@end
