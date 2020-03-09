#import "Customization.h"

@interface ToolbarCustomization : Customization {
@private
  __strong NSString *backgroundColor;
  __strong NSString *headerText;
  __strong NSString *buttonText;
}

- (void) setBackgroundColor:(NSString *)color;
- (void) setHeaderText:(NSString *)text;
- (void) setButtonText:(NSString *)text;
- (NSString *) getBackgroundColor;
- (NSString *) getHeaderText;
- (NSString *) getButtonText;
+ (ToolbarCustomization *) createCopy:(ToolbarCustomization *)origCustomization;

@end
