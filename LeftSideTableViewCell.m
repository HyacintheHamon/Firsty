//
//  LeftSideTableViewCell.m
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "LeftSideTableViewCell.h"
#import "Define.h"

@implementation LeftSideTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       [self setBackgroundColor:UIColorFromRGB(0x23262F)];
        
        self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 30, 30)];
        
        self.cellLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.cellImageView.frame.origin.x + self.cellImageView.frame.size.width + 20, _cellImageView.frame.origin.y + 5, 130, 30)];
        _cellLbl.textColor = [UIColor whiteColor];
        _cellLbl.font = [UIFont systemFontOfSize:17];
        
        [self addSubview:_cellImageView];
        [self addSubview:_cellLbl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
