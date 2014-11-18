//
//  ActionDetailViewController.h
//  OpenIt
//
//  Created by Patrick Balestra on 24/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *shortcutArray;
@property (nonatomic) BOOL newAction;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)save:(id)sender;

@end
