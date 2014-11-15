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
    
    NSString *type = array[1][@"Type"];
    NSString *URLScheme = array[2][@"URL"];
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (array.count > 3) {
        [array[3] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [parameters addEntriesFromDictionary:@{obj[@"type"] : obj[@"value"]}];
        }];
    }
    
    if (array.count == 3) {
        // It's a simple scheme without any parameters, just skip the building of the URL
        return URLScheme;
    } else if ([type isEqualToString:@"Mail"]) {
        NSString *scheme = [NSString stringWithFormat:@"%@%@?cc=%@&subject=%@&body=%@", URLScheme, parameters[@"To"], parameters[@"Cc"], parameters[@"Subject"], parameters[@"Body"]];
        [scheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return scheme;
    } else if ([type isEqualToString:@"Phone"]) {
        return [NSString stringWithFormat:@"%@%@", URLScheme, parameters[@"Number"]];
    } else if ([type isEqualToString:@"Messages"]) {
        return [NSString stringWithFormat:@"%@%@", URLScheme, parameters[@"Number"]];
    } else if ([type isEqualToString:@"FaceTime"]) {
        return [NSString stringWithFormat:@"%@%@", URLScheme, parameters[@"Email Address"]];
    } else if ([type isEqualToString:@"Twitter"]) {
        return URLScheme;
    } else if ([type isEqualToString:@"Maps"]) {
        return URLScheme;
    } else if ([type isEqualToString:@"Instagram"]) {
        return URLScheme;
    } else if ([type isEqualToString:@"Tweetbot"]) {
        return URLScheme;
    } else if ([type isEqualToString:@"Safari"]) {
        return [NSString stringWithFormat:@"%@%@", URLScheme, parameters[@"URL"]];
    } else if ([type isEqualToString:@"Custom"]) {
        NSLog(@"%@", URLScheme);
        return URLScheme;
    }
    return @"";
}

@end
