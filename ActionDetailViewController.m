//
//  ActionDetailViewController.m
//  OpenIt
//
//  Created by Patrick Balestra on 24/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "ActionDetailViewController.h"

@interface ActionDetailViewController ()

@property (strong, nonatomic) NSMutableArray *actionArray;

@end

@implementation ActionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.shortcutArray.count != 0) {
        self.title = self.shortcutArray[0][@"Title"];
    }
    
    if (!self.shortcutArray) {
        self.shortcutArray = [NSMutableArray new];
    }
    
    self.actionArray = [NSMutableArray new];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addedShortcut:) name:@"AddedShortcut" object:nil];
}

- (IBAction)save:(id)sender {
    NSLog(@"SAVED %@", self.actionArray);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewAction" object:self.actionArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addedShortcut:(NSNotification *)notification {
    self.shortcutArray = [notification.object mutableCopy];
    //[self.shortcutArray insertObject:@{@"Title" : @""} atIndex:0];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.pushedDetail) {
        NSLog(@"Presenting a detail action");
    }
}

# pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if (self.shortcutArray.count == 0) {
            return 1;
        } else {
            return self.pushedDetail ? self.shortcutArray.count - 1: self.shortcutArray.count;
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

            if (self.shortcutArray.count != 0) {
                textField.text = self.shortcutArray[0][@"Title"];
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.shortcutArray.count == 0) {
                cell.textLabel.text = @"+";
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
        
        NSLog(@"self.shortcutarray %@", self.shortcutArray);
        [self.shortcutArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (self.pushedDetail) {
                NSLog(@"presenting pushed details");
                idx++;
                if (indexPath.row + 1 == idx) {
                    cell.textLabel.text = [[self.shortcutArray[idx] allKeys] firstObject];
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, 200, 35)];
                    textField.textAlignment = NSTextAlignmentRight;
                    textField.tag = idx;
                    textField.delegate = self;
                    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    
                    textField.placeholder = [[self.shortcutArray[idx] allValues] firstObject];
                    cell.accessoryView = textField;
                    
                    if (idx == 2 || idx == 3) {
                        textField.text = [[self.shortcutArray[idx] allValues] firstObject];
                    }
                    if (idx == 1) {
                        UIImageView *imageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.shortcutArray[1][@"Type"]]];
                        imageIcon.frame = CGRectMake(0, 0, 35, 35);
                        cell.accessoryView = imageIcon;
                    }
                    
                    [self textFieldDidEndEditing:textField];
                }
            }
            if (indexPath.row == idx) {
                cell.textLabel.text = [[self.shortcutArray[idx] allKeys] firstObject];
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, 200, 35)];
                textField.textAlignment = NSTextAlignmentRight;
                textField.tag = idx;
                textField.delegate = self;
                textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                
                textField.placeholder = [[self.shortcutArray[idx] allValues] firstObject];
                cell.accessoryView = textField;
                
                if (idx == 0 || idx == 1) {
                    textField.text = [[self.shortcutArray[idx] allValues] firstObject];
                }
                if (idx == 0) {
                    UIImageView *imageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.shortcutArray[0][@"Type"]]];
                    imageIcon.frame = CGRectMake(0, 0, 35, 35);
                    cell.accessoryView = imageIcon;
                }
                
                [self textFieldDidEndEditing:textField];
            }
        }];
        
        
        /*if (self.shortcutArray.count != 0) {
            NSDictionary *rowDictionary = self.shortcutArray[indexPath.row + 1];
            NSString *key = [[rowDictionary allKeys] firstObject];
            cell.textLabel.text = key;
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, 200, 35)];
            textField.textAlignment = NSTextAlignmentRight;
            textField.tag = indexPath.row;
            textField.delegate = self;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.accessoryView = textField;
            textField.text = self.shortcutArray[indexPath.row + 1][key];
            
            if (indexPath.row == 0) {
                UIImageView *imageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.shortcutArray[1][@"Type"]]];
                imageIcon.frame = CGRectMake(0, 0, 35, 35);
                cell.accessoryView = imageIcon;
            }
        }*/
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        if (self.shortcutArray.count == 0) {
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
    NSLog(@"Textfield text %d", textField.tag);
    if (textField.tag == -1) {
        [self.actionArray addObject:@{@"Title" : textField.text}];
    } else {
        [self.actionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *dictionary = [(NSDictionary *)obj mutableCopy];
            if ([[dictionary allKeys] containsObject:[[self.shortcutArray[textField.tag] allKeys] firstObject]]) {
                [dictionary setObject:textField.text forKey:[[self.shortcutArray[textField.tag] allKeys] firstObject]];
                [self.actionArray setObject:dictionary atIndexedSubscript:idx];
                return;
            }
        }];
        [self.actionArray addObject:@{[[self.shortcutArray[textField.tag] allKeys] firstObject] : textField.text}];
    }
    NSLog(@"ACtion array %@", self.actionArray);
}

@end
