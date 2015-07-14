//
//  MyScrollView.m
//  MyScrollView
//
//  Created by Jeff Huang on 2015-07-14.
//  Copyright (c) 2015 Jeff Huang. All rights reserved.
//

#import "MyScrollView.h"

@interface MyScrollView ()

@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) CGPoint startPoint;

@end

@implementation MyScrollView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];

    if(self){
        if(self.contentSize.height <= 0 && self.contentSize.width <= 0){
            self.contentSize = self.bounds.size; //not sure which to set
        }
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(proceedScroll:)];
        [self.panGesture setMaximumNumberOfTouches:1];
        [self.panGesture setMinimumNumberOfTouches:1];
        
        [self addGestureRecognizer:self.panGesture];
    }
    return self;
}


- (void)proceedScroll:(id)sender{
    UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)sender;
    CGPoint currentLocation = [panGesture locationInView:self];
    if(panGesture.state == UIGestureRecognizerStateBegan){
        NSLog(@"In state began");
        self.startPoint = currentLocation;
    }
    float xMovement = currentLocation.x - self.startPoint.x;
    float yMovement = currentLocation.y - self.startPoint.y;
    if([self scrollRequired]){
        self.bounds = CGRectMake(
                                 [self scrollRemain:self.bounds.origin.x
                                    withDisplacement:xMovement
                                      withDirection:Horizontal
                                  ],
                                 [self scrollRemain:self.bounds.origin.y
                                   withDisplacement:yMovement
                                      withDirection:Vertical
                                  ],
                                 self.bounds.size.width, self.bounds.size.height);
        NSLog(@"Scroll required!");
    }
    
    if(panGesture.state == UIGestureRecognizerStateEnded){
        NSLog(@"In state ended");
    }
}

- (BOOL)scrollRequired{
    for (UIView *v in self.subviews){
        if (v.frame.origin.y + v.frame.size.height > self.frame.size.height) {
            return YES;
        }
        if (v.frame.origin.x + v.frame.size.width > self.frame.size.width) {
            return YES;
        }
    }
    return NO;
}

- (float)scrollRemain:(float)origin withDisplacement:(float) dist withDirection:(Direction) direct{
    float remain = 0;
    float max = 0;
    float min = (self.contentSize.height > self.contentSize.width) ? self.contentSize.height : self.contentSize.width;
    
    switch (direct) {
        case Horizontal:
            remain = self.contentSize.width;
            for(UIView *v in self.subviews){
                if(origin - dist >= 0){
                    if(max < v.bounds.origin.x + v.bounds.size.width)
                        max = v.bounds.origin.x + v.bounds.size.width;
                }
                else{
                    if(min > v.bounds.origin.x)
                        min = v.bounds.origin.x;
                }
            }
            break;
        case Vertical:
            remain = self.contentSize.height;
            for(UIView *v in self.subviews){
                if(origin - dist >= 0){
                    if(max < v.bounds.origin.y + v.bounds.size.height)
                        max = v.bounds.origin.y + v.bounds.size.height;
                }
                else{
                    if(min > v.bounds.origin.y)
                        min = v.bounds.origin.y;
                }
            }
            break;
    }
    if(origin - dist > 0){
        if(max - remain - (origin - dist) > 0)
            return origin - dist;
        else
            return origin;
    }
    else{
        if(remain - min - (origin - dist) > 0)
            return origin - dist;
        else
            return origin;
    }
    
}

@end
