FROM node:12.9.1-alpine as builder
COPY . /code
WORKDIR /code
ARG envType
RUN NODE_ENV=$envType yarn --registry=https://registry.npm.taobao.org \
    && NODE_ENV=$envType yarn build
FROM daocloud.io/nginx:1.11-alpine
COPY --from=builder /code/dist /www
COPY --from=builder /code/nginx/nginx.conf /etc/nginx/nginx.conf
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY --from=builder /code/nginx/conf.d/www.conf /etc/nginx/conf.d/default.conf
CMD ["nginx", "-g", "daemon off;"]
