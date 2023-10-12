# ---- Dependencies ----
FROM node:16-alpine AS build
WORKDIR /app
COPY  . /app
RUN yarn install
RUN yarn build

ENV SUBCONVERTER_VERSION=v0.8.1

WORKDIR /
RUN apk add --no-cache bash git curl zip
RUN if [ "$(uname -m)" = "x86_64" ]; then export PLATFORM=linux64 ; else if [ "$(uname -m)" = "aarch64" ]; then export PLATFORM=aarch64 ; fi fi \
  && wget https://github.com/tindy2013/subconverter/releases/download/${SUBCONVERTER_VERSION}/subconverter_${PLATFORM}.tar.gz \
  && tar xzf subconverter_${PLATFORM}.tar.gz

FROM nginx:1.16-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=build /subconverter /base
COPY --from=build /app/start.sh /app/start.sh
COPY --from=build /app/dist/conf/config.js /app/conf/config.js
EXPOSE 80
CMD [ "sh", "-c", "/app/start.sh" ]
