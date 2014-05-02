//
//  DFDiagonalSelection
//
//  Created by David Freitas on 05/01/14.
//  Copyright (c) 2014 David Freitas. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "DFDiagonalSelection.h"

@interface DFDiagonalSelection ()

@property(strong, nonatomic) UIImageView *leftImageView;
@property(strong, nonatomic) UIImageView *rightImageView;
@property(assign, nonatomic) CGMutablePathRef rightSidePath;
@property(assign, nonatomic) CALayer *diagonalShapeLayer;
@property(assign, nonatomic) DFDiagonalSelectionSide selectedSide;
@property(assign, nonatomic) BOOL selected;

- (void)setup;
- (CALayer *)maskLayerForCurrentBounds;
- (void)rotateDiagonal;
- (void)moveDiagonalWithDirection:(NSInteger)direction;
- (void)scaleDiagonalWithDirection:(NSInteger)direction;

- (void)handleTouchDown:(UITouch *)touch;
- (void)handleTouchUp:(UITouch *)touch;

@end

@implementation DFDiagonalSelection

#pragma mark - Setup

- (id)initWithFrame:(CGRect)frame LeftImage:(UIImage *)leftImage RightImage:(UIImage *)rightImage
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftImage = leftImage;
        self.rightImage = rightImage;
        
        [self setup];
        [self rotateDiagonal];
    }
    return self;
}

// Setup the individual elements of the component
//
- (void)setup
{
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];

    // images
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    leftImageView.image = self.leftImage;
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    rightImageView.image = self.rightImage;
    
    UIView *rightImageContainer = [[UIView alloc] initWithFrame:self.bounds];
    rightImageContainer.backgroundColor = [UIColor blackColor];
    
    [self addSubview:leftImageView];
    [rightImageContainer addSubview:rightImageView];
    [self addSubview:rightImageContainer];
    
    self.leftImageView = leftImageView;
    self.rightImageView = rightImageView;
    
    // mask for the diagonal clipping
    CALayer *mask = [self maskLayerForCurrentBounds];
    rightImageContainer.layer.mask = mask;
    self.diagonalShapeLayer = mask;
}

// Reset state to before selecting
//
- (void)reset
{
    self.selected = NO;
    self.leftImageView.alpha = 1.0;
    self.rightImageView.alpha = 1.0;
    
    CALayer *mask = [self maskLayerForCurrentBounds];
    self.rightImageView.superview.layer.mask = mask;
    self.diagonalShapeLayer = mask;
    
    [self rotateDiagonal];
}

- (void)setLeftImage:(UIImage *)leftImage
{
    _leftImage = leftImage;
    self.leftImageView.image = leftImage;
}

- (void)setRightImage:(UIImage *)rightImage
{
    _rightImage = rightImage;
    self.rightImageView.image = rightImage;
}

// Create a mask according to current bounds to allow rotation
//
- (CALayer *)maskLayerForCurrentBounds
{
    CGRect r = self.bounds;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, nil, r.origin.x, r.origin.y);
    CGPathAddLineToPoint(path, nil, r.size.width * 2, r.origin.y);
    CGPathAddLineToPoint(path, nil, r.size.width * 2, r.size.height * 2);
	CGPathCloseSubpath(path);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width * 2, self.bounds.size.height * 2), NO, 0.0);
    CGContextAddPath(UIGraphicsGetCurrentContext(), path);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor colorWithWhite:0.0 alpha:1.0] CGColor]);
    CGContextFillPath(UIGraphicsGetCurrentContext());
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.rightSidePath = path;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.bounds = (CGRect){CGPointMake(0, 0), maskImage.size};
    maskLayer.frame = (CGRect){CGPointMake(maskImage.size.width / 4 * -1, maskImage.size.height / 4 * -1), maskImage.size};
    maskLayer.contents = (__bridge id)([maskImage CGImage]);
    
    return maskLayer;
}

#pragma mark - Animation

// Rotates the clipping mask
//
- (void)rotateDiagonal
{
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    ba.removedOnCompletion = NO;
    ba.fillMode = kCAFillModeForwards;
    ba.additive = YES;
    ba.duration = .8;
    ba.cumulative = YES;
    CAMediaTimingFunction *timing = [CAMediaTimingFunction functionWithControlPoints:0.85 :0.1 :0.3 :0.9];
    ba.timingFunction = timing;
    ba.fromValue = [NSNumber numberWithFloat:M_PI];
    ba.toValue = [NSNumber numberWithFloat:M_PI * 2];
    [self.diagonalShapeLayer addAnimation:ba forKey:nil];
}

// Moves the clipping mask
//
- (void)moveDiagonalWithDirection:(NSInteger)direction
{
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    ba.removedOnCompletion = NO;
    ba.fillMode = kCAFillModeForwards;
    ba.duration = .7;
    ba.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ba.toValue = [NSNumber numberWithFloat:direction * (self.bounds.size.width / 10)];
    [self.diagonalShapeLayer addAnimation:ba forKey:nil];
}

// Scales the clipping maske
//
- (void)scaleDiagonalWithDirection:(NSInteger)direction
{
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DScale(transform, 2, 2, 1);
    transform = CATransform3DTranslate(transform, self.bounds.size.width / 3 * direction, self.bounds.size.height / 3 * -direction, 0);
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform"];
    ba.removedOnCompletion = NO;
    ba.fillMode = kCAFillModeForwards;
    ba.duration = .5;
    ba.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ba.toValue = [NSValue valueWithCATransform3D:transform];
    ba.delegate = self;
    [self.diagonalShapeLayer addAnimation:ba forKey:nil];
}

// Handles the end of the scale animation, wich indicates that a side was selected
//
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.delegate diagonalSelection:self DidSelectOptionAtSide:self.selectedSide];
}


#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.selected) {
        [self handleTouchDown:[touches anyObject]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.selected) {
        [self handleTouchDown:[touches anyObject]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.selected) {
        [self handleTouchUp:[touches anyObject]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.selected) {
        [self handleTouchUp:[touches anyObject]];
    }
}

- (void)handleTouchDown:(UITouch *)touch
{
    if (CGPathContainsPoint(self.rightSidePath, NULL, [touch locationInView:self], FALSE)) {
        self.selectedSide = DFDiagonalSelectionRightSide;
        [self moveDiagonalWithDirection:-1];
        [UIView animateWithDuration:0.5 animations:^{
            self.leftImageView.alpha = 0.8;
            self.rightImageView.alpha = 1.0;
        }];
    } else {
        self.selectedSide = DFDiagonalSelectionLeftSide;
        [self moveDiagonalWithDirection:1];
        [UIView animateWithDuration:0.5 animations:^{
            self.leftImageView.alpha = 1.0;
            self.rightImageView.alpha = 0.8;
        }];
    }
}

- (void)handleTouchUp:(UITouch *)touch
{
    self.selected = YES;
    
    if (CGPathContainsPoint(self.rightSidePath, NULL, [touch locationInView:self], FALSE)) {
        [self scaleDiagonalWithDirection:-1];
    } else {
        [self scaleDiagonalWithDirection:1];
    }
}

@end
