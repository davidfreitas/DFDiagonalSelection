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

#import <UIKit/UIKit.h>

typedef enum {
    DFDiagonalSelectionLeftSide,
    DFDiagonalSelectionRightSide
} DFDiagonalSelectionSide;

@protocol DFDiagonalSelectionDelegate;

@interface DFDiagonalSelection : UIView

// Set the images for each side of the component
//
@property(nonatomic, strong) UIImage *leftImage;
@property(nonatomic, strong) UIImage *rightImage;

// Delegate to handle the selection
//
@property(nonatomic, weak) id<DFDiagonalSelectionDelegate> delegate;

// Creates the selector
// @parameters
//     frame: position and size on its superview
//     leftImage: image showed on the left side of the component
//     rightImage: image showed on the right side of the component
//
- (id)initWithFrame:(CGRect)frame LeftImage:(UIImage *)leftImage RightImage:(UIImage *)rightImage;

// Resets the component to its initial state, allowing the selection again
//
- (void)reset;

@end

@protocol DFDiagonalSelectionDelegate <NSObject>

// Handles the selection of one of the sides of the component
//
- (void)diagonalSelection:(DFDiagonalSelection *)diagonalSelection DidSelectOptionAtSide:(DFDiagonalSelectionSide)side;

@end