#import <Foundation/Foundation.h>

@interface AuthenticationRequestParameters : NSObject {
}
@property (nonatomic, retain) NSString *deviceData;
@property (nonatomic, retain) NSString *sdkTransactionID;
@property (nonatomic, retain) NSString *sdkAppID;
@property (nonatomic, retain) NSString *sdkReferenceNumber;
@property (nonatomic, retain) NSString *sdkEphemeralPublicKey;
@property (nonatomic, retain) NSString *messageVersion;

- (id) init:(NSString *)sdkTransID deviceData:(NSString *)devData sdkEphemeralPubKey:(NSString *)pubKey
   sdkAppID:(NSString *)appID sdkReferenceNumber:(NSString *)refNumber messageVersion:(NSString *)msgVersion;

@end
