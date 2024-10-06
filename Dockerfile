# Stage 1: Build the Blazor WASM app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set working directory inside the container
WORKDIR /app

# Copy the csproj and restore any dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application code
COPY . ./

# Build the application in Release mode
RUN dotnet publish -c Release -o /out

# Stage 2: Serve the Blazor app using NGINX
FROM nginx:alpine AS final

# Copy the Blazor app to NGINX
COPY --from=build /out/wwwroot /usr/share/nginx/html

# Expose port 80 for the application
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
