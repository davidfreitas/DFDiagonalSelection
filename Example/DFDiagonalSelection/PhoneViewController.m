//
//  PhoneViewController.m
//  DFDiagonalSelection
//
//  Created by David Freitas on 5/1/14.
//  Copyright (c) 2014 David Freitas. All rights reserved.
//

#import "PhoneViewController.h"

@interface PhoneViewController ()
@property(nonatomic, strong) DFDiagonalSelection *phoneSelection;
@end

@implementation PhoneViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

// Create and setup the diagonal selection view
//
- (void)configureView
{
    UIImage *iphoneImage = [UIImage imageNamed:@"iphone"];
    UIImage *galaxyImage = [UIImage imageNamed:@"galaxy"];
    
    CGRect frame = CGRectMake(0, 20, 320, CGRectGetHeight(self.view.bounds) - 69);
    self.phoneSelection = [[DFDiagonalSelection alloc] initWithFrame:frame LeftImage:iphoneImage RightImage:galaxyImage];
    self.phoneSelection.delegate = self;
    [self.view addSubview:self.phoneSelection];
}

- (void)diagonalSelection:(DFDiagonalSelection *)diagonalSelection DidSelectOptionAtSide:(DFDiagonalSelectionSide)side
{
    NSString *title;
    if (side == DFDiagonalSelectionLeftSide) {
        title = @"iPhone selected!";
    } else {
        title = @"Galaxy selected!";
    }
    
    [self performSelector:@selector(showAlertWithTitle:) withObject:title afterDelay:.2];
}

- (void)showAlertWithTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.phoneSelection reset];
}


@end
