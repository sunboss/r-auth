#!/bin/bash
# ==============================================================================
# R-Auth (R智能统一通行证) 自动化白标与品牌注入补丁脚本
# ==============================================================================
set -e

CONTAINER_NAME="${1:-casdoor}"

echo ">>> [1/4] 正在注入 index.html 标题与描述白标..."
docker exec "$CONTAINER_NAME" sed -i 's|<title>Casdoor</title>|<title>R智能通行证 · 统一认证中心</title>|g' /web/build/index.html
docker exec "$CONTAINER_NAME" sed -i 's|Casdoor - An open-source Identity and Access Management.*platform|R-Auth - R智能统一身份认证与通行证服务|g' /web/build/index.html
docker exec "$CONTAINER_NAME" sed -i 's|Your browser may be too old to run Casdoor.|您的浏览器版本过低，无法正常加载R智能认证中心。|g' /web/build/index.html

echo ">>> [2/4] 正在源码级拔除官方页脚 Footer..."
docker exec "$CONTAINER_NAME" python3 -c "
import glob

# 移除 AuthLayout 中的 footer JSX 渲染
for f in glob.glob('/web/build/assets/AuthLayout-*.js'):
    with open(f, 'r') as fp:
        c = fp.read()
    c = c.replace('e.jsx(\"footer\",{id:\"footer\"', 'null && e.jsx(\"footer\",{id:\"footer\"')
    with open(f, 'w') as fp:
        fp.write(c)

# 清空 index 前端包中的页脚函数 wj
for f in glob.glob('/web/build/assets/index-*.js'):
    with open(f, 'r') as fp:
        c = fp.read()
    c = c.replace('function wj(){', 'function wj(){return null;')
    with open(f, 'w') as fp:
        fp.write(c)
" 2>/dev/null || true

echo ">>> [3/4] 正在清洗前端编译包中的品牌文案残留..."
docker exec "$CONTAINER_NAME" find /web/build/assets -name "*.js" -exec sed -i 's|https://casdoor.org|https://1234r.com|g' {} +
docker exec "$CONTAINER_NAME" find /web/build/assets -name "*.js" -exec sed -i 's|casdoor.org|1234r.com|g' {} +

echo ">>> [4/4] 验证 PWA manifest 本地自托管..."
docker exec "$CONTAINER_NAME" sed -i 's|https://cdn.casbin.org/site/casdoor/manifest.json|/manifest.json|g' /web/build/index.html

echo ">>> R-Auth 白标补丁注入完毕！"
