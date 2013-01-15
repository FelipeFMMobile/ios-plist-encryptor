//
//  ViewController.m
//  encryptPlist
//
//  Created by Felipe Work on 11/01/13.
//  Copyright (c) 2013 Felipe Menezes. 
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// HOW TO DECRYPT
// Copy the new encrypted plist file inside your project
// Copy FMMobilePLiistEncryptor Folder inside your project
// Inside your ViewController, Import FMPListEn.h
// Use this commands below do Decript.
//
//NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"YOUR_PLIST_FILE_NAME" ofType:@"plist"];
//NSArray * contentArray = [NSArray arrayWithContentsOfFile:plistPath];
//NSArray * decrypt = [FMPlistEn dencryptArray:contentArray];
//NSLog(@" RESULT DECRYPTED ARRAY %@",decrypt);

#import "ViewController.h"
#import "FMPlistEn.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)encryptPList:(id)sender {
    
    NSString * plistFile = _plistnameField.text;
    if ([plistFile length]==0) {
        NSException * ex=[NSException exceptionWithName:@"Hey, type the name of plist file inside this project! You can also copy the source from another project just using Add to project in XCode" reason:@"NO PLIST FILE" userInfo:nil];
        [ex raise];
    }
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:plistFile ofType:@"plist"];
    NSArray * contentArray = [NSArray arrayWithContentsOfFile:plistPath];
    if (contentArray==nil  || [contentArray count]==0) {
        NSException * ex=[NSException exceptionWithName:@"Hey, the plist file is empty ? Why ? " reason:@"NO PLIST FILE" userInfo:nil];
        [ex raise];
    }
    NSArray * result = [FMPlistEn encryptArray:contentArray];
    NSString * plistString = [FMPlistEn buildEncryptedPlist:result];
    NSLog(@" RESULT ENCRYPTED %@",plistString);
    _resultTextView.text=plistString;
    
   
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textfield {
    [textfield resignFirstResponder];
    return YES;
}


















- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
