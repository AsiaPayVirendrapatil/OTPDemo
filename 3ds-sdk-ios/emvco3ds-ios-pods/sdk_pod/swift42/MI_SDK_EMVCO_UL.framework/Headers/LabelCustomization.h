#import "Customization.h"

@interface LabelCustomization : Customization {
@private
  __strong NSString *headingTextColor;
  __strong NSString *headingTextFontName;
  NSInteger headingTextFontSize;
}

- (void) setHeadingTextColor:(NSString *)color;
- (void) setHeadingTextFontName:(NSString *)fontName;
- (void) setHeadingTextFontSize:(NSInteger)fontSize;
- (NSString *) getHeadingTextColor;
- (NSString *) getHeadingTextFontName;
- (NSInteger) getHeadingTextFontSize;
+ (LabelCustomization *) createCopy:(LabelCustomization *)origCustomization;

@end
