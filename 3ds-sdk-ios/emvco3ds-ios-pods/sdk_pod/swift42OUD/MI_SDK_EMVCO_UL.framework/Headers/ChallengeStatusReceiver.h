#import <Foundation/Foundation.h>

#import "CompletionEvent.h"
#import "ProtocolErrorEvent.h"
#import "RuntimeErrorEvent.h"

@protocol ChallengeStatusReceiver

- (void) completed:(CompletionEvent *)e;
- (void) cancelled;
- (void) timedout;
- (void) protocolError:(ProtocolErrorEvent *)e;
- (void) runtimeError:(RuntimeErrorEvent *)e;

@end
