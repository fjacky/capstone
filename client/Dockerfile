
FROM node:13

WORKDIR /app


COPY package*.json ./
RUN npm install --silent
RUN npm install react-scripts -g

COPY . .

EXPOSE 3000

CMD [ "npm", "start"]

ENTRYPOINT ["tail", "-f", "/dev/null"]
