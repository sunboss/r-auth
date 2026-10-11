# Casdoor (R通行证) 统一身份认证中枢运维手册

## 1. 架构总览
- 核心服务：casdoor (casbin/casdoor:4.18.0)，内部监听 8000 端口
- 数据库架构：收敛至新机基础设施共享数据库集群 r-postgres-shared:5432/casdoor
  - 凭证存储：/data/sunboss/casdoor/.env (权限 0600)
- 品牌静态资源挂载：./www -> /web/build/brand
- 灰度验证入口：https://auth.1118.si/
- 正式生产域名：https://auth.1234r.com/

## 2. 常用操作指令
```bash
# 查看健康状态与日志
docker ps --filter "name=casdoor"
docker logs -f casdoor

# 检查数据库表与连接
PG_PASS=$(grep POSTGRES_PASSWORD /data/sunboss/infra-db/.env | cut -d= -f2)
docker exec -e PGPASSWORD="$PG_PASS" -i r-postgres-shared psql -U casdoor -d casdoor -c "\dt"
```
