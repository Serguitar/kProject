//
//  ViewController.m
//  projectKey
//
//  Created by Сергей Лукоянов on 25.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "ItemVC.h"
#import "InfoVC.h"
#import "CardRouter.h"
#import "NetManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, ItemVCDelegate, TableViewCellDeelgate> {
    NSArray *items;
    NetManager *netManager;
    Item *foundItem;
    NSArray *testOrders;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *nfcContainerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _bottomBarHeightConstraint.constant = 0;
    
    testOrders = @[
                   @6408070025598,
                   @4042448843227,
                   @8016738709162,
                   @3253560306977,
                   @5000366120331,
                   @3253561929052,
                   @7320090038527,
                   @7311490010787,
                   @7320090038510,
                   @27393564291018
                   ];
    
    items = [NSArray array];
    
//    objects = @[ @1, @2, @3, @4, @5];
    
    _tableView.tableFooterView = [UIView new];
    
//    [self performSelector:@selector(showItemView) withObject:nil afterDelay:2.0];
    
    [self configureButton];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearOrder) name:@"CLOSE" object:nil];
    
    netManager = [NetManager new];
    
    _tableView.estimatedRowHeight = 80;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)viewTapped {
    [self showItemView];
}

- (void)clearOrder {
    items = [NSArray array];
    [self.tableView reloadData];
    [self calcPrice];
    [self hidBottomBar];
    [_nfcContainerView setHidden:NO];
}

- (void)configureButton {
    CALayer *layer = _assembleOrderButton.layer;
    layer.cornerRadius = _assembleOrderButton.frame.size.height/2;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 1;
}

- (void)showItemView {
    NSString *eanStr  = @"6408070025598";
    [netManager loadProductWithEAN:eanStr block:^(id object, NSError *error) {
        if (!error) {
            foundItem = [Item itemFromDict:object];
            [netManager loadPriceWithEAN:eanStr block:^(id object, NSError *error) {
                if (error) {
                    NSLog(@"%@",error.localizedDescription);
                } else {
                    NSDictionary *dict = object;
                    if (dict[@"price"]) {
                        foundItem.cost = [dict[@"price"] doubleValue];
                    }
                    [self performSegueWithIdentifier:@"toItem" sender:nil];
                }
            }];
        }
    }];
    
    
//    for (NSNumber *number in testOrders) {
//        NSString *eantStr = number.stringValue;
//        [netManager loadProductWithEAN:eantStr block:^(id object, NSError *error) {
//            if (!error) {
//                foundItem = [Item itemFromDict:object];
//                items = [items arrayByAddingObject:foundItem];
//                [self.tableView reloadData];
//            }
//        }];
//    }
}

- (void)showBottomBar {
    [UIView animateWithDuration:1.0 animations:^{
        _bottomBarHeightConstraint.constant = 64;
    }];
}

- (void)hidBottomBar {
    [UIView animateWithDuration:1.0 animations:^{
        _bottomBarHeightConstraint.constant = 0;
    }];
}

- (void)calcPrice {
    CGFloat price = 0;
    for (Item *item in items) {
        price += item.cost * item.quantity;
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"%.1f €", price];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toItem"]) {
        
#warning
//        Item *item = [Item new];
//        item.name = @"test";
//        item.cost = 50;
//        item.quantity = 1;
        
        ItemVC *itemVC = [segue destinationViewController];
        itemVC.delegate = self;
        itemVC.item = foundItem;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdet = @"cell";
    Item *item = items[indexPath.row];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdet forIndexPath:indexPath];
    cell.delegate = self;
    cell.priceLabel.text = [NSString stringWithFormat:@"%.1f €", item.cost];
    
    if (item.quantity > 0) {
        cell.quntityTF.text = [NSString stringWithFormat:@"%i", item.quantity];
    }
    
    if (item.photoLink) {
        NSURL *url = [NSURL URLWithString:item.photoLink];
        [cell.photoIV sd_setImageWithURL:url
                     placeholderImage:nil];
        
    }
    
    cell.nameLabel.text = item.name;
    cell.desctTF.text = item.shortDescr;
                        ;
//    cell.photoIV.image = [UIImage imageNamed:@"d"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showItemView];
}

- (void)didSelectItem:(Item *)item {
    items = [items arrayByAddingObject:item];
//    items = [items arrayByAddingObject:item];
    [self.tableView reloadData];
    [self calcPrice];
    [self showBottomBar];
    [_nfcContainerView setHidden:YES];
}


//TableViewCellDeelgate
- (void)plusButtonTappedInCell:(TableViewCell *)cell {
    NSUInteger row = [self.tableView indexPathForCell:cell].row;
    Item *item = items[row];
    item.quantity += 1;
    cell.quntityTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)item.quantity];
    [self calcPrice];
}

- (void)minusButtonTappedInCell:(TableViewCell *)cell {
    NSUInteger row = [self.tableView indexPathForCell:cell].row;
    Item *item = items[row];
    
    NSUInteger quant = item.quantity - 1;
    if (quant > 0) {
        item.quantity = quant;
        cell.quntityTF.text = [NSString stringWithFormat:@"%lu",(unsigned long)item.quantity];
        [self calcPrice];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Do you want to remove this item?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableArray *itemsMut = items.mutableCopy;
            [itemsMut removeObject:item];
            items = itemsMut.copy;
            [self.tableView reloadData];
            [self calcPrice];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (IBAction)infoButtonTapped:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    InfoVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"InfoVC_SID"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)buyButtonTapped:(id)sender {
    [CardRouter showCardOnVC:self fromItem:NO price:_priceLabel.text];
}


@end
