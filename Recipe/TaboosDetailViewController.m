//
//  TaboosDetailViewController.m
//  Recipe
//
//  Created by zhaoyou on 4/14/15.
//  Copyright (c) 2015 zhaoyou. All rights reserved.
//

#import "TaboosDetailViewController.h"

@interface TaboosDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tabooImage;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;



@end

@implementation TaboosDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.taboosData) {
        [self loadData];
    }
}

-(void) loadData
{
    self.title = [self.taboosData valueForKey:@"title"];
    self.reasonTextView.text = [self.taboosData valueForKey:@"reason"];
    NSArray *items =[self.taboosData valueForKey:@"items"];
    self.itemLabel.text = [items componentsJoinedByString:@";"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.taboosData valueForKey:@"imageSrc"]]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.tabooImage.image = image;
                });
            } else {
                NSLog(@"image error");
            }
        } else {
            NSLog(@"imageData Error");
        }
    });

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
