#import <UIKit/UIKit.h>

@class TouchableImageView;

@protocol TouchableImageViewDelegate
- (void) touchableImageViewTouched:(TouchableImageView *)sender;
@end

@interface TouchableImageView : UIImageView {
@protected
  __strong id<TouchableImageViewDelegate> delegate;
  __strong NSString *tagString;
}
- (void) setDelegate:(id<TouchableImageViewDelegate>)delegate;
- (void) setTagString:(NSString *)tagString;
- (NSString *)getTagString;
@end
