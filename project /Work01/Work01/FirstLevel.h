//
//  FirstLevel.h
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstLevel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic)NSMutableArray *secondLevel;

+(instancetype)firstLevelWithArray:(NSArray *)array;

@end
