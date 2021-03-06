/*
 * Author: Andreas Linde <mail@andreaslinde.de>
 *         Peter Steinberger
 *
 * Copyright (c) 2012 HockeyApp, Bit Stadium GmbH.
 * Copyright (c) 2011-2012 Peter Steinberger.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */


#import "BITAppStoreHeader.h"
#import "BITHockeyHelper.h"
#import "HockeySDKPrivate.h"


#define kLightGrayColor BIT_RGBCOLOR(235, 235, 235)
#define kDarkGrayColor  BIT_RGBCOLOR(186, 186, 186)
#define kWhiteBackgroundColor  BIT_RGBCOLOR(245, 245, 245)
#define kImageHeight 72
#define kImageBorderRadius 12
#define kImageLeftMargin 14
#define kImageTopMargin 12
#define kTextRow kImageTopMargin*2 + kImageHeight

@implementation BITAppStoreHeader


#pragma mark - NSObject

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = kWhiteBackgroundColor;
  }
  return self;
}


#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
  CGRect bounds = self.bounds;
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // draw the gradient
  NSArray *colors = [NSArray arrayWithObjects:(id)kDarkGrayColor.CGColor, (id)kLightGrayColor.CGColor, nil];
  CGGradientRef gradient = CGGradientCreateWithColors(CGColorGetColorSpace((__bridge CGColorRef)[colors objectAtIndex:0]), (__bridge CFArrayRef)colors, (CGFloat[2]){0, 1});
  CGPoint top = CGPointMake(CGRectGetMidX(bounds), bounds.size.height - 3);
  CGPoint bottom = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
  CGContextDrawLinearGradient(context, gradient, top, bottom, 0);
  CGGradientRelease(gradient);
  
  // icon
  [_iconImage drawAtPoint:CGPointMake(kImageLeftMargin, kImageTopMargin)];
}


- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat globalWidth = self.frame.size.width;
  
  // draw header name
  UIColor *mainTextColor = BIT_RGBCOLOR(61, 61, 61);
  UIColor *secondaryTextColor = BIT_RGBCOLOR(100, 100, 100);
  UIFont *mainFont = [UIFont boldSystemFontOfSize:15];
  UIFont *secondaryFont = [UIFont systemFontOfSize:10];
  
  UILabel *headerLabelView = [[UILabel alloc] init];
  [headerLabelView setFont:mainFont];
  [headerLabelView setFrame:CGRectMake(kTextRow, kImageTopMargin, globalWidth-kTextRow, 20)];
  [headerLabelView setTextColor:mainTextColor];
  [headerLabelView setBackgroundColor:[UIColor clearColor]];
  [headerLabelView setText:_headerLabel];
  [self addSubview:headerLabelView];
  
  // middle
  UILabel *middleLabelView = [[UILabel alloc] init];
  [middleLabelView setFont:secondaryFont];
  [middleLabelView setFrame:CGRectMake(kTextRow, kImageTopMargin + 17, globalWidth-kTextRow, 20)];
  [middleLabelView setTextColor:secondaryTextColor];
  [middleLabelView setBackgroundColor:[UIColor clearColor]];
  [middleLabelView setText:_subHeaderLabel];
  [self addSubview:middleLabelView];
}


#pragma mark - Properties

- (void)setHeaderLabel:(NSString *)anHeaderLabel {
  if (_headerLabel != anHeaderLabel) {
    _headerLabel = [anHeaderLabel copy];
    [self setNeedsDisplay];
  }
}

- (void)setSubHeaderLabel:(NSString *)aSubHeaderLabel {
  if (_subHeaderLabel != aSubHeaderLabel) {
    _subHeaderLabel = [aSubHeaderLabel copy];
    [self setNeedsDisplay];
  }
}

- (void)setIconImage:(UIImage *)anIconImage {
  if (_iconImage != anIconImage) {
    
    // scale, make borders and reflection
    _iconImage = bit_imageToFitSize(anIconImage, CGSizeMake(kImageHeight, kImageHeight), YES);
    _iconImage = bit_roundedCornerImage(_iconImage, kImageBorderRadius, 0.0);
    
    [self setNeedsDisplay];
  }
}

@end
