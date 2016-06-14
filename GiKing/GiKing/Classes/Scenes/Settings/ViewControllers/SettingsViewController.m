//
//  SettingsViewController.m
//  GiKing
//
//  Created by Han-byeol on 16/6/13.
//  Copyright © 2016年 Wj. All rights reserved.
//

#import "SettingsViewController.h"
//建议页面
#import "OpinionViewController.h"

#import <DKNightVersion.h>

@interface SettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
//数据源
@property (nonatomic ,strong)NSArray *listArr;
//图片源
@property (nonatomic ,strong)NSArray *imageArr;
// 夜间模式开关
@property (nonatomic ,strong)UISwitch *switchs;

@property (nonatomic ,assign)BOOL on;
@end


@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 

    self.navigationController.navigationBar.dk_tintColorPicker = DKColorPickerWithRGB(0x343434, 0xdee2c8);
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithRGB(0x3f7971, 0x4d4545);
    
    _listArr =@[@"我的关注",@"清除缓存",@"关于我们",@"意见反馈"];
    _imageArr=@[@"1",@"2",@"3",@"4"];
    
    UITableView *tabView =[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    //    清除多余的分割线  通过添加底视图来
    tabView.tableFooterView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    tabView.separatorColor =[UIColor blackColor]; //分割线颜色
//    
//    tabView.separatorStyle =UITableViewCellSeparatorStyleSingleLineEtched; //分割线样式

    tabView.delegate =self;
    tabView.dataSource =self;
    
    [tabView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    
    [self.view addSubview:tabView];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
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
//        取消点击样式
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        self.switchs =[[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width -60, 5, 40, 23)];
        [self.switchs addTarget:self action:@selector(seitchsAction:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:_switchs];
    }
//  设置cell辅助样式为>
    if (indexPath.section != 2) {
         cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
      
    }
    
//    cell.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x4d4545);
//    cell.textLabel.dk_textColorPicker = DKColorPickerWithRGB(0x343434, 0xdee2c8);
   
   
    UIFont *newFont = [UIFont fontWithName:@"Arial" size:18.0];
    //创建完字体格式之后就告诉cell
    cell.textLabel.font = newFont;
    
    

    return cell;
}
// 头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 30;
}
// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }
    return 50;
}


//cell 点击事件
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
        OpinionViewController *opinionVC =[OpinionViewController new];
        [opinionVC setHidesBottomBarWhenPushed:YES];
        [self showViewController:opinionVC sender:nil];
        
        
    }
//    else if (indexPath.section == 2 && indexPath.row == 0)
//    {
//        NSLog(@"2--0");
//    }
    
}


// 按钮的点击事件  --- 夜间模式
- (void)seitchsAction:(UISwitch *)sender
{
    
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"night" forKey:@"nightState"];
        [DKNightVersionManager sharedManager].themeVersion = DKThemeVersionNight;
        
        [sender addObserver:self forKeyPath:@"on" options:(NSKeyValueObservingOptionNew) context:nil];
        
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:@"day" forKey:@"nightState"];
        [DKNightVersionManager sharedManager].themeVersion = DKThemeVersionNormal;
        
        
    }
    
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"on" context:nil];
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
