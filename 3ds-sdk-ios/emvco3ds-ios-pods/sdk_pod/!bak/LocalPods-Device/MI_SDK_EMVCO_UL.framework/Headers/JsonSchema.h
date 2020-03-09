#ifndef JsonSchema_h
#define JsonSchema_h

#import "BaseSchema.h"

@interface JsonSchema : NSObject {
@protected
    __strong NSBundle *sourceBundle;
    __strong NSMutableDictionary *schemaMap;
}

+(id) createWithBundle:(NSBundle*) bundle;
-(id) initWithBundle:(NSBundle*) bundle;

-(void) validate:(id)json schemaFile:(BaseSchema *)schema error:(NSError *__autoreleasing *)error;
@end
#endif /* JsonSchema_h */
