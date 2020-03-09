#import "Customization.h"

@interface TextBoxCustomization : Customization {
@private
  NSInteger borderWidth;
  __strong NSString *borderColor;
  NSInteger cornerRadius;
}

- (void) setBorderWidth:(NSInteger)width;
- (void) setBorderColor:(NSString *)color;
- (void) setCornerRadius:(NSInteger)radius;
- (NSInteger) getBorderWidth;
- (NSString *) getBorderColor;
- (NSInteger) getCornerRadius;
+ (TextBoxCustomization *) createCopy:(TextBoxCustomization *)origCustomization;

@end
