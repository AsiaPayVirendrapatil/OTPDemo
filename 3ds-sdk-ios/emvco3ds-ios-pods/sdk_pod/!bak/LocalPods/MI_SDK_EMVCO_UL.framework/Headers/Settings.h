#import <UIKit/UIKIt.h>

#import "AbstractSettings.h"

@interface Settings : AbstractSettings {
@protected
  BOOL configurationRead;
}
@property (nonatomic) BOOL acsForceHttps;
@property (nonatomic) BOOL acsVerifyServerCertificate;
@property (nonatomic) BOOL acsAllowSelfSignedCertificate;
@property (nonatomic) NSString *sdkReferenceNumber;
@property (nonatomic) NSString *sdkBuildVersion;
@property (nonatomic) NSString *sdkCommitHash;

+ (Settings *) getInstance;
+ (NSData *) readSettingsFromFile:(NSString *)filename type:(NSString *)type;

- (void) loadSettings;
- (NSString *) getResourceString:(NSString *)key;
- (UIImage *) getResourceImage:(NSString *)filename;
- (NSString *) getSDKReferenceNumber;
- (NSString *) getSDKVersion:(BOOL)includeCommitHash;
@end
