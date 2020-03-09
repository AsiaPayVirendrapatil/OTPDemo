#import "Transaction.h"

@class ConfigParameters;
@class UiCustomization;

@protocol ThreeDS2Service

- (void) initialize:(ConfigParameters *)configParameters
             locale:(NSString *)locale
    uiCustomization:(UiCustomization *) uiCustomization;

- (id<Transaction>) createTransaction:(NSString *)directoryServerId messageVersion:(NSString *)messageVersion;

- (void) cleanup;

- (NSString *) getSDKVersion;

- (NSArray *) getWarnings;

@end
