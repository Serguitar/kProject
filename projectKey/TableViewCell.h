//
//  TableViewCell.h
//  projectKey
//
//  Created by Сергей Лукоянов on 25.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewCell;

@protocol TableViewCellDeelgate <NSObject>

- (void)plusButtonTappedInCell:(TableViewCell *)cell;
- (void)minusButtonTappedInCell:(TableViewCell *)cell;
- (void)didSelectCell:(TableViewCell *)cell;

@end

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desctTF;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UITextField *quntityTF;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) id <TableViewCellDeelgate> delegate;


@end
