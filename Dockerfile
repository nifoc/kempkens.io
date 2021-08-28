FROM klakegg/hugo:onbuild AS hugo

FROM nginx:mainline-alpine

COPY --from=hugo /target /usr/share/nginx/html
