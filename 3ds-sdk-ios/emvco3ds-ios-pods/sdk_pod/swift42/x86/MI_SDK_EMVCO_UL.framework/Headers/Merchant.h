@protocol MerchantTransaction;
@class UiCustomization;

@protocol Merchant

- (void) initialize:(NSLocale *)locale
    uiCustomization:(UiCustomization *) uiCustomization;

- (id<MerchantTransaction>) createTransaction:(NSString *)paymentSystemId;

- (id<MerchantTransaction>) createTransaction:(NSString *)paymentSystemId messageVersion:(NSString *)messageVersion;

- (void) cleanup;

- (NSString *) getSDKVersion;

- (NSArray *) getWarnings;

@end
