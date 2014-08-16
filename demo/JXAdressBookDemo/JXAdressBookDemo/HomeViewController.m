#import "HomeViewController.h"
#import "JXAddressBook.h"

@interface HomeViewController ()
{
    UITableView *_tableView;

    UISearchBar *_searchBar;
    UISearchDisplayController *_searchController;

    NSArray *_dataArray;
    NSArray *_searchArray;
}

#define nullStrToEmpty(str) \
    [str rangeOfString:@"null"].location==0? @"" : str

@end

@implementation HomeViewController

#pragma mark -
#pragma mark - Method Demo

- (void)refreshPersonInfoTableView
{
    [JXAddressBook getPersonInfo:^(NSArray *personInfos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataArray = personInfos;
            [_tableView reloadData];
        });
    }];
}
- (void)refreshSearchTableView:(NSString *)searchText
{
    [JXAddressBook searchPersonInfo:searchText addressBookBlock:^(NSArray *personInfos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _searchArray = personInfos;
            [_searchController.searchResultsTableView reloadData];
        });
    }];
}

#pragma mark -
#pragma mark - CREATE UI

- (IBAction)refreshAddressBook:(id)sender
{
    [self refreshPersonInfoTableView];
}

- (void)createTableView
{
    _dataArray = [NSArray array];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|
                                  UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
}
- (void)createSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _searchBar.frame.size.height)];
    _tableView.tableHeaderView = _searchBar;
    _searchBar.delegate = self;
    
    _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchController.searchResultsDataSource = self;
    _searchController.searchResultsDelegate = self;
}

#pragma mark -
#pragma mark - 生命周期

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTableView];
    [self createSearchBar];
}

#pragma mark -
#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_searchController.searchResultsTableView) {
        return _searchArray.count;
    }
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellId = @"UITableViewCell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    JXPersonInfo *personInfo = nil;
    
    if (tableView == _searchController.searchResultsTableView) {
        personInfo = [_searchArray objectAtIndex:indexPath.row];
    }else {
        personInfo = [_dataArray objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                           nullStrToEmpty(personInfo.firstName),
                           nullStrToEmpty(personInfo.lastName)];
    
    if (personInfo.phone.count>0) {
        cell.detailTextLabel.text = [personInfo.phone[0] objectForKey:((NSDictionary *)personInfo.phone[0]).allKeys[0]];
    }else {
        cell.detailTextLabel.text = @"暂无联系方式";

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark - SearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self refreshSearchTableView:searchText];
}

@end
