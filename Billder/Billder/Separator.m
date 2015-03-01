#import "Separator.h"

@implementation Separator

+ (instancetype)horizontalSeparatorWithYOrigin:(CGFloat)yOrigin {
  Separator *separator = [[self alloc] initWithFrame:CGRectMake(0, yOrigin, [[UIScreen mainScreen] bounds].size.width, 1)];
  separator.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
  return separator;
}

@end
