//
//  ActionDetailViewController.m
//  OpenIt
//
//  Created by Patrick Balestra on 24/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "ActionDetailViewController.h"
#import "ChooseActionViewController.h"

@interface ActionDetailViewController ()

@end

@implementation ActionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.shortcutArray[0][@"Title"];
    
    if (![self.shortcutArray[0][@"Title"] isEqualToString:@""]) {
        self.title = self.shortcutArray[0][@"Title"];
    } else {
        self.title = self.shortcutArray[1][@"Type"];
    }
    
    if (!self.shortcutArray) {
        self.shortcutArray = [NSMutableArray array];
    }
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    self.detailIndex = NSNotFound;
}

- (IBAction)save:(id)sender {
    [self.view endEditing:YES];

    if (self.shortcutArray.count > 0) {
        if (![self.shortcutArray[0][@"Title"] isEqualToString:@""]) {
            if (!self.detailIndex) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewAction" object:self.shortcutArray];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"EditAction" object:self.shortcutArray];
            }
            
            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [allViewControllers removeObjectAtIndex:1];
            self.navigationController.viewControllers = allViewControllers;
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please Add a Title" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.shortcutArray.count > 0) {
        if (self.shortcutArray.count > 3) {
            return 3;
        } else {
            return 2;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if (self.shortcutArray.count == 0) {
            return 1;
        } else {
            if (self.shortcutArray.count > 3) {
                return self.shortcutArray.count - 2;
            } else {
                return self.shortcutArray.count - 1;
            }
        }
    } else if (section == 2) {
        return ((NSMutableArray *)self.shortcutArray[3]).count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.shortcutArray.count == 0) {
            return @"Shortcut";
        } else {
            return @"Title";
        }
    } else if (section == 1) {
        return @"Shortcut";
    } else if (section == 2) {
        return @"Parameters";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.shortcutArray.count == 0) {
                cell.textLabel.text = @"+";
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:30];
                cell.textLabel.textColor = [UIColor darkGrayColor];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.tag = -10;
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            } else {
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, cell.frame.size.width-40, 35)];
            
                textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                textField.placeholder = @"Your Title";
                textField.delegate = self;
                textField.tag = -1;
                [cell.contentView addSubview:textField];
                
                cell.textLabel.text = @"";
                
                if (self.shortcutArray.count != 0) {
                    textField.text = self.shortcutArray[0][@"Title"];
                }
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = /*[[self.shortcutArray[1] allKeys] firstObject]*/@"App";
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            
            UIImageView *imageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.shortcutArray[1][@"Type"]]];
            imageIcon.frame = CGRectMake(0, 0, 35, 35);
            cell.accessoryView = imageIcon;
            
            if ([self.shortcutArray[1][@"Type"] isEqualToString:@"Custom"]) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-190, 40)];
                label.text = @"Custom";
                label.textAlignment = NSTextAlignmentRight;
                cell.accessoryView = label;
            }
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = [[self.shortcutArray[2] allKeys] firstObject];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 150, 35)];
            label.text = [self.shortcutArray[2] valueForKey:cell.textLabel.text];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            cell.accessoryView = label;
            
            if ([self.shortcutArray[1][@"Type"] isEqualToString:@"Custom"]) {
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width-190, 40)];
                textField.placeholder = @"Custom URL";
                textField.tag = -2;
                textField.delegate = self;
                textField.textAlignment = NSTextAlignmentRight;
                textField.text = self.shortcutArray[2][@"URL"];
                cell.accessoryView = textField;
            }
        }
    } else if (indexPath.section == 2) {
        NSArray *parameters = self.shortcutArray[3];
        
        if (parameters.count == 1 && [parameters[0][@"type"] isEqualToString:@"Multiple"] && ![parameters[0][@"Value"] isEqualToString:@""]) {
            // Set right cell title
            cell.textLabel.text = parameters[0][@"placeholder"];
            // Add Button to accessory view to then pop up Action Sheet
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
            button.layer.borderColor = [UIColor colorWithRed:0.8745 green:0.0784 blue:0.0745 alpha:1.0000].CGColor;
            button.layer.borderWidth = 1.0;
            button.layer.cornerRadius = 7.0;
            [button setTitleColor:[UIColor colorWithRed:0.8745 green:0.0784 blue:0.0745 alpha:1.0000] forState:UIControlStateNormal];
            [button setTitle:parameters[0][@"placeholder"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(presentActionSheet:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = button;
            return cell;
        }
        
        [parameters enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            obj = parameters[indexPath.row];
            cell.textLabel.text = obj[@"placeholder"];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 5, cell.frame.size.width-190, 35)];
            textField.textAlignment = NSTextAlignmentRight;
            textField.tag = idx;
            textField.delegate = self;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.placeholder = obj[@"placeholder"];
            textField.text = obj[@"value"];
            
            if ([obj[@"type"] isEqualToString:@"Number"]) {
                [textField setKeyboardType:UIKeyboardTypeNumberPad];
            } else if ([obj[@"type"] isEqualToString:@"String"]) {
                
            } else {
                textField.keyboardType = UIKeyboardTypeDefault;
            }
            
            cell.accessoryView = textField;
        }];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.shortcutArray.count == 0) {
        [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewAction"] animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)presentActionSheet:(UIButton *)button {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // TODO: load dynamically items
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"App" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    UIPopoverPresentationController *popOver = [actionSheet popoverPresentationController];
    popOver.sourceView = button;
    popOver.sourceRect = button.bounds;
    [self presentViewController:actionSheet animated:YES completion:nil];
}

# pragma UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == -1) {
        // Save title at first index
        NSMutableDictionary *mutableDictionary = [self.shortcutArray[0] mutableCopy];
        [mutableDictionary setObject:textField.text forKey:@"Title"];
        self.shortcutArray[0] = [mutableDictionary mutableCopy];
    } else if (textField.tag == -2) {
        // Custom action
        NSMutableDictionary *mutableDictionary = [self.shortcutArray[2] mutableCopy];
        [mutableDictionary setObject:textField.text forKey:@"URL"];
        self.shortcutArray[2] = [mutableDictionary mutableCopy];
    } else {
        // Save parameters
        NSMutableArray *arrayOfParameters = [self.shortcutArray[3] mutableCopy];
        NSMutableDictionary *dictionaryOfParameter = [arrayOfParameters[textField.tag] mutableCopy];
        NSUInteger index = [arrayOfParameters indexOfObject:dictionaryOfParameter];
        [dictionaryOfParameter setValue:textField.text forKey:@"value"];
        [arrayOfParameters setObject:dictionaryOfParameter atIndexedSubscript:index];
        self.shortcutArray[3] = [arrayOfParameters mutableCopy];
    }
}

@end