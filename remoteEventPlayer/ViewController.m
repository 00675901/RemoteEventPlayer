//
//  ViewController.m
//  remoteEventPlayer
//
//  Created by GgYyer on 16/6/26.
//  Copyright © 2016年 soloPro. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    NSLog(@"fasdfgfdgsdfgsa");
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"]] error:nil];
    _player.volume = 1.0; //0.0-1.0之间
    _player.numberOfLoops = 3; //默认只播放一次

    //设置播放会话，在后台可以继续播放（还需要设置程序允许后台运行模式）
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (![[AVAudioSession sharedInstance] setActive:YES error:nil]) {
        NSLog(@"Failed to set up a session.");
    }

    //    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, nil);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];

    //启用远程控制事件接收
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playerBtnEvnt:(UIButton *)sender {
    [_player play];
}
- (IBAction)stopBtnEvnt:(UIButton *)sender {
    [_player stop];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark 远程控制事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    NSLog(@"%i,%i", event.type, event.subtype);
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                //                [_player play];
                //                _isPlaying=true;
                NSLog(@"111111...");
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                //                if (_isPlaying) {
                //                    [_player pause];
                //                }else{
                //                    [_player play];
                //                }
                //                _isPlaying=!_isPlaying;
                NSLog(@"2222222...");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"Next...");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"Previous...");
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                NSLog(@"Begin seek forward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                NSLog(@"End seek forward...");
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                NSLog(@"Begin seek backward...");
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                NSLog(@"End seek backward...");
                break;
            default:
                break;
        }
    }
}

- (void)outputDeviceChanged:(NSNotification *)notification {
    NSLog(@"耳机！");
}

//触发的监听事件
void audioRouteChangeListenerCallback(void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize, const void *inPropertyValue) {
    // ensure that this callback was invoked for a route change
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    {
        // Determines the reason for the route change, to ensure that it is not
        //      because of a category change.
        CFDictionaryRef routeChangeDictionary = (CFDictionaryRef)inPropertyValue;

        CFNumberRef routeChangeReasonRef = (CFNumberRef)CFDictionaryGetValue(routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
        SInt32 routeChangeReason;
        CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);

        if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {

            //Handle Headset Unplugged

            NSLog(@"没有耳机！");

        } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
            //Handle Headset plugged in
            NSLog(@"有耳机！");
        }
    }
}

@end
