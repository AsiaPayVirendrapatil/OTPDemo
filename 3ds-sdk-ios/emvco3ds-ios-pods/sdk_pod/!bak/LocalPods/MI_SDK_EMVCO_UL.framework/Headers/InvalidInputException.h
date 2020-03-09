#import <Foundation/Foundation.h>

@interface InvalidInputException : NSError

@property (nonatomic, retain) NSString* message;

- (id) init:(NSString *)errorMessage;

@end
