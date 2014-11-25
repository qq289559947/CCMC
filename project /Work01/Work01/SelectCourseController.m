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

#import "KWJCourseAlertView.h"

#define XMLPATH @"http://ccmc.sinaapp.com/App/Common/Courses/15/course.xml"

@interface SelectCourseController ()

@property (nonatomic) NSMutableArray *firstLevelArray;

@end

@implementation SelectCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainTableView.sectionHeaderHeight = 50;
    _mainTableView.rowHeight = 44;
    
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除cell的分隔线
    
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
    FirstLevel * f = _firstLevelArray[section];
//    return f.secondLevel.count;
    return f.isOpened?f.secondLevel.count:0;
}
//生成cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstLevel * f = _firstLevelArray[indexPath.section];
    
    SectionCell *cell = [SectionCell cellWithTableView:tableView];
    [cell setSecondLevel:f.secondLevel[indexPath.row] buttonDeleget:self];
    
    return cell;
}
//加载头部空间
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    KWJSectionHeaderView *header = [KWJSectionHeaderView headerViewWithTableView:tableView];
    header.delegates = self;
    [header setFirst:_firstLevelArray[section]];
    return header;
}

//头部控件 点击 代理事件
- (void)headerViewDidClickedMainView:(KWJSectionHeaderView *)headerView{
    [_mainTableView reloadData];
}

//cell 按钮点击 代理事件
-(void)labelButtonClick:(KWJLableButton *)button{
    KWJCourseAlertView *alert = [KWJCourseAlertView tableAlertWithTitle:button.title cancelButtonTitle:@"取消" courseware:button.coursewareArray delegate:self];
    
    [alert show];
}

// alert 代理事件
-(void)cellSeleted:(KWJCourseAlertView *)alert cousewarw:(Courseware *)courseware{
    NSLog(@"path %@",courseware.path);
}
@end
