//
//  ViewController.m
//  CoreNFC
//
//  Created by SK_15 on 2019/5/7.
//  Copyright © 2019 SK.com. All rights reserved.
//

#import "ViewController.h"
#import <CoreNFC/CoreNFC.h>


@interface ViewController ()<NFCNDEFReaderSessionDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NFCNDEFReaderSession *session;
}

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation ViewController

static NSString * cellIdentifier = @"identifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arr = [NSMutableArray arrayWithCapacity:0];
    
    [self setNavigationRightBtn];
    
    [self setupUI];
   
}

- (void)setNavigationRightBtn
{
    UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [sender setTitle:@"Scan" forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor redColor];
    [sender addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:sender];
    
    [self.navigationItem setRightBarButtonItem:buttonItem];
    
}

- (void)buttonClicked:(UIButton *)sender
{
    if (@available(iOS 11.0,*)) {
   
     session = [[NFCNDEFReaderSession alloc]initWithDelegate:self queue:nil invalidateAfterFirstRead:YES];
    
    [session beginSession];
        

    }
}

-(void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages
{
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *payLoad in message.records) {
            NSLog(@"PayLoad  data: %@",payLoad.payload);
            [self.arr addObject:payLoad.payload];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.myTableView reloadData];
                
            });
           
        }
    }
}

- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error
{
    NSLog(@"Error: --- %@",error);
}

- (void)setupUI
{
    self.myTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
   
     cell.textLabel.text = @"古古怪怪哥哥哥哥哥哥";
    
    if (self.arr.count > indexPath.row) {
        
        cell.textLabel.text = [self.arr objectAtIndex:indexPath.row];
    }
    
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
