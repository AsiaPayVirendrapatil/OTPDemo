#import <Foundation/Foundation.h>

@interface AbstractSettings : NSObject {
@protected
  __strong NSDictionary *dict;
  __strong NSMutableDictionary *userDefaultsDict;
  __strong NSString *userDefaultsKey;
}
- (NSData *)read:(NSString *)fileName;
- (id) getPlistFromData:(NSData *)data;
- (NSString *) getKey:(NSString *)key;

// ---- User Defaults ---

- (void) readUserDefaults:(NSString *)userDefaultsKey;
- (void) saveUserDefaults;
- (NSString *) getUserDefaultsString:(NSString *)key defaultValue:(NSString *)defaultValue;
- (void) setUserDefaultsString:(NSString *)key value:(NSString *)value;
- (BOOL) getUserDefaultsBoolean:(NSString *)key defaultValue:(BOOL)defaultValue;
- (void) setUserDefaultsBoolean:(NSString *)key value:(BOOL)value;
- (NSInteger) getUserDefaultsInt:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (void) setUserDefaultsInt:(NSString *)key value:(NSInteger)value;
- (NSMutableArray *) getUserDefaultsStringArray:(NSString *)key defaultValue:(NSMutableArray *)defaultValue;
- (void) setUserDefaultsStringArray:(NSString *)key value:(NSMutableArray *)value;
- (void) deleteKey:(NSString *)key;

@end
