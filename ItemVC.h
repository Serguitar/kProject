//
//  ItemVC.h
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@protocol ItemVCDelegate <NSObject>

- (void)didSelectItem:(Item *)item;

@end

@interface ItemVC : UIViewController
@property(nonatomic, strong) Item *item;
@property(nonatomic, weak) id <ItemVCDelegate> delegate;

@end
