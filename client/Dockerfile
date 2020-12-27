
FROM node:13

WORKDIR /app


COPY package*.json ./
RUN npm install --silent
RUN npm install react-scripts -g

COPY . .

CMD [ "npm", "start"]

