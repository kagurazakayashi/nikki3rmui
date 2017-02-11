//
//  ViewController.swift
//  nikkiup2u3image
//
//  Created by 神楽坂雅詩 on 2017/2/11.
//  Copyright © 2017年 KagurazakaYashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SHViewControllerDelegate {
    
    var 截图图片:UIImage? = nil
    var 拍照图片:UIImage? = nil
    var 图片类型:Bool = true
    var 图片:UIImageView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        创建UI()
    }
    
    func 创建UI() {
        图片 = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(图片!)
        let gradientColors = [UIColor(red: 0.83921569, green: 0.82745098, blue: 0.90588235, alpha: 1.0), UIColor.white]
        self.view.backgroundColor = UIColor(patternImage: UIImage(gradientColors: gradientColors, size: self.view.frame.size)!)
        let 按钮名称:[String] = ["帮助说明","选择截图","选择拍照","交换位置","添加效果","输出图像","放弃退出"]
        let 按钮尺寸:CGSize = CGSize(width: 80, height: 25)
        for i in 0...6 {
            let 按钮:NNButton = NNButton(type: UIButtonType.custom)
            let y:CGFloat = 20.0 + (按钮尺寸.height + 5.0) * CGFloat(i)
            按钮.frame = CGRect(x: 5.0, y: y, width: 按钮尺寸.width, height: 按钮尺寸.height)
            按钮.创建UI(按钮名称: 按钮名称[i])
            按钮.addTarget(self, action: #selector(按钮按下(按钮:)), for: UIControlEvents.touchUpInside)
            按钮.tag = 100 + i
            self.view.addSubview(按钮)
        }
    }
    
    func 按钮按下(按钮:UIButton) {
        if 按钮.tag == 100 {
            //帮助说明
            UIApplication.shared.open(URL(string: "https://github.com/cxchope/nikki3rmui")!, options: [:], completionHandler: { (ok:Bool) in
                
            })
        } else if 按钮.tag == 101 {
            //选择截图
            图片类型 = true
            打开相册()
        } else if 按钮.tag == 102 {
            //选择拍照
            图片类型 = false
            打开相册()
        } else if 按钮.tag == 103 {
            //交换位置
            if (截图图片 != nil && 拍照图片 != nil) {
                let temp:UIImage = 截图图片!
                截图图片 = 拍照图片!
                拍照图片 = temp
                执行合并()
            }
        } else if 按钮.tag == 104 {
            //添加效果
            效果()
        } else if 按钮.tag == 105 {
            //输出图像
            分享()
        } else if 按钮.tag == 106 {
            //放弃退出
            exit(0)
        }
    }
    func 效果() {
        if (图片 != nil && 图片!.image != nil) {
            执行合并()
            let shv:SHViewController = SHViewController(image: 图片!.image!)
            shv.delegate = self
            self.present(shv, animated:true, completion: nil)
        }
    }
    func 分享() {
        if (图片 != nil && 图片!.image != nil) {
            let 要分享的内容 = [图片!.image]
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: 要分享的内容, applicationActivities: nil)
            self.present(activityViewController, animated:true, completion: nil)
        }
    }
    
    func shViewControllerImageDidFilter(image: UIImage) {
        图片!.image = image
    }
    func shViewControllerDidCancel() {
        
    }
    
    func 打开相册() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let 相册 = UIImagePickerController()
            相册.delegate = self
            相册.sourceType = UIImagePickerControllerSourceType.photoLibrary
            相册.allowsEditing = false
            self.present(相册, animated: true, completion: {
                () -> Void in
            })
        } else {
            //TODO: 无法访问相册提示
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if 图片类型 == true {
                self.截图图片 = image
                let 按钮:UIButton = self.view.viewWithTag(101) as! UIButton
                按钮.setTitle("已选截图", for: UIControlState.normal)
            } else {
                self.拍照图片 = image
                let 按钮:UIButton = self.view.viewWithTag(102) as! UIButton
                按钮.setTitle("已选拍照", for: UIControlState.normal)
            }
            执行合并()
        } else{
            //TODO: 发生错误提示
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func 执行合并() {
        if (截图图片 != nil && 拍照图片 != nil) {
            图片?.image = 开始合并(百分比: 0.5)
        } else if (截图图片 != nil) {
            图片?.image = 截图图片
        } else if (拍照图片 != nil) {
            图片?.image = 拍照图片
        }
    }
    
    func 开始合并(百分比:CGFloat) -> UIImage {
        let 修改后拍照图片:UIImage = 拍照图片!.crop(bounds: CGRect(x: 0, y: 0, width: 拍照图片!.size.width, height: 拍照图片!.size.height * 百分比))!
        let 修改后截图图片:UIImage = 截图图片!.crop(bounds: CGRect(x: 0, y: 截图图片!.size.height * 百分比, width: 截图图片!.size.width, height: 截图图片!.size.height * 百分比))!
        //CGSize size = CGSizeMake(image1.size.width + image2.size.width, image1.size.height);
        let 完整尺寸:CGSize = CGSize(width: 修改后截图图片.size.width, height: 修改后截图图片.size.height + 修改后拍照图片.size.height)
        UIGraphicsBeginImageContext(完整尺寸)
        修改后拍照图片.draw(in: CGRect(x: 0, y: 0, width: 修改后拍照图片.size.width, height: 修改后拍照图片.size.height))
        修改后截图图片.draw(in: CGRect(x: 0, y: 修改后拍照图片.size.height, width: 修改后截图图片.size.width, height: 修改后截图图片.size.height))
        let 合并后图片:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return 合并后图片
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

