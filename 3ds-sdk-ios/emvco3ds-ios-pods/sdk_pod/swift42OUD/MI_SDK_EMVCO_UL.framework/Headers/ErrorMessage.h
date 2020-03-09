#import <Foundation/Foundation.h>

@interface ErrorMessage : NSObject

@property (nonatomic, retain) NSString *transactionID;
@property (nonatomic, retain) NSString *errorCode;
@property (nonatomic, retain) NSString *errorDescription;
@property (nonatomic, retain) NSString *errorDetail;
@property (nonatomic, retain) NSString *errorComponent;
@property (nonatomic, retain) NSString *errorMessageType;

- (id) init:(NSString *)transID errorCode:(NSString *)errCode
        errorDescription:(NSString *)description errorDetail:(NSString *)detail;
- (id) init:(NSString *)transID errorCode:(NSString *)errCode
        errorDescription:(NSString *)description errorDetail:(NSString *)detail
        errorComponent:(NSString *)component errorMessageType:(NSString *)msgType;

@end
