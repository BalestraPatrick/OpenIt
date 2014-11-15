//
//  ChooseActionViewController.m
//  OpenIt
//
//  Created by Patrick Balestra on 24/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "ChooseActionViewController.h"
#import "ActionDetailViewController.h"

@interface ChooseActionViewController ()

@property (strong, nonatomic) NSArray *actions;
@property (strong, nonatomic) NSArray *otherActions;

@end

@implementation ChooseActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.8745 green:0.0784 blue:0.0745 alpha:1.0000];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.actions = [NSArray new];
    self.actions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SystemActions" ofType:@"plist"]];
    
    NSArray *sortedActions = [self.actions sortedArrayUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
        return [obj1[1][@"Type"] compare:obj2[1][@"Type"] options:NSCaseInsensitiveSearch];
    }];
    self.actions = sortedActions;
    
    self.otherActions = [NSArray new];
    self.otherActions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OtherActions" ofType:@"plist"]];
    
    NSArray *sortedActions2 = [self.otherActions sortedArrayUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray *obj2) {
        return [obj1[1][@"Type"] compare:obj2[1][@"Type"] options:NSCaseInsensitiveSearch];
    }];
    self.otherActions = sortedActions2;
    
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.actions.count;
    } else {
        return self.otherActions.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Custom Action";
    } else if (section == 1) {
        return @"Default Apps";
    } else if (section == 2) {
        return @"Other Apps";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Custom Action";
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Custom"]];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.actions[indexPath.row][1][@"Type"];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.actions[indexPath.row][1][@"Type"]]];
    } else if (indexPath.section == 2) {
        cell.textLabel.text = self.otherActions[indexPath.row][1][@"Type"];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.otherActions[indexPath.row][1][@"Type"]]];
    }
    
    CGSize itemSize = CGSizeMake(35, 35);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CustomizeAction"]) {
        ActionDetailViewController *actionDetail = (ActionDetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath.section == 0) {
            NSArray *custom = @[
                                @{@"Title" : @""},
                                @{@"Type": @"Custom"},
                                @{@"URL" : @""}
                                ];
            actionDetail.shortcutArray = [custom mutableCopy];
        } else if (indexPath.section == 1) {
            actionDetail.shortcutArray = [self.actions[indexPath.row] mutableCopy];
        } else if (indexPath.section == 2) {
            actionDetail.shortcutArray = [self.otherActions[indexPath.row] mutableCopy];
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
