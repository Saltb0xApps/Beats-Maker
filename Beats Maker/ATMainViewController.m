#import "ATMainViewController.h"
/*
 =================================================================================== CHANGELOG ============================================================================================
 *** = Submitted to the appstore
 **# = Completed
 *## = Under Progress
 ### = Not started
 
 *** 1.0
 • Initial Release.
 =================================================================================== CHANGELOG ============================================================================================
 */
@interface UIImage (WithColor)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
@implementation UIImage (WithColor)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
@interface ATCollectionViewCell : UICollectionViewCell
#define IMAGE_HEIGHT 200
#define IMAGE_OFFSET_SPEED 25
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, assign, readwrite) CGPoint imageOffset;
@property (nonatomic, strong, readwrite) UIImageView *ATImageView;
@property (nonatomic, strong, readwrite) UILabel *ATTitleLabel;
@end
@implementation ATCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setupImageView];
    return self;
}
- (void)setupImageView {
    self.clipsToBounds = YES;

    self.ATImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
    self.ATImageView.backgroundColor = [UIColor clearColor];
    self.ATImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.ATImageView.clipsToBounds = NO;
    self.ATImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.ATImageView];
    
    self.ATTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, IMAGE_HEIGHT/2-40, self.bounds.size.width, 80)];
    self.ATTitleLabel.backgroundColor = [UIColor clearColor];
    self.ATTitleLabel.clipsToBounds = NO;
    self.ATTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.ATTitleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    self.ATTitleLabel.font = [UIFont fontWithName:@"googleicon" size:21];
    
    self.ATTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.ATTitleLabel];
}
- (void)setImage:(UIImage *)image {
    self.ATImageView.image = image;
    [self setImageOffset:self.imageOffset];
}
- (void)setTitle:(NSString *)title {
    self.ATTitleLabel.text = [title uppercaseString];
}
- (void)setImageOffset:(CGPoint)imageOffset {
    _imageOffset = imageOffset;
    CGRect frame = self.ATImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.ATImageView.frame = offsetFrame;
}
@end
@implementation ATMainViewController
#pragma mark - Primary Funtions -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*basic view setup*/
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.frame = [[UIScreen mainScreen]bounds];
    self.view.backgroundColor = UIColorFromHex(0x090909);
    
    UILabel *TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, self.view.bounds.size.height)];
    TitleLabel.text = @"Beats Maker";
    TitleLabel.font = [UIFont fontWithName:@"Avenir" size:18];
    TitleLabel.textAlignment = NSTextAlignmentCenter;
    TitleLabel.backgroundColor = [UIColor clearColor];
    TitleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = TitleLabel;
    self.navigationItem.hidesBackButton = NO;
    
    UIBarButtonItem *unlockAll = [[UIBarButtonItem alloc] initWithTitle:@"" /*locked symbol*/ style:UIBarButtonItemStylePlain target:self action:@selector(showIAP)];
    unlockAll.tintColor = [UIColor whiteColor];
    [unlockAll setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"googleicon" size:18.0]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = unlockAll;
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithTitle:@"" /*open in symbol*/ style:UIBarButtonItemStylePlain target:self action:@selector(shareWithFriends)];
    share.tintColor = [UIColor whiteColor];
    [share setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"googleicon" size:18.0]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = share;
    
    /*collection view*/
    slideshowImages =  [[NSArray alloc] initWithObjects:
                        [NSString stringWithFormat:@"acoustic.jpg"], //0
                        [NSString stringWithFormat:@"alternative.jpg"], //1
                        [NSString stringWithFormat:@"blues.png"], /*Locked*/ //2
                        [NSString stringWithFormat:@"cadence.jpg"],/*Locked*/ //3
                        [NSString stringWithFormat:@"choral.JPG"], /*Locked*/ //4
                        [NSString stringWithFormat:@"classic.jpg"],/*Locked*/ //5
                        [NSString stringWithFormat:@"conjunto.jpg"],/*Locked*/ //6
                        [NSString stringWithFormat:@"country.jpeg"], //7
                        [NSString stringWithFormat:@"crunch.jpg"], //8
                        [NSString stringWithFormat:@"electric.jpg"], //9
                        [NSString stringWithFormat:@"funk.jpg"],/*Locked*/ //10
                        [NSString stringWithFormat:@"fusion.jpg"],/*Locked*/ //11
                        [NSString stringWithFormat:@"garage.jpg"],/*Locked*/ //12
                        [NSString stringWithFormat:@"groove.jpg"],/*Locked*/ //13
                        [NSString stringWithFormat:@"indie.jpg"],/*Locked*/ //14
                        [NSString stringWithFormat:@"industrial.jpg"], //15
                        [NSString stringWithFormat:@"opera.jpg"], //16
                        [NSString stringWithFormat:@"pearl.jpg"],/*Locked*/ //17
                        [NSString stringWithFormat:@"phaser.jpg"],/*Locked*/ //18
                        [NSString stringWithFormat:@"rough.jpg"],/*Locked*/ //19
                        [NSString stringWithFormat:@"smooth.jpg"],/*Locked*/ //20
                        [NSString stringWithFormat:@"standard.jpg"], //21
                        [NSString stringWithFormat:@"surf.png"], //22
                        [NSString stringWithFormat:@"swing.jpg"],/*Locked*/ //23
                        [NSString stringWithFormat:@"wave.png"], //24
                        nil];

    UICollectionViewFlowLayout *drumsCollectionLayout = [[UICollectionViewFlowLayout alloc] init];
    drumsCollectionLayout.minimumInteritemSpacing = 0;
    drumsCollectionLayout.minimumLineSpacing = 10;
    drumsCollectionLayout.itemSize = CGSizeMake(self.view.bounds.size.width, 200);
    drumsCollectionLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    drumsCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:drumsCollectionLayout];
    drumsCollectionView.dataSource = self;
    drumsCollectionView.delegate = self;
    drumsCollectionView.backgroundColor = UIColorFromHex(0x111111);
    drumsCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [drumsCollectionView registerClass:[ATCollectionViewCell class] forCellWithReuseIdentifier:@"ATCell"];
    [self.view addSubview:drumsCollectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return slideshowImages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ATCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColorFromHex(0x111111);
    
    cell.image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.033] size:CGSizeMake(self.view.bounds.size.width, 300)];
    cell.tag = indexPath.item;
    NSString *drumKit = [[[[[slideshowImages objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@".jpg" withString:@""] stringByReplacingOccurrencesOfString:@".jpeg" withString:@""] stringByReplacingOccurrencesOfString:@".png" withString:@""] stringByReplacingOccurrencesOfString:@".JPG" withString:@""];
    if(cell.tag == 0 || cell.tag == 1 || cell.tag == 7 || cell.tag == 8 || cell.tag == 9 || cell.tag == 15 || cell.tag == 16 || cell.tag == 21 || cell.tag == 22 || cell.tag == 24) {
        [cell setTitle:drumKit];
    } else {
        if(cell.tag == 2 || cell.tag == 3 || cell.tag == 4 || cell.tag == 5 || cell.tag == 6 ) /*kit 1*/ {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Kit1Unlocked"] isEqualToString:@"Yep"]) {
                [cell setTitle:drumKit];
            } else {
                [cell setTitle:[drumKit stringByAppendingString:@" "]];
            }
        } else if(cell.tag == 10 || cell.tag == 11 || cell.tag == 12 || cell.tag == 13 || cell.tag == 14 ) /*kit 2*/ {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Kit2Unlocked"] isEqualToString:@"Yep"]) {
                [cell setTitle:drumKit];
            } else {
                [cell setTitle:[drumKit stringByAppendingString:@" "]];
            }
        } else if(cell.tag == 17 || cell.tag == 18 || cell.tag == 19 || cell.tag == 20 || cell.tag == 23 ) /*kit 3*/ {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Kit3Unlocked"] isEqualToString:@"Yep"]) {
                [cell setTitle:drumKit];
            } else {
                [cell setTitle:[drumKit stringByAppendingString:@" "]];
            }
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *img = [UIImage imageNamed:[slideshowImages objectAtIndex:indexPath.row]];
        img = [[img applyBlurWithRadius:2.5 tintColor:[UIColor colorWithWhite:0 alpha:0.5] saturationDeltaFactor:1 maskImage:nil] imageScaledToSize:CGSizeMake(self.view.bounds.size.width, 300)];
        dispatch_async(dispatch_get_main_queue(), ^{
            ATCollectionViewCell *cell = (ATCollectionViewCell *)[drumsCollectionView cellForItemAtIndexPath:indexPath];
            [UIView transitionWithView:cell.ATImageView duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [cell setImage:img];
            } completion:nil];
        });
    });
    
    CGFloat yOffset = ((drumsCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([collectionView cellForItemAtIndexPath:indexPath].tag == 0 || [collectionView cellForItemAtIndexPath:indexPath].tag == 1 ||
       [collectionView cellForItemAtIndexPath:indexPath].tag == 7 || [collectionView cellForItemAtIndexPath:indexPath].tag == 8 ||
       [collectionView cellForItemAtIndexPath:indexPath].tag == 9 || [collectionView cellForItemAtIndexPath:indexPath].tag == 15 ||
       [collectionView cellForItemAtIndexPath:indexPath].tag == 16 || [collectionView cellForItemAtIndexPath:indexPath].tag == 21 ||
       [collectionView cellForItemAtIndexPath:indexPath].tag == 22 || [collectionView cellForItemAtIndexPath:indexPath].tag == 24) /*free*/ {
        ATDrumsViewController *test = [[ATDrumsViewController alloc]initWithNibName:nil bundle:nil];
        test.modalPresentationStyle = UIModalPresentationCustom;
        test.drumKit = ((ATCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]).ATTitleLabel.text;
        [test setTransitioningDelegate:[RZTransitionsManager shared]];
        [self.navigationController pushViewController:test animated:YES];
    } else if([collectionView cellForItemAtIndexPath:indexPath].tag == 2 || [collectionView cellForItemAtIndexPath:indexPath].tag == 3 ||
              [collectionView cellForItemAtIndexPath:indexPath].tag == 4 || [collectionView cellForItemAtIndexPath:indexPath].tag == 5 ||
              [collectionView cellForItemAtIndexPath:indexPath].tag == 6 ) /*kit 1*/ {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Kit1Unlocked"] isEqualToString:@"Yep"]) {
            ATDrumsViewController *test = [[ATDrumsViewController alloc]initWithNibName:nil bundle:nil];
            test.modalPresentationStyle = UIModalPresentationCustom;
            test.drumKit = ((ATCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]).ATTitleLabel.text;
            [test setTransitioningDelegate:[RZTransitionsManager shared]];
            [self.navigationController pushViewController:test animated:YES];
        } else {
            [self showIAP];
        }
    } else if([collectionView cellForItemAtIndexPath:indexPath].tag == 10 || [collectionView cellForItemAtIndexPath:indexPath].tag == 11 ||
              [collectionView cellForItemAtIndexPath:indexPath].tag == 12 || [collectionView cellForItemAtIndexPath:indexPath].tag == 13 ||
              [collectionView cellForItemAtIndexPath:indexPath].tag == 14 ) /*kit 2*/ {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Kit2Unlocked"] isEqualToString:@"Yep"]) {
            ATDrumsViewController *test = [[ATDrumsViewController alloc]initWithNibName:nil bundle:nil];
            test.modalPresentationStyle = UIModalPresentationCustom;
            test.drumKit = ((ATCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]).ATTitleLabel.text;
            [test setTransitioningDelegate:[RZTransitionsManager shared]];
            [self.navigationController pushViewController:test animated:YES];
        } else {
            [self showIAP];
        }
    } else if([collectionView cellForItemAtIndexPath:indexPath].tag == 17 || [collectionView cellForItemAtIndexPath:indexPath].tag == 18 ||
              [collectionView cellForItemAtIndexPath:indexPath].tag == 19 || [collectionView cellForItemAtIndexPath:indexPath].tag == 20 ||
              [collectionView cellForItemAtIndexPath:indexPath].tag == 23 ) /*kit 3*/ {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Kit3Unlocked"] isEqualToString:@"Yep"]) {
            ATDrumsViewController *test = [[ATDrumsViewController alloc]initWithNibName:nil bundle:nil];
            test.modalPresentationStyle = UIModalPresentationCustom;
            test.drumKit = ((ATCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]).ATTitleLabel.text;
            [test setTransitioningDelegate:[RZTransitionsManager shared]];
            [self.navigationController pushViewController:test animated:YES];
        } else {
            [self showIAP];
        }
    }
}
- (void)showIAP {
    ATIAPAllKitsViewController *vc = [[ATIAPAllKitsViewController alloc] initWithNibName:nil bundle:nil];
    [vc setTransitioningDelegate:[RZTransitionsManager shared]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(ATCollectionViewCell *view in drumsCollectionView.visibleCells) {
        CGFloat yOffset = ((drumsCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}
- (void)shareWithFriends {
    NSString *actionSheetTitle = @"Share Beats Maker"; //Action Sheet Title
    NSString *destructiveTitle = @"Cancel"; //Action Sheet Button Titles
    NSString *other1 = @"Twitter";
    NSString *other2 = @"Facebook";
    NSString *other3 = @"Sms";
    NSString *other4 = @"Email";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:other1, other2, other3, other4, nil];
    
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Twitter"]) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *sheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            SLComposeViewControllerCompletionHandler completionBlock = ^(SLComposeViewControllerResult result){
                
                [sheet dismissViewControllerAnimated:YES completion:Nil];
            };
            sheet.completionHandler = completionBlock;
            
            //Adding the Text to the post value from iOS
            [sheet setInitialText:@"Check Out Beats Maker - https://itunes.apple.com/app/id966094388"];
            [self presentViewController:sheet animated:YES completion:Nil];
        }
    }
    if ([buttonTitle isEqualToString:@"Facebook"]) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *sheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler completionBlock = ^(SLComposeViewControllerResult result){
                
                [sheet dismissViewControllerAnimated:YES completion:Nil];
            };
            sheet.completionHandler = completionBlock;
            
            //Adding the Text to the post value from iOS
            [sheet setInitialText:@"Check Out Beats Maker - https://itunes.apple.com/app/id966094388"];
            [self presentViewController:sheet animated:YES completion:Nil];
        }
        
    }
    if ([buttonTitle isEqualToString:@"Sms"]) {
        if([MFMessageComposeViewController canSendText]) {
            NSArray *recipents = nil;
            NSString *message = @"Check Out Beats Maker - https://itunes.apple.com/app/id966094388";
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
            [messageController setRecipients:recipents];
            [messageController setBody:message];
            [self presentViewController:messageController animated:YES completion:nil];
        }
    }
    if ([buttonTitle isEqualToString:@"Email"]) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            [controller setSubject:[NSString stringWithFormat:@"Check Out Beats Maker"]];
            [controller setMessageBody:@"Download here - https://itunes.apple.com/app/id966094388" isHTML:NO];
            controller.mailComposeDelegate = self;
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve ;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Unimportant Stuff -
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
- (void)didReceiveMemoryWarning{[super didReceiveMemoryWarning];}
- (void)viewDidUnload{ [super viewDidUnload]; }
- (void)dealloc { [super dealloc]; }
- (BOOL)canBecomeFirstResponder {return YES;}
- (BOOL)prefersStatusBarHidden {return YES;}
- (BOOL)shouldAutorotate{return NO;}
- (UIStatusBarStyle) preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
- (NSUInteger)supportedInterfaceOrientations{return UIInterfaceOrientationMaskAllButUpsideDown;}
@end