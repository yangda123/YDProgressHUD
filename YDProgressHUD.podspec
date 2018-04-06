Pod::Spec.new do |s|

s.name = "YDProgressHUD"

s.version = "0.0.1"

s.summary = "弹窗"

s.description  = "加载进度框／提示框"

s.homepage = "https://github.com/yangda123/YDProgressHUD"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "yangda" => "18205598086@163.com" }

s.platform = :ios, "8.0"

s.source = { :git => "https://github.com/yangda123/YDProgressHUD.git", :tag => "0.0.1" }

s.source_files = "YDProgressHUD/*.{h,m}"

s.framework = "UIKit"

s.requires_arc = true

end
