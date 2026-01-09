#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ESPの描画用ビュー
@interface MyESPView : UIView
@property (nonatomic, assign) BOOL isEnabled;
@end

@implementation MyESPView
- (void)drawRect:(CGRect)rect {
    if (!self.isEnabled) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); // 赤い枠線
    CGContextSetLineWidth(context, 2.0);
    
    // 画面の真ん中らへんに枠を描くじょ
    CGContextStrokeRect(context, CGRectMake(rect.size.width/2 - 50, rect.size.height/2 - 50, 100, 100));
}
@end

static MyESPView *espView;

// ボタンが押された時の動作
@interface ESPMenu : NSObject
+ (void)toggleESP;
@end

@implementation ESPMenu
+ (void)toggleESP {
    espView.isEnabled = !espView.isEnabled;
    [espView setNeedsDisplay]; // 再描画を命令するニダ！
    printf("ESP Status: %s\n", espView.isEnabled ? "ON" : "OFF");
}
@end

__attribute__((constructor))
static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }

        if (window) {
            // 1. ESPビューを準備
            espView = [[MyESPView alloc] initWithFrame:window.bounds];
            espView.backgroundColor = [UIColor clearColor];
            espView.userInteractionEnabled = NO;
            espView.isEnabled = NO; // 最初はOFF
            [window addSubview:espView];

            // 2. 画面の端っこに「ON/OFFボタン」を作るじょ
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.frame = CGRectMake(50, 100, 80, 40);
            btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            [btn setTitle:@"ESP: OFF" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 10;

            // ボタンを押した時のイベント
            [btn addTarget:[ESPMenu class] action:@selector(toggleESP) forControlEvents:UIControlEventTouchUpInside];
            
            // ボタンの文字を切り替えるおまけ
            [btn addTarget:btn action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchDown]; // 簡易的な更新用

            [window addSubview:btn];
        }
    });
}
