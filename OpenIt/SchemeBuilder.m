//
//  SchemeBuilder.m
//  OpenIt
//
//  Created by Patrick Balestra on 26/07/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

#import "SchemeBuilder.h"

@implementation SchemeBuilder

- (NSString *)buildSchemeWithArray:(NSArray *)array {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [dictionary addEntriesFromDictionary:obj];
    }];
    
    NSString *actionType = dictionary[@"Type"];
    
    if ([actionType isEqualToString:@"Mail"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@%@?cc=%@&subject=%@&body=%@", dictionary[@"URL"], dictionary[@"To"], dictionary[@"Cc"], dictionary[@"Subject"], dictionary[@"Body"]];
        [scheme stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        return scheme;
    } else if ([actionType isEqualToString:@"Phone"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@%@", dictionary[@"URL"], dictionary[@"Number"]];
        NSLog(@"%@", scheme);
        return scheme;
    } else if ([actionType isEqualToString:@"Messages"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@%@", dictionary[@"URL"], dictionary[@"Number"]];
        return scheme;
    } else if ([actionType isEqualToString:@"FaceTime"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@%@", dictionary[@"URL"], dictionary[@"Email Address"]];
        return scheme;
    } else if ([actionType isEqualToString:@"YouTube"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@%@", dictionary[@"URL"], dictionary[@"Video Identifier"]];
        return scheme;
    } else if ([actionType isEqualToString:@"Music"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@", dictionary[@"URL"]];
        return scheme;
    } else if ([actionType isEqualToString:@"Photos"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@", dictionary[@"URL"]];
        return scheme;
    } else if ([actionType isEqualToString:@"iBooks"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@", dictionary[@"URL"]];
        return scheme;
    } else if ([actionType isEqualToString:@"Facebook"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@", dictionary[@"URL"]];
        return scheme;
    } else if ([actionType isEqualToString:@"Twitter"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@", dictionary[@"URL"]];
        return scheme;
    }
    
    return @"";
}

@end
