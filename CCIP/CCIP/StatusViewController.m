//
//  StatusViewController.m
//  CCIP
//
//  Created by 腹黒い茶 on 2016/06/26.
//  Copyright © 2016年 CPRTeam. All rights reserved.
//

#import "AppDelegate.h"
#import "StatusViewController.h"
#import "UIColor+addition.h"
@import AudioToolbox.AudioServices;

@interface StatusViewController()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *countTime;
@property (readwrite, nonatomic) float maxValue;
@property (readwrite, nonatomic) float countDown;
@property (readwrite, nonatomic) NSTimeInterval interval;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (readwrite, nonatomic) BOOL countDownEnd;
@property (readwrite, nonatomic) BOOL needCountdown;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    //NSLog(@"loaded");
}

- (void)viewWillAppear:(BOOL)animated {
    BOOL isKit = [[self.scenario objectForKey:@"id"] isEqualToString:@"kit"];
    NSString *dietType = [[self.scenario objectForKey:@"attr"] objectForKey:@"diet"];
    [self.statusMessageLabel setText:isKit ? NSLocalizedString(@"StatusNotice", nil) : NSLocalizedString([dietType stringByAppendingString:@"Lunch"], nil)];
    [self.noticeTextLabel setText:@""];
    if (!isKit) {
        [self.noticeTextLabel setText:NSLocalizedString(@"UseNoticeText", nil)];
        [self.statusMessageLabel setFont:[UIFont systemFontOfSize:60.0f]];
        if ([dietType isEqualToString:@"meat"]) {
            [self.statusMessageLabel setTextColor:[UIColor colorFromHtmlColor:@"#f8e71c"]];
            [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            [self.noticeTextLabel setTextColor:[UIColor whiteColor]];
            [self.nowTimeLabel setTextColor:[UIColor whiteColor]];
        }
        if ([dietType isEqualToString:@"vegetarian"]) {
            [self.statusMessageLabel setTextColor:[UIColor colorFromHtmlColor:@"#4a90e2"]];
            [self.visualEffectView setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            [self.noticeTextLabel setTextColor:[UIColor blackColor]];
            [self.nowTimeLabel setTextColor:[UIColor blackColor]];
        }
    }
    [self setNeedCountdown:([[self.scenario objectForKey:@"countdown"] floatValue] > 0)];
    [self.countdownLabel setHidden:!self.needCountdown];
    [self setCountDownEnd:NO];
    [self setCountTime:[NSDate new]];
    [self setMaxValue:(float)([[self.scenario objectForKey:@"used"] intValue] + [[self.scenario objectForKey:@"countdown"] intValue] - [self.countTime timeIntervalSince1970])];
    [self setInterval:[[NSDate new] timeIntervalSinceDate:self.countTime]];
    [self setCountDown:(self.maxValue - self.interval)];
    [self setFormatter:[NSDateFormatter new]];
    [self.formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    [self.countdownLabel setText:@""];
    [self.nowTimeLabel setText:@""];
    [self.view setHidden:!self.needCountdown];
}

- (void)viewDidAppear:(BOOL)animated {
    [self startCountDown];
}

- (void)setScenario:(NSDictionary *)scenario {
    _scenario = scenario;
}

- (void)startCountDown {
    [self setCountTime:[NSDate new]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001f
                                                  target:self
                                                selector:@selector(updateCountDown)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)updateCountDown {
    UIColor *color = self.view.tintColor;
    NSDate *now = [NSDate new];
    [self setInterval:[now timeIntervalSinceDate:self.countTime]];
    [self setCountDown:(self.maxValue - self.interval)];
    if (self.countDown <= 0) {
        [self setCountDown:0];
        color = [UIColor redColor];
        if (self.countDownEnd == NO) {
            [((UIViewController *)self.nextResponder).navigationItem.leftBarButtonItem setEnabled:YES];
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25f
                                                          target:self
                                                        selector:@selector(updateCountDown)
                                                        userInfo:nil
                                                         repeats:YES];
            [self setCountDownEnd:YES];
            
            if (self.needCountdown) {
                AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
                    AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
                        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
                            AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
                                AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
                                    [self dismissViewControllerAnimated:YES
                                                             completion:nil];
                                });
                            });
                        });
                    });
                });
            } else {
                [self dismissViewControllerAnimated:YES
                                         completion:nil];
            }
        }
    } else if (self.countDown >= (self.maxValue / 2)) {
        color = [UIColor colorFrom:self.view.tintColor
                                To:[UIColor purpleColor]
                                At:1 - ((self.countDown - (self.maxValue / 2)) / (self.maxValue - (self.maxValue / 2)))];
    } else if (self.countDown >= (self.maxValue / 6)) {
        color = [UIColor colorFrom:[UIColor purpleColor]
                                To:[UIColor orangeColor]
                                At:1 - ((self.countDown - (self.maxValue / 6)) / (self.maxValue - ((self.maxValue / 2) + (self.maxValue / 6))))];
    } else if (self.countDown > 0) {
        color = [UIColor colorFrom:[UIColor orangeColor]
                                To:[UIColor redColor]
                                At:1 - ((self.countDown - 0) / (self.maxValue - (self.maxValue - (self.maxValue / 6))))];
    }
    [self.countdownLabel setTextColor:color];
    [self.countdownLabel setText:[NSString stringWithFormat:@"%0.3f", self.countDown]];
    [self.nowTimeLabel setText:[self.formatter stringFromDate:now]];
}

@end
