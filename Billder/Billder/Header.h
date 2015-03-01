#import <UIKit/UIKit.h>

extern const CGFloat kTextXOrigin;

@interface Header : UIView

- (instancetype)initWithWidth:(CGFloat)width title:(NSString *)title hasSettings:(BOOL)hasSettings hasCloseButton:(BOOL)hasCloseButton;

@end
