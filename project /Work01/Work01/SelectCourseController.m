//
//  SelectCourseController.m
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "SelectCourseController.h"
#import "GetXML.h"
#import "FirstLevel.h"

#define XMLPATH @"http://ccmc.sinaapp.com/App/Common/Courses/15/course.xml"

@interface SelectCourseController ()

@property (nonatomic) NSMutableArray *firstLevelArray;

@end

@implementation SelectCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainTableView.sectionHeaderHeight = 50;
    
    GetXML *getXml = [GetXML getXMLWithDelegate:self];
    NSArray *array = @[@"firstLevel",@"secondLevel",@"word",@"ppt",@"video"];
    [getXml GetXML_Path:XMLPATH title:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//xml解析完成  代理 调用
-(void)XMLDidEndDocument:(NSArray *)array{
//    NSLog(@"%@",array);
    
    _firstLevelArray = [NSMutableArray array];
    
    for (int i = 0; i<array.count; i++) {
        NSArray *tempArray = ((NSDictionary *)array[i])[@"firstLevel"];
        [_firstLevelArray addObject:[FirstLevel firstLevelWithArray:tempArray]];
    }
    
}

//加载tableview 数据
//分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _firstLevelArray.count;
}
//组中cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
//生成cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text=@"dssfsfdsfds";
    
    return cell;
}
//加载头部空间
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    KWJSectionHeaderView *header = [KWJSectionHeaderView headerViewWithTableView:tableView];
    [header setFirst:_firstLevelArray[section]];
    return header;
}

@end
