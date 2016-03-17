# CellAutoLayoutDemo
[![BLOG](https://img.shields.io/badge/blog-ayjkdev.top-orange.svg?style=flat)](http://ayjkdev.top/)&nbsp;
## 前言
iOS有多种布局方式，大致分为两种，即可视化布局和代码布局。两者各有优缺点，使用全凭个人喜好。

1.采用xib或storyboard
优点：方便快捷，能很快完成UI的适配布局，开发速度快。其中storyboard能看到每个viewController的样式和其中的入栈出栈关系。
缺点：storyboard较难进行协同开发，大型项目如果管理不当，很容易出现一团麻的现象。
2.采用代码布局
优点：利于项目管理和后期维护，代码合并。能进行代码重用。（对于部分程序员来说，或许代码更为直观）
缺点：开发速度较慢，项目开发周期变长。

<!-- more -->
## 关于Masonry
代码自动布局常见的就是使用第三方布局类库，也有用frame进行硬计算的，直接进行frame计算最不推荐，Magical Number是不可避免的了，代码也显得凌乱，不易于后期维护。
在这里推荐一下[Masonry](https://github.com/SnapKit/Masonry)，他在GitHub上的star已经破万了，全世界很多开发者都在使用这个库。

## 效果图

![运行效果图](http://7xrofo.com1.z0.glb.clouddn.com/CellAutoLayoutDemo1.gif)

## 代码部分
这里主要讲几个关键的代码段。
### 1.cell布局
```objc
- (void)configSubViews {
    
    _backgroundImageView = ({
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor yellowColor];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-50);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
        imageView;
    });
    
    UITapGestureRecognizer *backGroundImageViewTap = ({
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_backgroundImageView addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer;
    });
    
    _titleLabel = ({
        UILabel *label = [UILabel new];
        [_backgroundImageView addSubview:label];
        label.numberOfLines = 2;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(16);
            make.right.equalTo(_backgroundImageView.mas_right).offset(-16);
            make.top.equalTo(_backgroundImageView.mas_top).offset(16);
        }];
        label;
    });
    
    _picImageView = ({
        UIImageView *imageView = [UIImageView new];
        [_backgroundImageView addSubview:imageView];
        imageView.backgroundColor = [UIColor redColor];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(16);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        imageView;
    });
    
    _contentLabel = ({
        UILabel *label = [UILabel new];
        [_backgroundImageView addSubview:label];
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = kScreenWidth - 100 - 16 * 2 - 70 - 8;
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:14.5];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(8 + 16 + 70);
            make.right.equalTo(_backgroundImageView.mas_right).offset(-16);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.bottom.equalTo(_picImageView.mas_bottom);
        }];
        label;
    });
}
```
> 1.方法`configSubViews`的代码，也是整个cell采用Masonry自动布局的核心代码

### 2.获取cell高度
```objectivec
+ (CGFloat)getHeightWidthModel:(UserModel *)model{
    
    AYTableViewCell *cell = [[AYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell configCellWithModel:model];
    [cell layoutIfNeeded];
    CGRect frame = cell.contentLabel.frame;
    CGFloat cellHeight = frame.origin.y + frame.size.height + 8 + 24;
    return cellHeight;
}
```
> 1.方法`getHeightWidthModel:`的代码，通过model来获取cell高度。

### 3.通过model把数据传给cell
```objectivec
- (void)configCellWithModel:(UserModel *)model {
    
    self.model = model;
    _titleLabel.text = model.title;
    _picImageView.image = [UIImage imageNamed:model.picture];
    _contentLabel.text = model.content;
    
    if (model.isClick) {
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(8 + 16 + 70);
            make.right.equalTo(_backgroundImageView.mas_right).offset(-16);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        }];
    } else {
        [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backgroundImageView.mas_left).offset(8 + 16 + 70);
            make.right.equalTo(_backgroundImageView.mas_right).offset(-16);
//            make.width.mas_equalTo(164);
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.bottom.equalTo(_picImageView.mas_bottom);
        }];
    }
}
```
> 1.当点击的时候也会调用该方法重新约束`_contentLabel`。

## 讲解
1.`configSubViews`方法中只是基本的Masonry使用，主要有清晰的布局思路就可以完成。
有一点需要注意的是`preferredMaxLayoutWidth`这个属性，Apple官方文档里面是这样写的：

![preferredMaxLayoutWidth](http://7xrofo.com1.z0.glb.clouddn.com/DCDE7F63-B506-4D7A-AB5D-48CA091AFE1E.png)

这个属性是表示label最大可布局的宽度，如果这个值设置不好，那么高度计算就算出错。高度依赖于宽度，宽度依赖于`preferredMaxLayoutWidth`这个属性。（刚开始我也没注意，导致出现高度计算出现很大的差错，后来查了相关资料才了解到。）

2.`getHeightWidthModel:`方法是一个类方法，不能通过`[self configCellWithModel:model]`去掉用，所以这里通过重新创建一个cell对象，让cell配置model并调用计算出对应的高度，效果等同。
需要注意获取frame的之前需要调用一次`layoutIfNeeded`更新布局，而且是要先配置model之后再调用`layoutIfNeeded`，才能获取正确的frame，否则获取到的就是CGRectZero了。

3.`configCellWithModel:`方法中判断是否点击然后通过`mas_remakeConstraints:`重新对_contentLabel进行了约束，更新布局。
