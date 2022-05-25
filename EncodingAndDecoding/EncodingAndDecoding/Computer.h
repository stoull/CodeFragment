//
//  Computer.h
//  Test
//
//  Created by Khen C Silva on 2021/1/12.
//  Copyright © 2021 Khen C Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject <NSSecureCoding>
@property (nonatomic, copy)     NSString *name;
@property (nonatomic, assign)   int64_t ID;
@end

@interface Computer : NSObject <NSSecureCoding>
@property (nonatomic, copy)     NSString *model;
@property (nonatomic, assign)   NSInteger CPUS;
@property (nonatomic, strong)   User *user;
@property (nonatomic, strong)   NSDictionary *moreInfo;
@end

NS_ASSUME_NONNULL_END
