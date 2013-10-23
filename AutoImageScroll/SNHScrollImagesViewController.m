//
//  SNHScrollImagesViewController.m
//  AutoImageScroll
//
//  Created by mac on 10/23/13.
//  Copyright (c) 2013 Sunith. All rights reserved.
//

#import "SNHScrollImagesViewController.h"

@interface SNHScrollImagesViewController ()
{
    IBOutlet UIScrollView *scrollView;
    UIView *singleView;
    NSTimer *timer;
    int scrollX ;
    
    //temp demo
    
    NSArray *arrayColor;
}
@end

@implementation SNHScrollImagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Here I want to scroll different colors. So I am adding those colors to an array.
    arrayColor = @[[UIColor blueColor],[UIColor greenColor],[UIColor redColor],[UIColor yellowColor],[UIColor lightGrayColor],[UIColor redColor],[UIColor blueColor],[UIColor blackColor]];
    
    [self scrollImages];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // this timer will Continuously call the automaticScroll function.
    timer=[NSTimer scheduledTimerWithTimeInterval:(3) target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    // invalidating the time when view disppears
    [timer invalidate];
    [super viewWillDisappear:YES];
}

-(void)scrollImages
{
    // Here I need a horizontal scrolling.
    // So I used a scroll view with static height (CGSize height)
    // but width will changes with respect[ect to number of scroll, here colors.
    // Here I placed button to set action for touch.
    
    NSUInteger j;
    int xCoord=5;
    int yCoord=5;
    int buttonWidth=145;
    int buttonHeight=145;
    int buffer = 10;
    for (j = 0; j < [arrayColor count]; j++)
    {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.frame     = CGRectMake(xCoord, yCoord,buttonWidth,buttonHeight );
        [aButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [aButton setTag:j];
        [aButton setBackgroundColor:[arrayColor objectAtIndex:j]];
        xCoord += buttonWidth +buffer;
        CALayer * layer = [aButton layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:3];
        [scrollView addSubview:aButton];
    }
    [scrollView setContentSize:CGSizeMake(xCoord, 145)];
}
- (void) buttonClicked:(UIButton *) btn
{
    NSLog(@"button %d clicked",btn.tag+1);
}

#pragma mark - scroll images

//For automatic scrolling
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (sender == scrollView)
    {
        CGFloat pageWidth = scrollView.frame.size.width ;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        
        // Since there are four images in scroll view at atime, we diveding the image count by 4 and checking it with "nearestNumber". When it became same, means whole images shown and need to restart from first image.
        
        NSInteger nearestNumber = floor(fractionalPage) ;
        
        // The belove checking cretiria get from the number of scroll in single view.
        //ie; here number of colors in single view.
        if (nearestNumber==[arrayColor count]/2-1) {
            [timer invalidate];
            scrollX=0;
            timer=[NSTimer scheduledTimerWithTimeInterval:(4) target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
        }
    }
}

- (void) automaticScroll {
    
    // changing the x value
    [scrollView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
    scrollX+=scrollView.frame.size.width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
