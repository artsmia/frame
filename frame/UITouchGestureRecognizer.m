//
//  UITouchGestureRecognizer.m
//  frame
//
//  Created by Kjell Olsen on 4/24/14.
//  Copyright (c) 2014 Minneapolis Institute of Arts. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UITouchGestureRecognizer.h"

@implementation UITouchGestureRecognizer

- (void) reset
{
    [super reset];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.state = UIGestureRecognizerStateRecognized;
}

@end