#import "Settings.h"
@protocol UIController;
@protocol Transaction;
@class StateController;
@class ConfigParameters;
@class UiCustomization;
@class PaymentSystemList;

@interface ThreeDSecurev2ServiceImpl : NSObject {
@protected
  __strong id<UIController> uiController;
  __strong StateController *stateController;
  __strong PaymentSystemList *psList;
}

- (id) init:(id<UIController>)uiController paymentSystemList:(PaymentSystemList *)psList;

- (void) initialize:(ConfigParameters *)configParameters
             locale:(NSString *)locale
    uiCustomization:(UiCustomization *) uiCustomization;
- (id<Transaction>) createTransaction:(NSString *)directoryServerId messageVersion:(NSString *)messageVersion;
- (void) cleanup;
- (NSString *) getSDKVersion;
- (NSArray *) getWarnings;

@end
