//
//  RecipeDetailViewControlerViewController.m
//  Recipe
//
//  Created by zhaoyou on 4/13/15.
//  Copyright (c) 2015 zhaoyou. All rights reserved.
//

#import "RecipeDetailViewController.h"

@interface RecipeDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UITextView *textBrief;
@property (weak, nonatomic) IBOutlet UITextView *textGuide;

@end

@implementation RecipeDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.recipeData) {
        NSLog(@"recipeData: %@", self.recipeData);
        self.textBrief.text = [self.recipeData valueForKey:@"brief"];
        self.textGuide.text = [self.recipeData valueForKey:@"guide"];
        self.title = [self.recipeData valueForKey:@"name"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.recipeData valueForKey:@"imageSrc"]]];
                    if (imgData) {
                         UIImage *image = [UIImage imageWithData:imgData];
                        if (image) {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                self.recipeImage.image = image;
                            });
                        } else {
                            NSLog(@"image error");
                        }
                    } else {
                        NSLog(@"imageData Error");
                    }
                });

    }
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
