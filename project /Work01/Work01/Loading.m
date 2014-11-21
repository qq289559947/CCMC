//
//  Loading.m
//  Work01
//
//  Created by kwj on 14/11/18.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import "Loading.h"

@interface Loading()

@property (nonatomic,copy) NSString *loadName;
@property (nonatomic)NSMutableData *data;
@property (nonatomic)NSArray *array;

@property (nonatomic)id sender;

@end

@implementation Loading

+(instancetype)LoadDBWithDelegate:(id)delegate{
    Loading *loads = [[Loading alloc]init];
    loads.delegates=delegate;
    return loads;
}

-(id)init{
    self = [super init];
    return self;
}

/*
 *  使用GET方法访问数据库，得到数据
 */
-(void)LoadDB_GET_WithURL:(NSString *)urlStr WithName:(NSString *)name WithSender:(id)sender{
//    NSLog(@"LoadDB_GET");
    //为本次联接取名字
    _loadName = [NSString stringWithString:name];
    _sender = sender;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

/*
 *  使用POST方法访问数据库，得到数据
 */
-(void)LoadDB_POST_WithURL:(NSString *)urlStr WithPost:(NSDictionary *)dic WithName:(NSString *)name WithSender:(id)sender{
//    NSLog(@"LoadDB_PUST");
    //为本次联接取名字
    _loadName = [NSString stringWithString:name];
    _sender = sender;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *postStr=@"";
    NSArray *key = [dic allKeys];
    NSArray *value = [dic allValues];
    for (int i=0; i<dic.count; i++) {
        NSString *str;
        if (i==0) {
            str=[NSString stringWithFormat:@"%@=%@",key[i],value[i]];
        }else{
            str=[NSString stringWithFormat:@"&%@=%@",key[i],value[i]];
        }
        postStr=[postStr stringByAppendingString:str];
    }
    
    NSData *data=[postStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

//接收 数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (_data == nil) {
        _data = [NSMutableData data];
    }
    [_data appendData:data];
}

//数据接收完成  
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    _array=(NSArray *)[NSJSONSerialization JSONObjectWithData:_data options:NSUTF8StringEncoding error:nil];
    _data=nil;
    
    //通过代理 实现数据接收完成后的操作
    if ([self.delegates respondsToSelector:@selector(resultWith:WithName:Sender:)]) {
        [self.delegates resultWith:_array WithName:_loadName Sender:_sender];
    }
}

@end
