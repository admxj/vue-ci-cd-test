alpineFROM node:12.9.1-alpine as builder
COPY . /admin-template
WORKDIR /admin-template
ARG envType
RUN NODE_ENV=$envType yarn --registry=https://registry.npm.taobao.org \
    && NODE_ENV=$envType yarn build
FROM daocloud.io/nginx:1.11-alpine
COPY --from=builder /code/dist /www
COPY --from=builder /code/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /code/nginx/conf.d/ /etc/nginx/conf.d/
CMD ["nginx", "-g", "daemon off;"]
