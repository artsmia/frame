//
//  ViewController.m
//  frame
//
//  Created by Kjell Olsen on 4/23/14.
//  Copyright (c) 2014 Minneapolis Institute of Arts. All rights reserved.
//

#import "ViewController.h"
#import "UITouchGestureRecognizer.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
{
    NSTimer *idleTimer;
    NSURL *url;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    url = [NSURL URLWithString:@"http://cdn.dx.artsmia.org/presenter/"];
    [_canvas loadRequest: [NSURLRequest requestWithURL:url]];
    [[_canvas scrollView] setBounces: NO];
    [self becomeFirstResponder];

    [self watchForTouches];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -
#pragma mark If an iPad idles for more than `kMaxIdleTimeSeconds`, reload our home screen.

#define kMaxIdleTimeSeconds 120.0

// delegate touch interaction in the UIWebView to `resetIdleTimer`, which resets the timer on each interaction
- (void)watchForTouches {
    UITouchGestureRecognizer *webViewInteraction = [[UITouchGestureRecognizer alloc]initWithTarget:self action:@selector(resetIdleTimer)];
    webViewInteraction.delegate = self;
    webViewInteraction.cancelsTouchesInView = NO;
    [_canvas addGestureRecognizer:webViewInteraction];

    // MPAVController isn't a public API http://stackoverflow.com/a/8554040/1015111
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suspendIdleTimer:) name:@"MPAVControllerPlaybackStateChangedNotification" object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)resetIdleTimer {
    if (!idleTimer) {
        idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds
                                                     target:self
                                                   selector:@selector(idleTimerExceeded)
                                                   userInfo:nil
                                                    repeats:NO];
    }
    else {
        if (fabs([idleTimer.fireDate timeIntervalSinceNow]) < kMaxIdleTimeSeconds-1.0) {
            [idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
        }
    }
}

- (void)idleTimerExceeded {
    idleTimer = nil;
    [self reloadCanvas];
}

- (void)reloadCanvas {
    [_canvas loadRequest: [NSURLRequest requestWithURL:url]];
}

// Break `idleTimer` when a video plays, reset when paused or done
- (void)suspendIdleTimer:(NSNotification *)notification {
    if ([[notification.userInfo objectForKey:@"MPAVControllerNewStateParameter"] isEqualToNumber:[NSNumber numberWithInt:2]]) {
        // suspend if `…PlaybackState` is 'playing'
        [idleTimer invalidate];
        idleTimer = nil;
    } else {
        [self resetIdleTimer];
    }
}
@end