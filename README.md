# ZZLarkifyView



### 一、主类：

- **ZZLarkifyView（类似于 UITableView）**
- **ZZElementView（类似于 UITableViewCell）**
- **ZZElementModel（类似于 cellModel）**

### 二、如何使用
#### 1、初始化

```
ZZLarkifyView *larkifyView = [[ZZLarkifyView alloc] initWithFrame:self.bounds];
larkifyView.dataSource = self;
larkifyView.delegate = self;
[self addSubview:larkifyView];
```
#### 2、实现DataSource和Delegate

- ZZLarkifyViewDataSource

```
@protocol ZZLarkifyViewDataSource <NSObject>
@required
//显示比
- (CGFloat)ratioForElementInLarkifyView:(ZZLarkifyView *)larkifyView;
//元素个数
- (NSUInteger)numberOfElementsInLarkifyView:(ZZLarkifyView *)larkifyView;
//元素配置
- (ZZElementModel *)larkifyView:(ZZLarkifyView *)larkifyView modelForElementAtIndex:(NSUInteger)index;
//元素显示
- (id)larkifyView:(ZZLarkifyView *)larkifyView valueForElementAtIndex:(NSUInteger)index;

@end
```
- ZZLarkifyViewDelegate

```
@protocol ZZLarkifyViewDelegate <NSObject>
@required
//点击larkifyView
- (void)didClickLarkifyView:(ZZLarkifyView *)larkifyView;

@optional
//元素需要响应点击
- (BOOL)larkifyView:(ZZLarkifyView *)larkifyView canClickElementAtIndex:(NSUInteger)index;
//元素点击
- (void)larkifyView:(ZZLarkifyView *)larkifyView didClickElementAtIndex:(NSUInteger)index;

@end
```

#### 3、刷新、绘制界面

```
//刷新LarkifyView（包含多个ElementView，必须实现，否则不显示）
- (void)reloadData;
//刷新单个ElementView（存在同类型时会有多个）
- (void)reloadElement:(NSString *)mainType subType:(NSString *)subType;
```

### 三、如何新增元素类型

- 新增ZZElementType枚举
- 请在ZZElementClassInfo实现元素Class和ZZElementType

### 四、关于元素复用

在ZZLarkifyPool中，利用_realDict和_tempDict进行存取操作，实现元素复用。
