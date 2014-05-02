//
//  ViewController.m
//  DFDiagonalSelection
//
//  Created by David Freitas on 4/30/14.
//  Copyright (c) 2014 David Freitas. All rights reserved.
//

#import "GenderViewController.h"

@interface GenderViewController ()
@property(nonatomic, strong) DFDiagonalSelection *genderSelection;
@end

@implementation GenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

// Create and setup the diagonal selection view
//
- (void)configureView
{
    UIImage *femaleImage = [UIImage imageNamed:@"gender_f"];
    UIImage *maleImage = [UIImage imageNamed:@"gender_m"];

    CGRect frame = CGRectMake(0, 20, 320, CGRectGetHeight(self.view.bounds) - 69);
    self.genderSelection = [[DFDiagonalSelection alloc] initWithFrame:frame LeftImage:femaleImage RightImage:maleImage];
    self.genderSelection.delegate = self;
    [self.view addSubview:self.genderSelection];
}

- (void)diagonalSelection:(DFDiagonalSelection *)diagonalSelection DidSelectOptionAtSide:(DFDiagonalSelectionSide)side
{
    NSString *title;
    if (side == DFDiagonalSelectionLeftSide) {
        title = @"Female selected!";
    } else {
        title = @"Male selected!";
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
    [self.genderSelection reset];
}

@end
