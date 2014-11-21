//
//  KWJSectionHeaderView.m
//  Work01
//
//  Created by kwj on 14/11/21.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "KWJSectionHeaderView.h"

@interface KWJSectionHeaderView()
@property (nonatomic,weak) UIButton *mianView;
@property (nonatomic,weak) UILabel *titleView;
@property (nonatomic,weak) UILabel *subtitleView;
@end

@implementation KWJSectionHeaderView

+(instancetype)headerViewWithTableView:(UITableView *)tableView{
    //创建头部控件
    static NSString *ID = @"sectionHead";
    KWJSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    if (header == nil) {
        header = [[KWJSectionHeaderView alloc]initWithReuseIdentifier:ID];
    }
    
    return header;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        //添加按钮
        UIButton *mainView = [UIButton buttonWithType:UIButtonTypeCustom];
        mainView.backgroundColor = [UIColor redColor];
        [mainView addTarget:self action:@selector(mainViewClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:mainView];
        _mianView = mainView;
        
        //添加title lablel
        UILabel *titleView = [[UILabel alloc]init];
        titleView.backgroundColor = [UIColor  yellowColor];
        
        
        [self.contentView addSubview:titleView];
        _titleView = titleView;
        
        //添加subtitle label
        UILabel *subtitleView = [[UILabel alloc]init];
        subtitleView.backgroundColor = [UIColor  blueColor];
        
        [self.contentView addSubview:subtitleView];
        _subtitleView = subtitleView;
    }
    return  self;
}

//内部布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _mianView.frame = self.bounds;
    
    _titleView.frame = CGRectMake(100, 0, 275, 30);
    
    _subtitleView.frame = CGRectMake(100, 30, 275, 20);
}

-(void)setFirst:(FirstLevel *)first{
    
//    _first = first;
    _titleView.text = first.title;
}

-(void)mainViewClick{
    NSLog(@"dfsfsd");
}

@end
