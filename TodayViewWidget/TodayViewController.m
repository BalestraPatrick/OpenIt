//
//  TodayViewController.m
//  TodayViewWidget
//
//  Created by Patrick Balestra on 18/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
@import QuartzCore;

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) NSArray *actions;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat edgesPadding;
@property (nonatomic) CGFloat buttonsPadding;

@end

@implementation TodayViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:) name:NSUserDefaultsDidChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPreferredContentSize:CGSizeMake(0, 45)];

    self.actions = [NSArray new];

    self.edgesPadding = 15.0;
    self.buttonsPadding = 10.0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.screenWidth = self.view.frame.size.width;
    [self updateUI];
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    defaultMarginInsets.bottom = 0;
    defaultMarginInsets.left = 0;
    return defaultMarginInsets;
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self updateUI];
}

- (void)updateUI {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.actions"];
    self.actions = [defaults objectForKey:@"actions"];
    
    if (self.actions.count > 0) {
        
        __block CGRect frame = CGRectMake(0, 10, 0, 25);
        
        CGFloat spaceAvailable = self.screenWidth - (2 * self.edgesPadding);
        NSInteger numberOfButtonsInARow = 3;
        if (spaceAvailable > 400.0) {
            numberOfButtonsInARow = 4;
        }
        CGFloat buttonWidth = (spaceAvailable - ((numberOfButtonsInARow - 1) * self.buttonsPadding)) / numberOfButtonsInARow;
        frame.size.width = buttonWidth;
        
        NSInteger numberOfRows = (self.actions.count % numberOfButtonsInARow) == 0 ? (self.actions.count / numberOfButtonsInARow) : (self.actions.count / numberOfButtonsInARow) + 1;
        
        [self setPreferredContentSize:CGSizeMake(0, 10 + (numberOfRows * 35))];
        
        // Add buttons
        [self.actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

            // High math to calculate position of the buttons :)
            if (idx < numberOfButtonsInARow) {
                frame.origin.x = self.edgesPadding + (idx * self.buttonsPadding) + (idx * buttonWidth);
            } else {
                NSInteger row = (idx / numberOfButtonsInARow);
                NSInteger newIdx = idx - (numberOfButtonsInARow * row);
                frame.origin.y = 10 + (row * 35);
                frame.origin.x = self.edgesPadding + (newIdx * self.buttonsPadding) + (newIdx * buttonWidth);
            }

            UIButton *button = [[UIButton alloc] initWithFrame:frame];
            button.layer.cornerRadius = 5.0;
            [button setTitle:self.actions[idx][@"Title"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.textAlignment =   NSTextAlignmentCenter;
            button.tintColor = [UIColor whiteColor];
            button.tag = idx;
            [button.layer setMasksToBounds:YES];
            
            [button addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
            
        }];
        
        // Add Visual Effect View with the standard notification center vibrancy effect
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect notificationCenterVibrancyEffect]];
        effectView.frame = self.view.bounds;
        effectView.autoresizingMask = self.view.autoresizingMask;
        __strong UIView *oldView = self.view;
        self.view = effectView;
        [effectView.contentView addSubview:oldView];
        self.view.tintColor = [UIColor clearColor];
        
    } else {
        // Show instructions label to show
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.edgesPadding, 0, self.screenWidth - self.edgesPadding, 45)];
        label.text = @"Add your shortcuts in the Open It app.";
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.tintColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    
}

- (void)open:(UIButton *)button {
    // Open action
    [[self extensionContext] openURL:[NSURL URLWithString:self.actions[button.tag][@"Scheme"]] completionHandler:nil];
}

@end
