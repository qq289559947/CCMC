//
//  SelectCourseController.h
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetXML.h"

@interface SelectCourseController : UIViewController<getXmlDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *xmlPath;//课程xml的地址

@end
