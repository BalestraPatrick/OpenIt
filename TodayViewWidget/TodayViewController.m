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

#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) NSArray *actions;

@property (nonatomic) CGRect firstFrame;

@end

@implementation TodayViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Start Value if there are no buttons
    [self setPreferredContentSize:CGSizeMake(0, 45)];
    
    if (iPad) {
        self.firstFrame = CGRectMake(-45, 10, 90, 25);
    } else {
        self.firstFrame = CGRectMake(-85, 10, 90, 25);
    }
    
    self.actions = [NSArray new];
    
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
    
    NSLog(@"Actions in NC: %@", self.actions);
    
    if (self.actions.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-30, 45)];
        label.text = @"Add your shortcuts here from the Open It app.";
        label.numberOfLines = 0;
        label.textColor = [UIColor blackColor];
        label.tintColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
    
    __block CGRect frame = self.firstFrame;

    [self.actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSLog(@"Current frame %@", NSStringFromCGRect(frame));
        if (!iPad && (idx == 3 || idx == 6 || idx == 9 || idx == 12)) {
            frame.origin.x = -85;
            frame.origin.y += 35;
            CGSize currentSize = [self preferredContentSize];
            currentSize.height += 35;
            [self setPreferredContentSize:currentSize];
        } else if (iPad && (idx == 5 || idx == 10)) {
            frame.origin.x = -45;
            frame.origin.y += 35;
            CGSize currentSize = [self preferredContentSize];
            currentSize.height += 35;
            [self setPreferredContentSize:currentSize];
        }
        frame.origin.x += 100;

        NSLog(@"Title: %@", self.actions[idx][@"Title"]);
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        button.layer.cornerRadius = 3.0;
        [button setTitle:self.actions[idx][@"Title"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.textAlignment =   NSTextAlignmentCenter;
        button.tintColor = [UIColor blackColor];
        button.tag = idx;
        [button.layer setMasksToBounds:YES];
        
        [button addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect notificationCenterVibrancyEffect]];
    effectView.frame = self.view.bounds;
    effectView.autoresizingMask = self.view.autoresizingMask;
    
    __strong UIView *oldView = self.view;
    
    self.view = effectView;
    
    [effectView.contentView addSubview:oldView];
    
    self.view.tintColor = [UIColor clearColor];
    
}

- (void)open:(UIButton *)button {
    NSLog(@"Opening shortcut (%@)", self.actions[button.tag][@"Scheme"]);
    [[self extensionContext] openURL:[NSURL URLWithString:self.actions[button.tag][@"Scheme"]] completionHandler:nil];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encoutered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
