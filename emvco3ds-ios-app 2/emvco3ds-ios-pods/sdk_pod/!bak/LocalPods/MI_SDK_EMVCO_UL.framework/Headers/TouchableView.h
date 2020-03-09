#import <UIKit/UIKit.h>

@class TouchableView;

@protocol TouchableLabelDelegate
- (void) touchableLabelTouched:(TouchableView *)sender;
@end

@interface TouchableView : UIView {
@protected
  __strong id<TouchableLabelDelegate> delegate;
  __strong NSString *tagString;
}
- (void) setDelegate:(id<TouchableLabelDelegate>)delegate;
- (void) setTagString:(NSString *)tagString;
- (NSString *)getTagString;
@end
