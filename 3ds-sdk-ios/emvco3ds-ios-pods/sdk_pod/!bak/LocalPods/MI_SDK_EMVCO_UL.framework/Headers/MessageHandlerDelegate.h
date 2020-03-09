
#ifndef MessageHandlerDelegate_h
#define MessageHandlerDelegate_h
#import <Foundation/Foundation.h>

@protocol MessageHandlerDelegate <NSObject>

/* Contract is that if the error is not nil, the json is and other way round */
-(void) complete:(NSDictionary*) json error:(NSError*) err;

@end

#endif /* MessageHandlerDelegate_h */
