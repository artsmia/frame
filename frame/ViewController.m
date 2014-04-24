//
//  ViewController.m
//  frame
//
//  Created by Kjell Olsen on 4/23/14.
//  Copyright (c) 2014 Minneapolis Institute of Arts. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *canvas;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://cdn.dx.artsmia.org/presenter/"];
    [_canvas loadRequest: [NSURLRequest requestWithURL:url]];
    [[_canvas scrollView] setBounces: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
