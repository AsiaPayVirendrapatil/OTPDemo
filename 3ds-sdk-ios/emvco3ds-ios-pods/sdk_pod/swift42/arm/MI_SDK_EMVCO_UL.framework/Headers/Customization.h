#import <Foundation/Foundation.h>

@interface Customization : NSObject {
@protected
  __strong NSString *textFontName;
  NSInteger textFontSize;
  __strong NSString *textColor;
}

- (void) setTextFontName:(NSString *)fontName;
- (void) setTextFontSize:(NSInteger)fontSize;
- (void) setTextColor:(NSString *)color;
- (NSString *) getTextFontName;
- (NSInteger) getTextFontSize;
- (NSString *) getTextColor;
- (BOOL) isInvalidColor:(NSString *)color;
- (BOOL) isInvalidFontName:(NSString *)fontName;
- (BOOL) isInvalidFontSize:(NSInteger)fontSize;

@end
