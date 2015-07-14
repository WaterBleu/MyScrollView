//
//  MyScrollView.h
//  MyScrollView
//
//  Created by Jeff Huang on 2015-07-14.
//  Copyright (c) 2015 Jeff Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScrollView : UIView

@property (nonatomic) CGSize contentSize;

typedef NS_ENUM(NSInteger, Direction){
    Horizontal,
    Vertical,
};


@end
