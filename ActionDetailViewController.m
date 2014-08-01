//
//  ActionDetailViewController.m
//  OpenIt
//
//  Created by Patrick Balestra on 24/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "ActionDetailViewController.h"

@interface ActionDetailViewController ()

@property (nonatomic) BOOL isNewAction;

@property (strong, nonatomic) NSArray *shortcutDictionary;
@property (nonatomic) BOOL hasShortcut;

@property (strong, nonatomic) NSMutableDictionary *actionDictionary;

@end

@implementation ActionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.detailDictionary) {
        self.isNewAction = NO;
        self.hasShortcut = YES;
        self.title = self.detailDictionary[@"title"];
        self.titleTextField.text = self.detailDictionary[@"title"];
        self.schemeTextField.text = self.detailDictionary[@"scheme"];
        NSLog(@"Detail dictionary: %@", self.detailDictionary);
    } else {
        self.isNewAction = YES;
        self.hasShortcut = NO;
        self.title = @"New Action";
    }
    
    self.actionDictionary = [NSMutableDictionary new];
    
    self.shortcutDictionary = [NSArray new];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addedShortcut:) name:@"AddedShortcut" object:nil];
}

- (IBAction)save:(id)sender {
    // Save action dictionary with all the data for this action
    for (UIView *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [self textFieldDidEndEditing:(UITextField *)textField];
        }
    }
    if (self.isNewAction) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewAction" object:self.actionDictionary];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAction" object:self.actionDictionary];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addedShortcut:(NSNotification *)notification {
    self.hasShortcut = YES;
    self.shortcutDictionary = notification.object;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

# pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if (!self.hasShortcut) {
            return 1;
        } else {
            if (self.detailDictionary) {
                return self.detailDictionary.count;
            } else {
                return self.shortcutDictionary.count;
            }
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Title";
    } else if (section == 1) {
        return @"Shortcut";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(16, 5, 250, 35)];
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            textField.placeholder = @"Your Title";
            textField.delegate = self;
            textField.tag = -1;
            [cell.contentView addSubview:textField];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (self.detailDictionary) {
                textField.text = self.detailDictionary[@"Title"];
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (!self.hasShortcut) {
                cell.textLabel.text = @"+";
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
        
        [self.shortcutDictionary enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (indexPath.row == idx) {
                cell.textLabel.text = [[self.shortcutDictionary[indexPath.row] allKeys] firstObject];
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, 200, 35)];
                textField.textAlignment = NSTextAlignmentRight;
                textField.tag = indexPath.row;
                textField.delegate = self;
                textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                
                textField.placeholder = [[self.shortcutDictionary[indexPath.row] allValues] firstObject];
                cell.accessoryView = textField;
                
                if (indexPath.row == 0 || indexPath.row == 1) {
                    textField.text = [[self.shortcutDictionary[indexPath.row] allValues] firstObject];
                }
                if (indexPath.row == 0) {
                    UIImageView *imageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[self.shortcutDictionary[indexPath.row] allValues] firstObject]]];
                    cell.accessoryView = imageIcon;
                }
                
                [self textFieldDidEndEditing:textField];
            }
        }];
        
        if (self.detailDictionary) {
            NSString *key = [self.detailDictionary allKeys][indexPath.row];
            cell.textLabel.text = key;
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, 200, 35)];
            textField.textAlignment = NSTextAlignmentRight;
            textField.tag = indexPath.row;
            textField.delegate = self;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.accessoryView = textField;
            textField.text = self.detailDictionary[key];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        if (!self.hasShortcut) {
            [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewAction"] animated:YES completion:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == -1) {
        [self.actionDictionary addEntriesFromDictionary:@{@"Title" : textField.text}];
    } else {
        [self.actionDictionary addEntriesFromDictionary:@{[[self.shortcutDictionary[textField.tag] allKeys] firstObject] : textField.text}];
    }
    NSLog(@"ActionDictionary = %@", self.actionDictionary);
}

@end
