//  TableViewCell.h
//  FindMeApp
//
//  Created by bepid on 02/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgPermission;
@property (weak, nonatomic) IBOutlet UILabel *imgUserColor;

@end
