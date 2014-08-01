//
//  ActionDetailViewController.h
//  OpenIt
//
//  Created by Patrick Balestra on 24/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionDetailViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSDictionary *detailDictionary;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) UITextField *titleTextField;
@property (weak, nonatomic) UITextField *schemeTextField;

- (IBAction)save:(id)sender;

@end
