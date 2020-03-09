#import "ThreeDS2Service.h"
#import "UIController.h"
#import "ThreeDSecurev2ServiceImpl.h"

@class PaymentSystemList;

@interface ThreeDSecurev2Service : NSObject <ThreeDS2Service, UIController> {
@protected
  __strong ThreeDSecurev2ServiceImpl *impl;
}

@end
