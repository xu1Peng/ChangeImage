//
//  ViewController.m
//  ChangeImage
//
//  Created by Jerry on 2018/3/19.
//  Copyright © 2018年 xuPeng. All rights reserved.
//
#import "AFNetworking.h"
#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getHeadImage];
    [self setIamgeView];
}

- (void)getHeadImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];   // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    self.image = img;
}

- (void)setIamgeView{
    self.view.backgroundColor = [UIColor brownColor];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100) / 2, 100, 100, 100)];

    self.imageView.image = self.image;
    self.imageView.backgroundColor = [UIColor orangeColor];
    self.imageView.layer.cornerRadius = 50;
    self.imageView.layer.masksToBounds = YES;
    
    //添加手势，使其点击更换图像
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setHeadImage:)];
    [self.imageView addGestureRecognizer:singTap];
    [self.view addSubview:self.imageView];

}

- (void)setHeadImage:(UITapGestureRecognizer *)sender{
    
    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //从相册选择
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc] init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    //拍照
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    
    //取消
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.image = image;
    [self setIamgeView];
    //保存图片
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"pic_100.png"]];
     [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

    [self onPostData:image];
}

- (void)onPostData:(UIImage *)image{
    NSMutableDictionary * dir=[NSMutableDictionary dictionaryWithCapacity:2];
    [dir setValue:@"657959" forKey:@"yhid"];
    [dir setValue:@"5648597" forKey:@"code"];

    [dir setValue:@"1" forKey:@"packageID"];
    NSString *url= [NSString stringWithFormat:@"http://dev.tokubuy.jp//app/home/editPhoto"];

    NSString *fileName = [NSString stringWithFormat:@"pic_100.png"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7f);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传图片，以文件流的格式，这里注意：name是指服务器端的文件夹名字
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
