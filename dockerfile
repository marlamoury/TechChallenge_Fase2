# Use a imagem do .NET SDK para build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /App

# Copie apenas os arquivos necessários
COPY ContactManagement.Api/ContactManagement.Api.csproj ./ContactManagement.Api/
RUN dotnet restore ./ContactManagement.Api

# Copie o restante e publique
COPY . ./
WORKDIR /App/ContactManagement.Api
RUN dotnet publish -c Release -o /out

# Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /out .
EXPOSE 5000
ENTRYPOINT ["dotnet", "ContactManagement.Api.dll", "--urls", "http://0.0.0.0:5000"]