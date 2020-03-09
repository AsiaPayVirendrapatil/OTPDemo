#import "ButtonCustomization.h"
#import "ToolbarCustomization.h"
#import "LabelCustomization.h"
#import "TextBoxCustomization.h"

@interface UiCustomization : NSObject {
@private
  __strong NSMutableDictionary *buttonCustomization;
  __strong NSMutableDictionary *implementerButtonCustomization;
  __strong ToolbarCustomization *toolbarCustomization;
  __strong LabelCustomization *labelCustomization;
  __strong TextBoxCustomization *textBoxCustomization;
}

typedef NS_ENUM(NSUInteger, ButtonType) {
  SUBMIT,
  CONTINUE,
  NEXT,
  CANCEL,
  RESEND
};

- (void) setButtonCustomization:(ButtonCustomization *)customization buttonType:(ButtonType)type;
- (void) setButtonCustomization:(ButtonCustomization *)customization type:(NSString *)type;
- (void) setToolbarCustomization:(ToolbarCustomization *)customization;
- (void) setLabelCustomization:(LabelCustomization *)customization;
- (void) setTextBoxCustomization:(TextBoxCustomization *)customization;
- (ButtonCustomization *) getButtonCustomization:(ButtonType)type;
- (ButtonCustomization *) getButtonCustomizationForType:(NSString *)type; //Note: objective-c does not support method overloading
- (ToolbarCustomization *) getToolbarCustomization;
- (LabelCustomization *) getLabelCustomization;
- (TextBoxCustomization *) getTextBoxCustomization;
+ (UiCustomization *) createCopy:(UiCustomization *)origCustomization;

@end
