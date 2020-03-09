#import "Customization.h"

@interface ButtonCustomization : Customization {
@private
  __strong NSString *backgroundColor;
  NSInteger cornerRadius;
}

- (void) setBackgroundColor:(NSString *)color;
- (void) setCornerRadius:(NSInteger)radius;
- (NSString *) getBackgroundColor;
- (NSInteger) getCornerRadius;
+ (ButtonCustomization *) createCopy:(ButtonCustomization *)origCustomization;

@end
