//
//  ChooseActionViewController.m
//  OpenIt
//
//  Created by Patrick Balestra on 24/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "ChooseActionViewController.h"

@interface ChooseActionViewController ()

@property (strong, nonatomic) NSArray *actions;

@end

@implementation ChooseActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.8412 green:0.3314 blue:0.3137 alpha:1.0000];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.actions = [NSArray new];
    self.actions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Actions" ofType:@"plist"]];
    
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.textLabel.text = self.actions[indexPath.row][0][@"Type"];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.actions[indexPath.row][0][@"Type"]]];
    
    CGSize itemSize = CGSizeMake(35, 35);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"YEAHHH %@", self.actions[indexPath.row]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddedShortcut" object:self.actions[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
