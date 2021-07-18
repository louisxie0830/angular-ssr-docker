FROM node:lts as builder

# ARG-defined
ARG DEPLOY_ENV=sit

# Create app directory
WORKDIR /app
RUN apt-get update && apt-get install git python make build-essential -y

RUN npm install -g node-pre-gyp node-gyp @angular/cli@11.1.4

# Remove package-lock.json
RUN rm -f package-lock.json
RUN rm -rf dist

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package.json ./
ENV NPM_CONFIG_LOGLEVEL error

# Install app dependencies
RUN npm install --production

# Bundle app source
COPY . .

# build app for production with minification
RUN npm run build:ssr


FROM node:lts
# Bundle APP files
WORKDIR /app
COPY --from=builder /app /app
EXPOSE 4000

CMD ["npm","run","serve:ssr"]
