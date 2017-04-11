//
//  AsmaulHusanaView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "AsamulaHasanaCell.h"
#import "AsmaulHusanaView.h"
#import "SVProgressHUD.h"


@interface AsmaulHusanaView ()
{
    NSArray *allahNames;
}
@end

@implementation AsmaulHusanaView

- (BOOL)shouldAutorotate
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000  
- (NSUInteger)supportedInterfaceOrientations  
#else  
- (UIInterfaceOrientationMask)supportedInterfaceOrientations  
#endif  
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    allahNames = [self getAllahNames];
    
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.title=@"Asmaul Husana";
}

-(void)viewWillAppear:(BOOL)animated
{
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
    
    [super viewWillAppear:animated];
}

#pragma mark - UItableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allahNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AsamulaHasanaCell *cell = (AsamulaHasanaCell*)[self.tableView dequeueReusableCellWithIdentifier:@"asamulaHasanaCell" forIndexPath:indexPath];

    if (nil == cell) {
        cell = [[AsamulaHasanaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asamulaHasanaCell"];
    }
    [cell.label1 setText:[allahNames[indexPath.row] objectAtIndex:0]];
    [cell.label2 setText:[allahNames[indexPath.row] objectAtIndex:1]];
    [cell.label3 setText:[allahNames[indexPath.row] objectAtIndex:2]];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44.0)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width/3, 44.0)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width/3, 0, self.tableView.frame.size.width/3, 44.0)];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width*2/3, 0, self.tableView.frame.size.width/3, 44.0)];
    
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    [label1 setNumberOfLines:0];
    [label2 setNumberOfLines:0];
    [label3 setNumberOfLines:0];

    [label1 setFont:[UIFont systemFontOfSize:14.0]];
    [label2 setFont:[UIFont systemFontOfSize:14.0]];
    [label3 setFont:[UIFont systemFontOfSize:14.0]];

    [label1 setText:@"Name"];
    [label1 setTextColor:[UIColor darkGrayColor]];
    
    [label2 setText:@"Translation"];
    [label2 setTextColor:[UIColor darkGrayColor]];

    [label3 setText:@"Transliteration"];
    [label3 setTextColor:[UIColor darkGrayColor]];

    [headerView addSubview:label1];
    [headerView addSubview:label2];
    [headerView addSubview:label3];
    
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (NSArray *)getAllahNames
{
    return @[@[@"الله", @"The Greatest Name", @"Allah"], @[@"الرحمن", @"The All-Compassionate", @"Ar-Rahman"], @[@"الرحيم", @"The All-Merciful", @"Ar-Rahim"], @[@"الملك", @"The Absolute Ruler", @"Al-Malik"], @[@"القدوس", @"The Pure One", @"Al-Quddus"], @[@"السلام", @"The Source of Peace", @"As-Salam"], @[@"المؤمن", @"The Inspirer of Faith", @"Al-Mu'min"], @[@"المهيمن", @"The Guardian", @"Al-Muhaymin"], @[@"العزيز", @"The Victorious", @"Al-Aziz"], @[@"الجبار", @"The Compeller", @"Al-Jabbar"], @[@"المتكبر", @"The Greatest", @"Al-Mutakabbir"], @[@"الخالق", @"The Creator", @"Al-Khaliq"], @[@"البارئ", @"The Maker of Order", @"Al-Bari'"], @[@"المصور", @"The Shaper of Beauty", @"Al-Musawwir"], @[@"الغفار", @"The Forgiving", @"Al-Ghaffar"], @[@"القهار", @"The Subduer", @"Al-Qahhar"], @[@"الوهاب", @"The Giver of All", @"Al-Wahhab"], @[@"الرزاق", @"The Sustainer", @"Ar-Razzaq"], @[@"الفتاح", @"The Opener", @"Al-Fattah"], @[@"العليم", @"The Knower of All", @"Al-`Alim"], @[@"القابض", @"The Constrictor", @"Al-Qabid"], @[@"الباسط", @"The Reliever", @"Al-Basit"], @[@"الخافض", @"The Abaser", @"Al-Khafid"], @[@"الرافع", @"The Exalter", @"Ar-Rafi"], @[@"المعز", @"The Bestower of Honors", @"Al-Mu'izz"], @[@"المذل", @"The Humiliator", @"Al-Mudhill"], @[@"السميع", @"The Hearer of All", @"As-Sami"], @[@"البصير", @"The Seer of All", @"Al-Basir"], @[@"الحكم", @"The Judge", @"Al-Hakam"], @[@"العدل", @"The Just", @"Al-`Adl"], @[@"اللطيف", @"The Subtle One", @"Al-Latif"], @[@"الخبير", @"The All-Aware", @"Al-Khabir"], @[@"الحليم", @"The Forbearing", @"Al-Halim"], @[@"العظيم", @"The Magnificent", @"Al-Azim"], @[@"الغفور", @"The Forgiver and Hider of Faults", @"Al-Ghafur"], @[@"الشكور", @"The Rewarder of Thankfulness", @"Ash-Shakur"], @[@"العلي", @"The Highest", @"Al-Ali"], @[@"الكبير", @"The Greatest", @"Al-Kabir"], @[@"الحفيظ", @"The Preserver", @"Al-Hafiz"], @[@"المقيت", @"The Nourisher", @"Al-Muqit"], @[@"الحسيب", @"The Accounter", @"Al-Hasib"], @[@"الجليل", @"The Mighty", @"Al-Jalil"], @[@"الكريم", @"The Generous", @"Al-Karim"], @[@"الرقيب", @"The Watchful One", @"Ar-Raqib"], @[@"المجيب", @"The Responder to Prayer", @"Al-Mujib"], @[@"الواسع", @"The All-Comprehending", @"Al-Wasi"], @[@"الحكيم", @"The Perfectly Wise", @"Al-Hakim"], @[@"الودود", @"The Loving One", @"Al-Wadud"], @[@"المجيد", @"The Majestic One", @"Al-Majid"], @[@"الباعث", @"The Resurrector", @"Al-Ba'ith"], @[@"الشهيد", @"The Witness", @"Ash-Shahid"], @[@"الحق", @"The Truth", @"Al-Haqq"], @[@"الوكيل", @"The Trustee", @"Al-Wakil"], @[@"القوى", @"The Possessor of All Strength", @"Al-Qawiyy"], @[@"المتين", @"The Forceful One", @"Al-Matin"], @[@"الولي", @"The Governor", @"Al-Waliyy"], @[@"الحميد", @"The Praised One", @"Al-Hamid"], @[@"المحصى", @"The Appraiser", @"The Appraiser"], @[@"المبدئ", @"The Originator", @"Al-Mubdi'"], @[@"المعيد", @"The Restorer", @"Al-Mu'id"], @[@"المحيي", @"The Giver of Life", @"Al-Muhyi"], @[@"المميت", @"The Taker of Life", @"Al-Mumit"], @[@"الحي", @"The Ever Living One", @"Al-Hayy"], @[@"القيوم", @"The Self-Existing One", @"Al-Qayyum"], @[@"الواجد", @"The Finder", @"Al-Wajid"], @[@"الماجد", @"The Glorious", @"Al-Majid"], @[@"الواحد", @"The Indivisible", @"Al-Wahid"], @[@"الصمد", @"The Satisfier of All Needs", @"As-Samad"], @[@"القادر", @"The All Powerful", @"Al-Qadir"], @[@"المقتدر", @"The Creator of All Power", @"Al-Muqtadir"], @[@"المقدم", @"The Expediter", @"Al-Muqaddim"], @[@"المؤخر", @"The Delayer", @"Al-Mu'akhkhir"], @[@"الأول", @"The First", @"Al-Awwal"], @[@"الآخر", @"The Last", @"Al-Akhir"], @[@"الظاهر", @"The Manifest One", @"Az-Zahir"], @[@"الباطن", @"The Hidden One", @"Al-Batin"], @[@"الوالي", @"The Protecting Friend", @"Al-Wali"], @[@"المتعال", @"The Supreme One", @"Al-Muta'ali"], @[@"البر", @"The Doer of Good", @"Al-Barr"], @[@"التواب", @"The Guide to Repentance", @"At-Tawwab"], @[@"المنتقم", @"The Avenger", @"Al-Muntaqim"], @[@"العفو", @"The Forgiver", @"Al-'Afuww"], @[@"الرؤوف", @"The Clement", @"Ar-Ra'uf"], @[@"مالك الملك", @"The Owner of All", @"Malik-al-Mulk"], @[@"ذو الجلال و الإكرام	", @"The Lord of Majesty and Bounty", @"Dhu-al-Jalal wa-al-Ikram"], @[@"المقسط", @"The Equitable One", @"Al-Muqsit"], @[@"الجامع", @"The Gatherer", @"Al-Jami'"], @[@"الغني", @"The Rich One", @"Al-Ghani"], @[@"المغني", @"The Enricher", @"Al-Mughni"], @[@"المانع", @"The Preventer of Harm", @"Al-Mani'"], @[@"الضار", @"The Creator of The Harmful", @"Ad-Darr"], @[@"النافع", @"The Creator of Good", @"An-Nafi'"], @[@"النور", @"The Light", @"An-Nur"], @[@"الهادي", @"The Guide", @"Al-Hadi"], @[@"البديع	", @"The Originator", @"Al-Badi"], @[@"الباقي", @"The Everlasting One", @"Al-Baqi"], @[@"الوارث", @"The Inheritor of All", @"Al-Warith"], @[@"الرشيد", @"The Righteous Teacher", @"Ar-Rashid"], @[@"الصبور", @"The Patient One", @"As-Sabur"]];
}


-(void)popview
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
