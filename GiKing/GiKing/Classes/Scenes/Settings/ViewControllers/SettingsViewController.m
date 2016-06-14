//
//  SettingsViewController.m
//  GiKing
//
//  Created by Han-byeol on 16/6/13.
//  Copyright © 2016年 Wj. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
//数据源
@property (nonatomic ,strong)NSArray *listArr;
//图片源
@property (nonatomic ,strong)NSArray *imageArr;
@end


@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listArr =@[@"我的关注",@"清除缓存",@"关于我们",@"帮助"];
    _imageArr=@[@"1",@"2",@"3",@"4"];
    
    UITableView *tabView =[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//      tabView.separatorStyle =UITableViewCellSeparatorStyleSingleLine; //分割线样式
//    tabView.separatorColor = [UIColor blackColor];
    //    清除多余的分割线  通过添加底视图来
    tabView.tableFooterView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];

    tabView.delegate =self;
    tabView.dataSource =self;
    
    [tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:tabView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _listArr.count;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell ==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text =@"账号管理";
        cell.imageView.image =[UIImage imageNamed:@"id-card"];
    }
    if (indexPath.section == 1){
        cell.textLabel.text =_listArr[indexPath.row];
        cell.imageView.image =[UIImage imageNamed:[NSString stringWithString:_imageArr[indexPath.row]]];
    }
    if (indexPath.section == 2){
        cell.textLabel.text =@"夜间模式";
        cell.imageView.image =[UIImage imageNamed:@"moon"];
    }
//  设置cell辅助样式为>
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row== 0) {
        NSLog(@"0--0");
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        NSLog(@"1--0");
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        NSLog(@"1--1");
    }else if (indexPath.section == 1 && indexPath.row == 2)
    {
        NSLog(@"1--2");
    }else if (indexPath.section == 1 && indexPath.row == 3)
    {
        NSLog(@"1--3");
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {
        NSLog(@"2--0");
    }
    
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
