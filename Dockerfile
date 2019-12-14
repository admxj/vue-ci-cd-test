FROM node:12.9.1-alpine as builder
COPY . /admin-template
WORKDIR /admin-template
ARG envType
RUN NODE_ENV=$envType yarn --registry=https://registry.npm.taobao.org \
    && NODE_ENV=$envType yarn build
FROM daocloud.io/nginx:1.11-alpine
RUN sed -i 's/dl-cdn\.alpinelinux\.org/mirrors.hxsf.work/g' /etc/apk/repositories \
    && apk add --update bash curl tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \
    && sed -i 's#mirrors\.hxsf\.work#mirrors.aliyun.com#g' /etc/apk/repositories
COPY --from=builder /code/dist /www
COPY --from=builder /code/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /code/nginx/conf.d/ /etc/nginx/conf.d/
CMD ["nginx", "-g", "daemon off;"]
