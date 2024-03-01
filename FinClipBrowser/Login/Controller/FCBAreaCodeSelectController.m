//
//  FCBAreaCodeSelectController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/15.
//

#import "FCBAreaCodeSelectController.h"
#import "FCBAreaCodeSelectCell.h"
#import "FCBUITool.h"
#import <Masonry/Masonry.h>

@interface FCBAreaCodeSelectController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, copy) NSString *countryNameCN;

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *list;

@end

@implementation FCBAreaCodeSelectController

- (instancetype)initWithAreaCode:(NSString *)areaCode countryNameCN:(NSString *)countryNameCN {
    if (self = [super init]) {
        self.areaCode = areaCode;
        self.countryNameCN = countryNameCN;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareUI];
    [self layoutUI];
    [self loadListData];
}

- (void)prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableview.separatorColor = kRGB(0xEEEEEE);
    [self.tableview registerClass:FCBAreaCodeSelectCell.class forCellReuseIdentifier:FCBAreaCodeSelectCell.description];
    [self.view addSubview:self.tableview];
}

- (void)layoutUI {
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadListData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"areaCode" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    self.list = list;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCBAreaCodeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:FCBAreaCodeSelectCell.description forIndexPath:indexPath];
    
    NSDictionary *data = self.list[indexPath.row];
    NSString *cnName = data[@"cn"];
    NSString *areaCode = data[@"prefix"];
    
    BOOL isSelect = NO;
    if (self.countryNameCN.length) {
        isSelect = [cnName isEqualToString:self.countryNameCN];
    } else {
        isSelect = [areaCode isEqualToString:self.areaCode];
    }
    
    [cell setTitle:cnName areaCode:areaCode isSelect:isSelect];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *data = self.list[indexPath.row];
    self.selectedCallback ? self.selectedCallback(data[@"prefix"], data[@"cn"]) : nil;
}

@end
