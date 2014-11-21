//
//  SelectProjectController.m
//  Work01
//
//  Created by kwj on 14/11/17.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "SelectProjectController.h"
#import "Project.h"//数据模型
#import "Course.h" //数据模型
#import "KWJHeaderView.h"
#import "SelectCourseController.h"

//得到学习领域
#define TYPE @"http://ccmc.sinaapp.com/Course/getCourseType"
//得到各领域课程
#define COURSE @"http://ccmc.sinaapp.com/Course/getCourseList"

@interface SelectProjectController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong) NSArray *project;//提供学习的领域 数据
@property (nonatomic,strong) Loading *loads;//用于数据请求

@end

@implementation SelectProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // tableview 样式设置
    self.mainTableView.rowHeight=60;
    self.mainTableView.sectionHeaderHeight=44;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除cell的分隔线
    //联接数据库 查询数据
    _loads = [Loading LoadDBWithDelegate:self];

    NSString *url =TYPE;
    [_loads LoadDB_GET_WithURL:url WithName:@"getArray" WithSender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//delegate方法 访问数据库 成功 得到数据后调用
-(void)resultWith:(NSArray *)array WithName:(NSString *)name Sender:(id)sender{
    //找到与之匹配的返回结果，执行相应操作
    if ([name  isEqual: @"getArray"]) {
//        NSLog(@"getArray");
        
        _project=[self project:array];
        
        //得到数据后重新加载tableview
        [self.mainTableView reloadData];
    }else if ([name isEqualToString:@"getCourse"]){
//        NSLog(@"getCourse");
        
        Project *pro = _project[[sender integerValue]];
        for (int i = 0; i < array.count; i++) {
            [pro setCourseByDictionary:(NSDictionary *)array[i]];
        }
        
        //得到数据后重新加载tableview
        [self.mainTableView reloadData];
    }else if ([name isEqualToString:@"nextCourse"]){
//        NSLog(@"nextCourse");
        
        Project *pro = _project[[sender integerValue]];
        for (int i = 0; i < array.count; i++) {
            [pro setCourseByDictionary:(NSDictionary *)array[i]];
        }
        
        //得到数据后重新加载tableview
        [self.mainTableView reloadData];
    }
    
}

//初始化 project 数据模型
-(NSArray *)project:(NSArray *)array{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        Project *pro = [Project projectWithDict:dic];
        [tempArray addObject:pro];
    }
    return tempArray;
}

/*
 *  当头部被点击的时候 delegate 回调
 */
- (void)headerViewDidClickedNameView:(KWJHeaderView *)headerView{
    //刷新数据
    [self.mainTableView reloadData];
}

/*
 *  table view 传递数据
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _project.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Project *pro = _project[section];
    //如果是展开 就 获取数据
    if (pro.isOpened && pro.course.count == 0) {
        
        NSString *url =[NSString stringWithFormat:@"%@?courseType=%d&page=%d",COURSE,pro.typeId,1];
        pro.page = 1;
        [_loads LoadDB_GET_WithURL:url WithName:@"getCourse" WithSender:[NSNumber numberWithInteger:section]];
    }
    
    return (pro.isOpened ? pro.course.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CourseCell *cell = [CourseCell cellWithTableView:tableView];
    cell.delegates = self;
    Project *pro = _project[indexPath.section];
    [cell setCourse:(Course *)pro.course[indexPath.row]];
    
//    NSLog(@"%ld,%ld",(long)indexPath.row,pro.maxRow);
    
    if (pro.course.count-3 <= indexPath.row && pro.page*10 < pro.count) {
        
        //每次 内容 读取 7条时  && 当前cell条数 小于 该项目cell总数时
        pro.page++;
        NSString *url =[NSString stringWithFormat:@"%@?courseType=%d&page=%d",COURSE,pro.typeId,pro.page];
        [_loads LoadDB_GET_WithURL:url WithName:@"nextCourse" WithSender:[NSNumber numberWithInteger:indexPath.section]];
    }
    
    return cell;
}

//加载头部空间
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //创建头部控件
    KWJHeaderView *header =[KWJHeaderView headerViewWithTableView:tableView];
    //头部控件赋值
    header.delegates=self;
    header.project=_project[section];
    
    return header;
}

//课程 收藏按钮 点击触发代理时事件
- (void)collectButtonClick{
    NSLog(@"sdfsdfsd");
}

//cell  选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Project *pro = _project[indexPath.section];
    NSString *path = ((Course *)pro.course[indexPath.row]).xmlPath;
//    NSLog(@"xmlPath:%@",path);
    [self performSegueWithIdentifier:@"course" sender:path];
}

//页面跳转事件
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"course"]) {
        [[segue destinationViewController] setXmlPath:sender];
    }
}

/*
 *设置每一个头部控件的高度
 */
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

@end
