FROM node:21.2.0

USER node
WORKDIR /app

RUN git clone https://github.com/omnitool-ai/omnitool.git
RUN cd omnitool && yarn install

RUN mkdir -p /app/omnitool/node_modules
RUN chmod -R 0777 /app
RUN chown -Rh node:node /app
COPY --chown=node . /app
COPY --chown=node ./patches /app/omnitool/

EXPOSE 4444
ENTRYPOINT ["node", "proxy.js","--tls-min-v1.0"]
