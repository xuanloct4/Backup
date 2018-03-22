//
//  ViewController.m
//  SimpleFFPlayer
//
//  Created by tranvanloc on 5/10/17.
//  Copyright © 2017 tsdv. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

//// define the function to add as a method
//id sayHello ( id self, SEL _cmd,... )
//{
//    NSLog (@"Hello");
//}
//
//void addMethod ()
//{
//    // create the method
//    struct objc_method myMethod;
//    myMethod.method_name = sel_registerName("sayHello");
//    myMethod.method_imp  = sayHello;
//
//    // build the method list.
//    // this memory needs to stick around as long as the
//    // methods belong to the class.
//
//    struct objc_method_list * myMethodList;
//    myMethodList = malloc (sizeof(struct objc_method_list));
//    myMethodList->method_count = 1;
//    myMethodList->method_list[0] = myMethod;
//
//    // add method to the class
//    class_addMethods ( [EmptyClass class], myMethodList );
//
//    // try it out
//    NSString * instance = [[NSString alloc] init];
//    [instance sayHello];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *obk = [RunTimeClass buildClassFromDictionary:@[@"FirstName", @"LastName", @"Age", @"Gender"] withName:@"Person"];
    
    Class newClass = [NSString newSubclassNamed:@"MyCustomString" protocols:NULL impls: PAIR_LIST {
        @selector(description1),
        BLOCK_CAST ^id (id self, NSString *t) {
            //            return @"testing";
            return [NSString stringWithFormat:@"%@",t];
        },
        NIL_PAIR
    }];
    
    NSString *someString = [newClass new];
    NSLog(@"Descroption1: %@", [someString performSelector:@selector(description1) withObject:@"testing"]);
    
    [RuntimeMethod load];
    
    InvocationForwarding *book = [[InvocationForwarding alloc] init];
    printf("%s is written by %s\n", [book.title UTF8String], [book.author UTF8String]);
    book.title = @"1984";
    book.author = @"George Orwell";
    printf("%s is written by %s\n", [book.title UTF8String], [book.author UTF8String]);
    
    
    //    GCDDisPatchGroup *dpqGroup = [[GCDDisPatchGroup alloc] init];
    //    [dpqGroup fetchConfigurationWithCompletion:nil];
    
    RuntimeIMP *im = [[RuntimeIMP alloc] init];
    [im myMethodWithParam1:-1 andParam2:1];
    
    
    //    self.containerView.frame = CGRectMake(10, 20, 700, 300);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //    [ImportFramework importFrameworkPath:@"System/Library/Frameworks/UIKit.framework/UIKit" mode:RTLD_NOW];
    [ImportFramework importFrameworkPath:@"/usr/lib/libc.dylib" mode:RTLD_NOW];
    //    [FrameworkImport importFW];
    
    //    id o1 = [BEObjectInitialization initWithArray:@[@"NSNumber",@"numberWithInt:",@"BENumber",@"numberWithNumber:",@11.11]];
    
    
    NSNumber *num1 = [NSNumber numberWithInt:1];
    
    NSNumber *o = [NSNumber numberWithInt:1];
    
    id number = [o copy];
    
    //    NSNumber *number = [NSNumber numberWithInt:1];
    
    NSNumber *num2 = [NSNumber numberWithInt:6];
    
    id obj = [RuntimeInvocation invokeObject:number selector:@"addNum1:addNum2:" argumentList:@[num1,num2]];
    
    id obj2 = [RuntimeInvocation invokeObject:obj selector:@"addNum1:addNum2:" argumentList:@[obj,num1]];
    
    NSString *str = @"12.3456";
    
    [RuntimeInvocation invokeObjectWithClass:@"NSNumber" withCharacters:str selector:@"addNum1:addNum2:" argumentList:@[obj,obj2]];
    
}

- (IBAction)changeSize:(id)sender {
    //    CGRect rect = self.containerView.frame;
    //    if((rect.size.width = 700) && (rect.size.height = 300)){
    //        self.containerView.frame = CGRectMake(10, 20, 400, 500);
    //    }else{
    //        self.containerView.frame = CGRectMake(10, 20, 700, 300);
    //    }
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
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
