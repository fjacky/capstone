
# Capstone Project


Since the serverless Todo app already fulfills all the capstone requirements, I decided to combine it with the techniques presented in the microservices part. I created a fully automated CI/CD pipeline which is triggered on each commit to the GitHub Repository.

  

This CI/CD pipeline automatically deploys the serverless services, and builds a docker container containing the frontend and publishes it to DockerHub. This docker image can then easily be pulled from an EKS cluster.

  

The deployed application is accessible under http://af2109b1a164d461585753709bfee10f-481974384.eu-central-1.elb.amazonaws.com:3000/

  

## Functionality of the application

  

This application allows creating/removing/updating/fetching TODO items. Each TODO item can optionally have an attachment image. Each user only has access to TODO items that he/she has created.

  

## Components

Amazon EKS is used to deploy a kubernetes cluster which serves the frontend and performs load balancing. The frontend itself makes REST calls which are served by the Amazon API Gateway. This API Gateway, with all the serverless services behing it, is deployed using Cloud Formation which programmatically creates and deploys various services to respond to the calls. These services are Lambda functions, an S3 bucket as well as a DynamoDB database. To implement authentication, Auth0 is used to with asymetrically encrypted JWT tokens for authentication.

  

# How to run the application

  

## CI/CD

Travis-CI is used to trigger a deployment of the backend to AWS on each commit. The API-ID remains constant, as long as the deployment is not removed. If you would like to redeploy the backend application to your own AWS account or run locally, you will need to perform some actions as described in the following subsections. The docker image for the frontend is also created and pushed to DockerHub. EKS will not automatically re-pull this image. To trigger an image repull, just remove the running pods, since recreation will pull the latest image.

  

For full deployment of the frontend to AWS, the shell script in `client/deploy/deployment.sh` can be executed.



## Backend

To deploy the backend part of the application manually, run the following commands:

```
cd backend
npm install
sls deploy -v

```

You will need to configure the API parameters for the frontend if using a different CloudFormation Stack.

  
  

## Frontend

A docker image is created of the frontend on each commit, and pushed to the DockerHub repository fjacky/todofrontend. You can create this Docker image manually using `docker build -t todofrontend client/` which uses the Dockerfile stored in the client folder.

  

The application in the container is exposed on port 3000. To run it, make sure to use the port mapping. So for example, to run this docker image locally, you would use

  

```
docker run -ti -p 3000:3000 todofrontend

```

  

and then access it on http://localhost:3000. Note that since the Auth0 application is configured to restrict origin/callback URLs, you must use port 3000 if using the current Auth0 configuration. 

Also, if you are running the latest docker image from fjacky/todofrontend, it will contain the callback URL for the deployed application on AWS, and thus, after login you will actually be redirected to the deployed frontend instead of the local one. Since this is a different application, this will result in an invalid_token error. If you want to run the frontend fully locally, or if you are using a different Cloudformation deployment, you will need to edit the `client/src/config.ts` file first. If running locally, it is enough to set the callback URL to http://localhost:3000/callback. If using a different deployment, you will also need to adjust the parameters for the API. Afterwards you can manually create a new docker image as described above and run it.

However, for development purposes it may be easier to start a development server locally instead. This can be achieved by running the following commands:  

```

cd client
npm install
npm run start

```

This will print the URL to access the frontend to the terminal.

# Images
The folder `images` contains images of the travis build pipeline and the dockerhub repository, showing the CI/CD pipeline in action.