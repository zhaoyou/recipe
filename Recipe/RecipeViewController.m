//
//  FirstViewController.m
//  Recipe
//
//  Created by zhaoyou on 4/8/15.
//  Copyright (c) 2015 zhaoyou. All rights reserved.
//

#import "RecipeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RecipeDetailViewController.h"

@interface RecipeViewController ()

@property (nonatomic, strong) NSArray *recipes;
@property (nonatomic, strong) NSURLSession  *session;

@end

@implementation RecipeViewController


-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self fetchRecipe];
}

-(void) fetchRecipe
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // NSURL
    NSURL *downloadUrl = [NSURL URLWithString:@"http://127.0.0.1:3000/api/recipes"];
    
    [[self.session dataTaskWithURL:downloadUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            
            if (res.statusCode == 200) {
                
                NSError *err;
                
                NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                
                if (!err) {
                   // NSLog(@"%@", jsonData);
                    self.recipes = jsonData;
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [self.tableView reloadData];
                    });
                    
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"JSon Parse Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }] resume];
}

#pragma mark - Navigation
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSLog(@"prepareForSegue....");
        RecipeDetailViewController *detail = (RecipeDetailViewController *) segue.destinationViewController;
        NSDictionary *recipeData = self.recipes[[self.tableView indexPathForSelectedRow].row];
        detail.recipeData = recipeData;
    }
}

#pragma table datasource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipes count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"recipeId";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:kCustomCellID];
    }
    
    NSDictionary *data = [self.recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = [data valueForKey:@"name"];
    NSURL *url = [NSURL URLWithString:[data valueForKey:@"imageSrc"]];
    
   // [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
  //  NSLog(@"url: %@", url);
    
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"db3.jpg"]];
    
//    UIImage *image = [UIImage imageNamed:@"db3.jpg"];
//    cell.imageView.image  = image;
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    
//    cell.imageView.image = nil;
//    
//    dispatch_async(queue, ^{
//        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[data valueForKey:@"imageSrc"]]];
//        
//        if (imgData) {
//             UIImage *image = [UIImage imageWithData:imgData];
//            if (image) {
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                    UITableViewCell *originCell = (id) [self.tableView cellForRowAtIndexPath:indexPath];
//                    originCell.imageView.image = image;
//                    NSLog(@"%@", originCell);
//                });
//            } else {
//                NSLog(@"image error");
//            }
//        } else {
//            NSLog(@"imageData Error");
//        }
//    });
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
