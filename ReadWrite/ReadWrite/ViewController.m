//
//  ViewController.m
//  ReadWrite
//
//  Created by Andrey on 20/02/2021.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingString:@"/array.txt"];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2", nil];
    [dictionary writeToFile:path atomically:YES];
    
    NSDictionary *dictionaryRead = [ NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"%@", dictionaryRead);
    

}


@end
