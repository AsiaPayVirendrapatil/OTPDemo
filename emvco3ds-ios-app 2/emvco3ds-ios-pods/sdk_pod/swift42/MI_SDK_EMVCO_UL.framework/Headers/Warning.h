#import <Foundation/Foundation.h>

@interface Warning : NSObject

typedef NS_ENUM(NSUInteger, Severity) {
  LOW,
  MEDIUM,
  HIGH
};

@property (nonatomic, retain) NSString* warningID;
@property (nonatomic, retain) NSString* message;
@property (nonatomic) Severity severity;

- (id) init:(NSString *)warnID message:(NSString *)msg severity:(Severity)sev;

@end
