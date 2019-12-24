//
//  AnalyzeLibView.m
//  WBBlades
//
//  Created by phs on 2019/12/20.
//  Copyright © 2019 邓竹立. All rights reserved.
//

#import "AnalyzeLibView.h"

@interface AnalyzeLibView()

@property (nonatomic,weak) NSTextView *objFilesView;
@property (nonatomic,weak) NSTextView *outputView;
@property (nonatomic,weak) NSScrollView *scrollView;
@property (nonatomic,weak) NSTextView *consoleView;

@property (nonatomic,weak) NSButton *stopBtn;
@property (nonatomic,weak) NSButton *inFinderBtn;

@property (nonatomic,strong)NSTask *bladesTask;

@end

@implementation AnalyzeLibView

- (instancetype)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
         [self prepareSubview];
    }
    return self;
}

-(NSTask *)bladesTask{
    if (!_bladesTask) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WBBlades" ofType:@""];
        _bladesTask = [[NSTask alloc] init];
        [_bladesTask setLaunchPath:path];
    }
    return _bladesTask;
}

- (void)prepareSubview{
    NSTextField *pathLabel = [[NSTextField alloc]initWithFrame:NSMakeRect(25.0, 428.0, 66, 36.0)];
    [self addSubview:pathLabel];
    pathLabel.font = [NSFont systemFontOfSize:14.0];
    pathLabel.stringValue = @"目标路径";
    pathLabel.textColor = [NSColor blackColor];
    pathLabel.editable = NO;
    pathLabel.bezelStyle = NSBezelStyleTexturedSquare;
    pathLabel.bordered = NO;
    pathLabel.backgroundColor = [NSColor clearColor];
    
    NSScrollView *textScroll = [[NSScrollView alloc]initWithFrame:NSMakeRect(109.0, 440.0, 559.0, 30.0)];
    [self addSubview:textScroll];
    [textScroll setBorderType:NSLineBorder];
    textScroll.wantsLayer = YES;
    textScroll.layer.backgroundColor = [NSColor whiteColor].CGColor;
    textScroll.layer.borderWidth = 1.0;
    textScroll.layer.cornerRadius = 2.0;
    textScroll.layer.borderColor = [NSColor lightGrayColor].CGColor;
    
    NSTextView *textView = [[NSTextView alloc]initWithFrame:NSMakeRect(0.0, 0.0, 559.0, 30.0)];
    textView.font = [NSFont systemFontOfSize:14.0];
    textView.textColor = [NSColor blackColor];
    textScroll.documentView = textView;
    _objFilesView = textView;
    
    NSTextField *pathTipLabel = [[NSTextField alloc]initWithFrame:NSMakeRect(109.0, 415.0, 559.0, 20.0)];
    [self addSubview:pathTipLabel];
    pathTipLabel.font = [NSFont systemFontOfSize:12.0];
    pathTipLabel.stringValue = @"选择或输入一个或多个目标文件夹，在输入时两个路径间以空格隔开";
    pathTipLabel.textColor = [NSColor grayColor];
    pathTipLabel.editable = NO;
    pathTipLabel.bezelStyle = NSBezelStyleTexturedSquare;
    pathTipLabel.bordered = NO;
    pathTipLabel.backgroundColor = [NSColor clearColor];
    
    NSButton *pathBtn = [[NSButton alloc]initWithFrame:NSMakeRect(693.0, 436.0, 105.0, 36.0)];
    [self addSubview:pathBtn];
    pathBtn.title = @"选择文件夹";
    pathBtn.font = [NSFont systemFontOfSize:14.0];
    pathBtn.target = self;
    pathBtn.action = @selector(pathBtnClicked:);
    pathBtn.bordered = YES;
    pathBtn.bezelStyle = NSBezelStyleRegularSquare;
    
    NSTextField *outputLabel = [[NSTextField alloc]initWithFrame:NSMakeRect(25.0, 374.0, 66, 36.0)];
    [self addSubview:outputLabel];
    outputLabel.font = [NSFont systemFontOfSize:14.0];
    outputLabel.stringValue = @"输出路径";
    outputLabel.textColor = [NSColor blackColor];
    outputLabel.editable = NO;
    outputLabel.bordered = NO;
    outputLabel.backgroundColor = [NSColor clearColor];
    
    NSTextView *outputView = [[NSTextView alloc]initWithFrame:NSMakeRect(109.0, 385.0, 559.0, 30.0)];
    [self addSubview:outputView];
    outputView.font = [NSFont systemFontOfSize:14.0];
    outputView.textColor = [NSColor blackColor];
    outputView.wantsLayer = YES;
    outputView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    outputView.layer.borderWidth = 1.0;
    outputView.layer.cornerRadius = 2.0;
    outputView.layer.borderColor = [NSColor lightGrayColor].CGColor;
    outputView.editable = NO;
    outputView.horizontallyResizable = NO;
    outputView.verticallyResizable = NO;
    _outputView = outputView;
    
    NSTextField *outputTipLabel = [[NSTextField alloc]initWithFrame:NSMakeRect(109.0, 360.0, 559.0, 20.0)];
    [self addSubview:outputTipLabel];
    outputTipLabel.font = [NSFont systemFontOfSize:12.0];
    outputTipLabel.stringValue = @"选择一个结果输出文件夹，结果将保存为plist格式";
    outputTipLabel.textColor = [NSColor grayColor];
    outputTipLabel.editable = NO;
    outputTipLabel.bezelStyle = NSBezelStyleTexturedSquare;
    outputTipLabel.bordered = NO;
    outputTipLabel.backgroundColor = [NSColor clearColor];
    
    NSButton *outputBtn = [[NSButton alloc]initWithFrame:NSMakeRect(693.0, 382.0, 105.0, 36.0)];
    [self addSubview:outputBtn];
    outputBtn.title = @"选择文件夹";
    outputBtn.font = [NSFont systemFontOfSize:14.0];
    outputBtn.target = self;
    outputBtn.action = @selector(outputBtnClicked:);
    outputBtn.bordered = YES;
    outputBtn.bezelStyle = NSBezelStyleRegularSquare;
    
    NSTextField *progressLabel = [[NSTextField alloc]initWithFrame:NSMakeRect(25.0, 320.0, 66, 36.0)];
    [self addSubview:progressLabel];
    progressLabel.font = [NSFont systemFontOfSize:14.0];
    progressLabel.stringValue = @"进度：";
    progressLabel.textColor = [NSColor blackColor];
    progressLabel.editable = NO;
    progressLabel.bordered = NO;
    progressLabel.backgroundColor = [NSColor clearColor];
    
    NSScrollView *scrollView = [[NSScrollView alloc]initWithFrame:NSMakeRect(30.0, 20.0, 638.0, 300.0)];
    [self addSubview:scrollView];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setBorderType:NSLineBorder];
    scrollView.wantsLayer = YES;
    scrollView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    scrollView.layer.borderWidth = 1.0;
    scrollView.layer.cornerRadius = 2.0;
    scrollView.layer.borderColor = [NSColor lightGrayColor].CGColor;
    _scrollView = scrollView;
    
    NSTextView *consoleView = [[NSTextView alloc]initWithFrame:NSMakeRect(0.0, 0.0, 638.0, 300.0)];
    scrollView.documentView = consoleView;
    consoleView.font = [NSFont systemFontOfSize:14.0];
    consoleView.textColor = [NSColor blackColor];
    consoleView.editable = NO;
    _consoleView = consoleView;
    
    NSButton *startBtn = [[NSButton alloc]initWithFrame:NSMakeRect(693.0, 285.0, 105.0, 36.0)];
    [self addSubview:startBtn];
    startBtn.title = @"开始分析";
    startBtn.font = [NSFont systemFontOfSize:14.0];
    startBtn.target = self;
    startBtn.action = @selector(startBtnClicked:);
    startBtn.bordered = YES;
    startBtn.bezelStyle = NSBezelStyleRegularSquare;

    NSButton *stopBtn = [[NSButton alloc]initWithFrame:NSMakeRect(693.0, 222.0, 105.0, 36.0)];
    [self addSubview:stopBtn];
    stopBtn.title = @"暂停分析";
    stopBtn.font = [NSFont systemFontOfSize:14.0];
    stopBtn.target = self;
    stopBtn.action = @selector(stopBtnClicked:);
    stopBtn.bordered = YES;
    stopBtn.bezelStyle = NSBezelStyleRegularSquare;
    stopBtn.enabled = NO;
    _stopBtn = stopBtn;
    
    NSButton *inFinderBtn = [[NSButton alloc]initWithFrame:NSMakeRect(693.0, 159.0, 105.0, 36.0)];
    [self addSubview:inFinderBtn];
    inFinderBtn.title = @"打开文件夹";
    inFinderBtn.font = [NSFont systemFontOfSize:14.0];
    inFinderBtn.target = self;
    inFinderBtn.action = @selector(inFinderBtnClicked:);
    inFinderBtn.bordered = YES;
    inFinderBtn.bezelStyle = NSBezelStyleRegularSquare;
    inFinderBtn.enabled = NO;
    _inFinderBtn = inFinderBtn;
}

- (void)pathBtnClicked:(id)sender{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt: @"打开"];
    openPanel.allowedFileTypes = nil;
    openPanel.allowsMultipleSelection = YES;
    openPanel.canChooseDirectories = YES;
    openPanel.directoryURL = nil;
    
    __weak __typeof(self)weakSelf = self;
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        
        if (returnCode == 1 && [openPanel URLs]) {
            NSMutableString *fileFolders = [NSMutableString stringWithString:@""];
            NSArray *array = [openPanel URLs];
            for (NSInteger idx = 0; idx<array.count; idx++) {
                NSURL *url = array[idx];
                NSString *urlString = [url.absoluteString substringFromIndex:7];//去掉file://
                NSString *string = @" ";
                if (idx == array.count - 1) {
                    string = @"";
                }
                [fileFolders appendFormat:@"%@%@",urlString,string];
            }
            weakSelf.objFilesView.string = [fileFolders copy];
        }
    }];
}

- (void)outputBtnClicked:(id)sender{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt: @"选择文件夹"];
    openPanel.allowsMultipleSelection = NO;
    openPanel.canChooseFiles = NO;
    openPanel.canChooseDirectories = YES;
    openPanel.directoryURL = nil;
    
    __weak __typeof(self)weakSelf = self;
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == 1 && [openPanel URLs]) {
            NSURL *url = [[openPanel URLs] firstObject];
            NSString *urlString = [url.absoluteString substringFromIndex:7];//去掉file://
            NSString *outputPath = [NSString stringWithFormat:@"%@result.plist",urlString];
            weakSelf.outputView.string = outputPath;
        }
    }];
}

- (void)startBtnClicked:(id)sender{
    if (self.objFilesView.string.length == 0 || self.outputView.string.length == 0) {
        NSAlert *alert = [[NSAlert alloc]init];
        [alert addButtonWithTitle:@"好的"];
        [alert setMessageText:@"目标路径以及输出路径不能为空！"];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        }];
        return;
    }
    
    _stopBtn.enabled = YES;
    NSArray *array = [self.objFilesView.string componentsSeparatedByString:@" "];
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSInteger idx = 0; idx<array.count; idx++) {
            __block NSString *string = @"";
            dispatch_async(dispatch_get_main_queue(), ^{
                string = [NSString stringWithFormat:@"%@\n正在遍历 %@",weakSelf.consoleView.string,array[idx]];
                if (idx == array.count - 1) {
                    string = [NSString stringWithFormat:@"%@\n遍历完毕，可以点击打开文件夹查看结果数据。\n",string];
                }
                weakSelf.consoleView.string = string;
                [weakSelf.scrollView.contentView scrollToPoint:NSMakePoint(0, weakSelf.scrollView.documentView.bounds.size.height)];
            });
            
//            [weakSelf.bladesTask setArguments:[NSArray arrayWithObjects:@"1", array[idx], nil]];
//            [weakSelf.bladesTask launch];
//            [weakSelf.bladesTask waitUntilExit];//同步执行
            
            
        }
    });
    
    
}

- (void)stopBtnClicked:(id)sender{
    NSLog(@"stop");
    
}

- (void)inFinderBtnClicked:(id)sender{
    NSLog(@"finder");
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end