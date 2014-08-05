//
//  YourActionsViewController.m
//  OpenIt
//
//  Created by Patrick Balestra on 22/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "YourActionsViewController.h"
#import "ActionDetailViewController.h"
#import "SchemeBuilder.h"

@interface YourActionsViewController ()

@property (strong, nonatomic) NSMutableArray *actions;

@end

@implementation YourActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.3412 green:0.8314 blue:0.9137 alpha:1.0000];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:20], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.actions = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"actions"]];
    NSLog(@"Loaded actions in app: %@", self.actions);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewAction:) name:@"AddNewAction" object:nil];
    
}

- (void)saveActions {
    // Save locally
    [[NSUserDefaults standardUserDefaults] setObject:[self.actions mutableCopy] forKey:@"actions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Save to extension

    SchemeBuilder *builder = [SchemeBuilder new];
    NSMutableArray *extensionActions = [NSMutableArray new];
    
    [self.actions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *scheme = [builder buildSchemeWithArray:obj];
        [extensionActions addObject:@{@"Title" : obj[0][@"Title"], @"Scheme" : scheme}];
    }];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.actions"];
    [sharedDefaults setObject:[extensionActions mutableCopy] forKey:@"actions"];
    [sharedDefaults synchronize];
}

- (void)addNewAction:(NSNotification *)notification {    
    [self.actions addObject:notification.object];
    [self.tableView reloadData];
    [self saveActions];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.actions[indexPath.row][0][@"Title"];
    cell.detailTextLabel.text = self.actions[indexPath.row][1][@"Type"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.actions removeObjectAtIndex:indexPath.row];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self saveActions];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailAction"]) {
        ActionDetailViewController *actionDetail = (ActionDetailViewController *)segue.destinationViewController;
        actionDetail.shortcutArray = self.actions[[self.tableView indexPathForSelectedRow].row];
        actionDetail.pushedDetail = YES;
    }
}

@end
