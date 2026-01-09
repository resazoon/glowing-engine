#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyESPView : UIView
@end

@implementation MyESPView
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextFillRect(context, CGRectMake(100, 100, 100, 100)); 
}
@end

__attribute__((constructor))
static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
        if (window) {
            MyESPView *esp = [[MyESPView alloc] initWithFrame:window.bounds];
            esp.backgroundColor = [UIColor clearColor];
            esp.userInteractionEnabled = NO;
            [window addSubview:esp];
        }
    });
}
