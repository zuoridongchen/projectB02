//
//  NewsTableViewController.m
//  志同道合
//
//  Created by 李雅 on 16/6/12.
//  Copyright © 2016年 羊羊羊～咩～. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsTableViewCell.h"
#import "NewsModel.h"
#import "DetailViewController.h"

#define kWidth (self.view.frame.size.width)

#define NEWSURL @"http://42.62.94.234:5222/gslb/?ver=3.0&type=wifi&uuid=0&list=f3.mi-stat.gslb.mi-idc.com%2Capp.chat.xiaomi.net%2Cresolver.msg.xiaomi.net&key=816b472510719fca49fcd6df68117139"

@interface NewsTableViewController ()

@property (strong, nonatomic)UIScrollView *scrollView;

@property (strong, nonatomic)UIPageControl *pageControl;

@property (strong, nonnull)NSMutableArray *dataArray;

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新闻";
    [self UITabBarItemACtion];
    
    [self scrollViewACtion];
}
#pragma mark - UITabBarItem
- (void)UITabBarItemACtion{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(itemAC:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)itemAC:(UIBarButtonItem *)item{
    
    NSLog(@"哈哈哈");
}

#pragma mark - UIScrollView
- (void)scrollViewACtion{
    
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    //    UIScrollView
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    _scrollView.contentSize = CGSizeMake(kWidth * 5, 200);
    _scrollView.pagingEnabled = YES;
    [aView addSubview:_scrollView];
    
    //    UIImageView
    for (int i = 0; i < 5; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 200)];
        [self.scrollView addSubview:imgView];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d.jpg",i + 1]];
    }
    //    UIPageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(260, 180, 150, 20)];
    _pageControl.numberOfPages = 5;
    _pageControl.pageIndicatorTintColor = [UIColor purpleColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    
    [aView addSubview:_pageControl];
    self.tableView.tableHeaderView = aView;
}
//pageControl点击事件
-(void)changePage:(UIPageControl *)sender{
    
    self.scrollView.contentOffset = CGPointMake(kWidth *_pageControl.currentPage, 0);
    
}

//scrollView 必须实现的方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews.firstObject;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage = _scrollView.contentOffset.x/kWidth;
}

- (void)sendRequest{
    //    拼接URL
    NSURL *url = [NSURL URLWithString:NEWSURL];
    //    创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //   创建连接对象，发起请求，获得数据
    __weak typeof (self)weakSelf = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data == nil) {
            return ;
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *allCinemaArr = dic[@"wap"];
            for (NSDictionary *dict in allCinemaArr) {
                //                    把小字典转化成电影模型
                NewsModel *newsModel =[[NewsModel alloc]init];
                [newsModel setValuesForKeysWithDictionary:dict];
                //                     把电影模型装入数据源
                [weakSelf.dataArray addObject:newsModel];
            }
            
        }
        //            拿到数据，回到主线程，刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            //            刷新表
            [self.tableView reloadData];
        });
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"NewsTableViewCell" owner:nil options:nil]firstObject];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
