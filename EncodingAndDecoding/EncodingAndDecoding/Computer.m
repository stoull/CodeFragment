//
//  Computer.m
//  Test
//
//  Created by Khen C Silva on 2021/1/12.
//  Copyright © 2021 Khen C Silva. All rights reserved.
//

#import "Computer.h"

@implementation User

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeInt64:_ID forKey:@"ID"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [super init]) {
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _ID = [coder decodeInt64ForKey:@"ID"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

@implementation Computer

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_model forKey:@"model"];
    [coder encodeInteger:_CPUS forKey:@"CPUS"];
    [coder encodeObject:_user forKey:@"user"];
    [coder encodeObject:_moreInfo forKey:@"moreInfo"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [super init]) {
        _model = [coder decodeObjectOfClass:[NSString class] forKey:@"model"];
        _CPUS = [coder decodeIntegerForKey:@"CPUS"];
        _user = [coder decodeObjectOfClass:[User class] forKey:@"user"];
        _moreInfo = [coder decodeObjectOfClass:[NSDictionary class] forKey:@"moreInfo"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
@end


