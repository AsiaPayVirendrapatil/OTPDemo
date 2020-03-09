#import <Foundation/Foundation.h>

@interface ConfigParameters : NSObject

- (void) addParam:(NSString*)group name:(NSString*)paramName value:(NSString*)paramValue;

- (NSString*) getParam:(NSString*)group name:(NSString*)paramName;

- (NSString*) removeParam:(NSString*)group name:(NSString*)paramName;

+ (ConfigParameters *) createCopy:(ConfigParameters *)origParams;

@end
