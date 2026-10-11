# R-Auth (R智能统一通行证)

> 线上访问域名：`https://auth.1234r.com` / `https://auth.1118.si`
> 基础设施：日本东京生产机 (`64.83.34.204`)
> 数据库：PostgreSQL (`casdoor` 专有库)

## 项目简介
`R-Auth` 是基于 Casdoor 4.18+ 进行源码级定制、深度白标化与自主维护的统一身份认证服务（Identity and Access Management / SSO）。为 R智能全家桶（`1234r.com`、`1118.si`、`bbs.1234r.com`、`fresh.1234r.com` 等）提供免密验证码登录、OAuth2/OIDC 认证协议及用户权限中枢支持。

## 核心特性与自研改动
1. **纯验证码化（去通行证/去第三方）**：
   - 彻底关闭外部社交平台登录入口，隐藏密码输入框与忘记密码入口；
   - 前端强制仅保留「手机验证码」与「邮箱验证码」Tab，实现极简免密秒登。
2. **源码级 100% 深度品牌白标**：
   - **拔除官方页脚**：在前端构建层物理改写 `AuthLayout` 与 `wj()` 函数为 `null`，DOM 树不生成任何 `#footer` 节点；
   - **自适应深浅色透明 Logo**：全面支持自适应 SVG/RGBA 透明通道 Logo，消除暗色模式白色底板；
   - **外链清零**：PWA manifest 清单本地化自托管，阻断 `cdn.casbin.org` 外部调用；
   - **中立化邮件模板**：标题与正文动态绑定各业务品牌抬头（如 `1118 · 智能服务 验证码`），彻底拔除历史“R通行证”字样。
3. **高可用发信通道**：
   - 邮件发信强制走 `smtp.gmail.com:465` (SMTPS/SSL)，绕开机房出站 587 端口阻断；
   - 阿里云号码认证短信 (PNVS) 实时对接。

## 目录结构
```
r-auth/
├── conf/
│   └── app.conf              # 服务核心配置 (已全面品牌化为 r-auth)
├── www/                      # 自定义品牌矢量素材 (1118-mark.svg, rzn-logo.png 等)
├── scripts/
│   └── apply_branding.sh    # 自动化白标与源码补丁注入脚本
├── docker-compose.yml        # 生产部署 Compose 编排
├── MAINTENANCE.md            # 运维与变更档案
└── README.md
```

## 维护与升级
若后续升级基础镜像版本，运行以下命令即可一键完成全量白标注入：
```bash
./scripts/apply_branding.sh casdoor
```
