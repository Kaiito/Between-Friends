//
//  UIView+ReFrame.h
//  Ethan
//
//  Created by Richard Christophe on 15/07/11.
//  Copyright 2011 Wamite. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (ReFrame)

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)addHeight:(CGFloat)height;
- (void)addX:(CGFloat)x;
- (void)addY:(CGFloat)y;

@end


@interface UIView (SubviewsHeightSum)
- (CGFloat)subviewsHeightSum;
- (CGFloat)subviewsMaxHeight;
@end