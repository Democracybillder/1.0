#import "NSString+Escaping.h"

@implementation NSString (Escaping)

- (NSString *)unescapedString {
  return [NSString stringWithCString:[self cStringUsingEncoding:NSUTF8StringEncoding]
                            encoding:NSNonLossyASCIIStringEncoding];
}

@end
