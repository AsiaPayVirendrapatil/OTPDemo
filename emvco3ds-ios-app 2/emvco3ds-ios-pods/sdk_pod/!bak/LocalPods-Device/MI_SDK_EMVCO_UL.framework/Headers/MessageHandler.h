#import <Foundation/Foundation.h>
#import "Poster.h"
#import "MessageHandlerDelegate.h"
#import "MessageRequest.h"
#import "JsonSchema.h"

@interface MessageHandler : NSObject

@property (nonatomic, retain) JsonSchema *jsonValidator;
@property (nonatomic, retain) NSObject<Poster> *poster;

- (void) sendAndReceive:(MessageRequest*) request delegate:(NSObject<MessageHandlerDelegate>*) callback;

+(MessageHandler*) createNewHandler:(NSObject<Poster> *)poster validator:(JsonSchema*) schema;
@end
