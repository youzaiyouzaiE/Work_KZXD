//
//  ScanBarViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/31.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "ScanBarViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanBarViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UILabel *_label;

    BOOL upOrdown;
    UIImageView *line;
    NSInteger num;
    CALayer *layer;
}

@end

@implementation ScanBarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    line.hidden = NO;
}

#define LAYER_W     200
#define LAYER_H     200
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"(none)";
    [self.view addSubview:_label];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    [_session startRunning];
    
    [self.view bringSubviewToFront:_label];
    
    layer = [CALayer layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.bounds = CGRectMake(0, 0, LAYER_W, LAYER_H);
    layer.position = self.view.center;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 1;
    layer.delegate = self;
    [self.view.layer addSublayer:layer];
    
    UILabel *textLabl = [[UILabel alloc] initWithFrame:CGRectMake(layer.frame.origin.x, layer.frame.origin.y + LAYER_H + 5, layer.frame.size.width, 80)];
    textLabl.textColor = [UIColor whiteColor];
    textLabl.backgroundColor = [UIColor clearColor];
    textLabl.text = @"将二维码放入框内，即可扫描";
    textLabl.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:textLabl];
    
    num = 2;
    line = [[UIImageView alloc] init];
    line.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y + 4, 200, 2);
    line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:line];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}

-(void)animation
{
    num ++;
    line.frame = CGRectMake(line.frame.origin.x, line.frame.origin.y + 2*num, 200, 2);
    if (line.frame.origin.y >= layer.frame.origin.y + LAYER_H - 4) {
        num = 0;
        line.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y + 4, 200, 2);
    }
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            _label.text = detectionString;
            break;
        }
        else
            _label.text = @"(none)";
    }
    
//    _highlightView.frame = highlightViewRect;
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
