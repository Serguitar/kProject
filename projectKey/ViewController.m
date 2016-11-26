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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, ItemVCDelegate, TableViewCellDeelgate> {
    NSArray *items;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    items = [NSArray array];
    
//    objects = @[ @1, @2, @3, @4, @5];
    
    _tableView.tableFooterView = [UIView new];
    
    [self performSelector:@selector(showItemView) withObject:nil afterDelay:2.0];
    
    [self configureButton];
}

- (void)configureButton {
    CALayer *layer = _assembleOrderButton.layer;
    layer.cornerRadius = _assembleOrderButton.frame.size.height/2;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 1;
}

- (void)showItemView {
    [self performSegueWithIdentifier:@"toItem" sender:nil];
}

- (void)calcPrice {
    CGFloat price = 0;
    for (Item *item in items) {
        price += item.cost * item.quantity;
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"%.1f $", price];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toItem"]) {
        
        Item *item = [Item new];
        item.name = @"test";
        item.cost = 50;
        item.quantity = 1;
        
        ItemVC *itemVC = [segue destinationViewController];
        itemVC.delegate = self;
        itemVC.item = item;
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdet = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdet forIndexPath:indexPath];
    cell.delegate = self;
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
            NSMutableArray *itemsMut = [NSMutableArray new];
            [itemsMut removeObject:item];
            items = itemsMut.copy;
            [self.tableView reloadData];
            [self calcPrice];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
                                    
    }
}





@end
