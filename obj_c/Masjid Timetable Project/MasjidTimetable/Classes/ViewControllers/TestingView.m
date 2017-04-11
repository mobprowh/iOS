//
//  TestingView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "TestingView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface TestingView ()
{
    NSArray *masjidNames,*localArea,*largerArea,*countryValue;
    NSMutableArray *jsonDict;
    NSString *titleValue;
    NSMutableDictionary *objects,*largerObject,*CountryObject;
    NSMutableArray *getlocations,*MasjidLargerArea,*MasjidCountry;
    NSMutableArray *addCapitalData;
}

@property (nonatomic, retain) NSArray *states;
@property (nonatomic, retain) NSMutableArray *arrayOfCharacters;
@property (nonatomic, retain) NSMutableDictionary *objectsForCharacters;

@end

@implementation TestingView

- (void)viewDidLoad
{
    [super viewDidLoad];
    jsonDict=[[NSMutableArray alloc]init];
    addCapitalData=[[NSMutableArray alloc]init];
    MasjidLargerArea=[[NSMutableArray alloc]init];
    MasjidCountry=[[NSMutableArray alloc]init];
    
    [self retrievePost];
}

-(void)retrievePost
{
    [SVProgressHUD show];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/masjids.php" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            jsonDict = (NSMutableArray *) responseObjct;
                                                                                            [SVProgressHUD dismiss];
                                                                                            masjidNames=[jsonDict valueForKey:@"masjid_name"];
                                                                                            localArea=[jsonDict valueForKey:@"masjid_local_area"];
                                                                                            largerArea=[jsonDict valueForKey:@"masjid_larger_area"];
                                                                                            countryValue=[jsonDict valueForKey:@"masjid_country"];
                                                                                            masjidNames = [masjidNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                                                                                            for (NSString *item in masjidNames) {
                                                                                                NSString *newString = [item stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[item substringToIndex:1] capitalizedString]];
                                                                                                [addCapitalData addObject:newString];
                                                                                            }
                                                                                            [self setupIndexData];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arrayOfCharacters count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_objectsForCharacters objectForKey:[_arrayOfCharacters objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    NSArray *toBeReturned = [NSArray arrayWithArray:
                             [@"A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z"
                              componentsSeparatedByString:@"|"]];
    return toBeReturned;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    
    for (NSString *character in _arrayOfCharacters) {
        if ([character isEqualToString:title]) {
            return count;
        }
        
        count ++;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[_objectsForCharacters objectForKey:[_arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[[objects objectForKey:[_arrayOfCharacters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    return cell;
}

- (void)setupIndexData
{
    self.arrayOfCharacters    = [[NSMutableArray alloc] init];
    self.objectsForCharacters = [[NSMutableDictionary alloc] init];
    objects=[[NSMutableDictionary alloc]init];
    largerObject=[[NSMutableDictionary alloc]init];
    CountryObject=[[NSMutableDictionary alloc]init];
    getlocations=[[NSMutableArray alloc]init];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSMutableArray *arrayOfNames = [[NSMutableArray alloc] init];
    NSString *numbericSection    = @"#";
    NSString *firstLetter;
    
    for (int i=0;i<[addCapitalData count];i++) {
        NSString *m,*MasjidlargerArea,*country;
        firstLetter = [[addCapitalData[i] description] substringToIndex:1];
        if([[jsonDict valueForKey:@"masjid_name"] containsObject:masjidNames[i]])
        {
            NSInteger index= [[jsonDict valueForKey:@"masjid_name"]indexOfObject:masjidNames[i]];
            m=[[jsonDict valueForKey:@"masjid_local_area"]objectAtIndex:index];
            MasjidlargerArea=[[jsonDict valueForKey:@"masjid_larger_area"]objectAtIndex:index];
            country=[[jsonDict valueForKey:@"masjid_country"]objectAtIndex:index];
        }
        if ([formatter numberFromString:firstLetter] == nil) {
            if (![_objectsForCharacters objectForKey:firstLetter]) {
                [getlocations removeAllObjects];
                [arrayOfNames removeAllObjects];
                [MasjidCountry removeAllObjects];
                [MasjidLargerArea removeAllObjects];
                [_arrayOfCharacters addObject:firstLetter];
            }
            [getlocations addObject:[m description]];
            [MasjidLargerArea addObject:[MasjidlargerArea description]];
            [MasjidCountry addObject:[country description]];
            [arrayOfNames addObject:[addCapitalData[i] description]];
            [CountryObject setObject:[MasjidCountry copy] forKey:firstLetter];
            [largerObject setObject:[MasjidLargerArea copy] forKey:firstLetter];
            [objects setObject:[getlocations copy] forKey:firstLetter];
            [_objectsForCharacters setObject:[arrayOfNames copy] forKey:firstLetter];
        }
        else {
            if (![_objectsForCharacters objectForKey:numbericSection]) {
                [arrayOfNames removeAllObjects];
                [_arrayOfCharacters addObject:numbericSection];
            }
            [arrayOfNames addObject:[addCapitalData[i] description]];
            [_objectsForCharacters setObject:[arrayOfNames copy]  forKey:numbericSection];
        }
    }
    [self.tableView reloadData];
}

@end
