# multi stage docker image build
FROM node:alpine
WORKDIR '/app'
COPY package*.json ./
RUN npm install
# aws sometimes has tough time with '.' folder
COPY ./ ./ 
RUN npm run build

FROM nginx
EXPOSE 80
COPY --from=0 /app/build /usr/share/nginx/html