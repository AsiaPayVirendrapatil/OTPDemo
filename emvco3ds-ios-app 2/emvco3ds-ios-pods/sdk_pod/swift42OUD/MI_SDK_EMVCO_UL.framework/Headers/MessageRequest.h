
#ifndef MessageRequest_h
#define MessageRequest_h
#import <Foundation/Foundation.h>
#import "BaseSchema.h"

@interface MessageRequest : NSObject {
@protected
  __strong NSMutableDictionary *message;
  __strong BaseSchema *schema;
}

-(id) init:(NSString*)messageType messageVersion:(NSString *)msgVersion;
  
-(void) setValue:(id)value forKey:(NSString *)key;
-(BaseSchema*) getSchema:(NSData *)responseData;
-(NSMutableDictionary*) getMessage;
-(NSData*) asData;
-(NSData*) decrypt: (NSData *)response;

@end

#endif /* MessageRequest_h */
