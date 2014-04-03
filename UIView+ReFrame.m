//
//  UIView+ReFrame.m
//  Ethan
//
//  Created by Richard Christophe on 15/07/11.
//  Copyright 2011 Wamite. All rights reserved.
//

#import "UIView+ReFrame.h"


@implementation UIView (ReFrame)

-(void)setX:(CGFloat)x 
{
	self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

-(void)setY:(CGFloat)y 
{
	self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

-(void)setWidth:(CGFloat)width 
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

-(void)setHeight:(CGFloat)height 
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)addHeight:(CGFloat)height
{
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+height);
}
- (void)addX:(CGFloat)x 
{
  self.frame = CGRectMake(self.frame.origin.x+x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)addY:(CGFloat)y
{
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+y, self.frame.size.width, self.frame.size.height);
}
@end


@implementation UIView (SubviewsHeightSum)
-(CGFloat)subviewsHeightSum 
{
	CGFloat sum = 0;
	for (UIView *view in self.subviews) {
		sum += view.frame.size.height;
	} 
	return sum;
}
- (CGFloat)subviewsMaxHeight 
{
  
	CGFloat max = 0;
	for (UIView *view in self.subviews) {
		CGFloat viewHeight = view.frame.size.height + view.frame.origin.y;
		if (viewHeight > max) {
			max = viewHeight;
		}
	} 
	return max;		
}

@end